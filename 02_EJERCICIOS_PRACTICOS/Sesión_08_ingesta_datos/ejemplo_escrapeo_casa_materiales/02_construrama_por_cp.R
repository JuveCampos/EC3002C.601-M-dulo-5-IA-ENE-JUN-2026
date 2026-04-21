# =============================================================
# 02_construrama_por_cp.R
# =============================================================
# Propósito: intentar obtener precios de Construrama (red Cemex)
# para los 3 códigos postales objetivo:
#
#   - 64000 Monterrey, Nuevo León
#   - 06000 Centro, Ciudad de México
#   - 62854 Xochitepec, Morelos
#
# Este script documenta el proceso completo de ingeniería
# inversa del flujo XHR de Construrama: desde el "Elige tienda"
# en el HTML público hasta la página de producto filtrada por
# tienda (/<urlAlias>/p/<sku>). El camino técnico quedó resuelto
# y reproducible.
#
# El hallazgo sustantivo al final: Construrama es una red de
# franquicias independientes de Cemex y NO publica precios
# al público anónimo, aunque la URL por tienda responda HTTP
# 200. El precio aparece como "$0.00" en el HTML en todas las
# tiendas que probamos. Para obtener precio real se necesita
# autenticación B2B (cuenta de cliente mayorista).
#
# Aun así, este script deja construido el camino funcional
# para: catálogo completo + identificación de tienda por CP,
# que ya de por sí es útil para análisis de cobertura y marcas.
# =============================================================

library(tidyverse)
library(rvest)
library(httr2)
library(jsonlite)

# --- Configuración -------------------------------------------

user_agent <- paste0(
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ",
  "AppleWebKit/537.36 (KHTML, like Gecko) ",
  "Chrome/122.0.0.0 Safari/537.36"
)

base_url <- "https://www.construrama.com"

pausa <- function(min_s = 1, max_s = 2) {
  Sys.sleep(runif(1, min_s, max_s))
}

# Helper con cookies preservadas (por si hiciera falta sesión)
cookie_jar <- tempfile(fileext = ".cookies")

req_cr <- function(path, query = NULL, ajax = FALSE) {
  req <- request(paste0(base_url, path)) %>%
    req_user_agent(user_agent) %>%
    req_timeout(30) %>%
    req_cookie_preserve(cookie_jar) %>%
    req_headers(
      "Accept-Language" = "es-MX,es;q=0.9,en;q=0.8"
    )
  if (!is.null(query)) req <- req %>% req_url_query(!!!query)
  if (ajax) {
    req <- req %>% req_headers(
      "X-Requested-With" = "XMLHttpRequest",
      "Accept" = "application/json, text/javascript, */*; q=0.01"
    )
  }
  req %>% req_perform()
}

# Parser tolerante para respuestas JSON que a veces vienen
# doble-codificadas (el string JSON externo contiene otro JSON)
parse_json_cr <- function(txt) {
  x <- fromJSON(txt, simplifyVector = FALSE)
  if (is.character(x)) fromJSON(x, simplifyVector = FALSE) else x
}

# --- Paso 1: descargar catálogo nacional de tiendas ----------
# El endpoint devuelve ~1 MB de JSON con 937 tiendas en 31
# estados, cada una con storeId, urlAlias, lat/lon, postalCode.

cat("Paso 1: descargar catálogo de tiendas...\n")
raw_stores <- req_cr("/Comun/store-finder/getStoresByStateAndCity",
                     ajax = TRUE) %>%
  resp_body_string() %>%
  parse_json_cr()

# --- Paso 2: aplanar a tibble --------------------------------

get_f <- function(x, k, d = NA) {
  if (is.list(x) && !is.null(x[[k]])) x[[k]] else d
}

tiendas <- raw_stores %>%
  map(function(estado) {
    if (!is.list(estado)) return(tibble())
    estado$cities %||% list() %>%
      map(function(ciudad) {
        if (!is.list(ciudad)) return(tibble())
        ciudad$stores %||% list() %>%
          map(function(t) {
            if (!is.list(t)) return(tibble())
            tibble(
              estado    = as.character(get_f(estado, "stateDesc")),
              ciudad    = as.character(get_f(ciudad, "cityName")),
              google_id = as.character(get_f(ciudad, "googleId")),
              store_id  = as.character(get_f(t, "storeId")),
              alias     = as.character(get_f(t, "urlAlias")),
              nombre    = as.character(get_f(t, "displayName")),
              cp_tienda = as.character(get_f(t, "postalCode")),
              town      = as.character(get_f(t, "town")),
              lat       = as.numeric(get_f(t, "latitude", NA_real_)),
              lon       = as.numeric(get_f(t, "longitude", NA_real_))
            )
          }) %>%
          list_rbind()
      }) %>%
      list_rbind()
  }) %>%
  list_rbind()

print(paste("Tiendas descargadas:", nrow(tiendas)))

# --- Paso 3: buscar tienda más cercana a cada CP objetivo ----
# Coordenadas aproximadas (centroide) de cada CP. Para un
# despliegue real se usaría la API de CodigoPostal de SEPOMEX
# o la de Google Geocoding para resolver CP -> (lat, lon).

cps_objetivo <- tribble(
  ~cp,     ~ciudad_ref,             ~lat_ref,  ~lon_ref,
  "64000", "Monterrey Centro, NL",  25.6714,   -100.3094,
  "06000", "Centro, CDMX",          19.4356,    -99.1402,
  "62854", "Xochitepec, Morelos",   18.7502,    -99.2277
)

# Distancia Haversine (km) entre dos puntos geográficos
haversine_km <- function(lat1, lon1, lat2, lon2) {
  r <- 6371
  p <- pi / 180
  a <- 0.5 - cos((lat2 - lat1) * p) / 2 +
    cos(lat1 * p) * cos(lat2 * p) *
    (1 - cos((lon2 - lon1) * p)) / 2
  2 * r * asin(sqrt(a))
}

tiendas_validas <- tiendas %>%
  filter(!is.na(lat), !is.na(lon), lat != 0, alias != "",
         !is.na(alias))

# Para cada CP, tomar la tienda más cercana
tienda_por_cp <- cps_objetivo %>%
  mutate(
    tienda = pmap(
      list(lat_ref, lon_ref),
      function(la, lo) {
        tiendas_validas %>%
          mutate(dist_km = haversine_km(la, lo, lat, lon)) %>%
          arrange(dist_km) %>%
          slice_head(n = 1)
      }
    )
  ) %>%
  unnest(tienda)

cat("\nTienda más cercana a cada CP:\n")
tienda_por_cp %>%
  select(cp, ciudad_ref, nombre, alias, ciudad, cp_tienda,
         dist_km) %>%
  print()

# --- Paso 4: elegir SKUs de prueba (aceros y cemento) --------
# Tomamos 4 SKUs conocidos del sitemap, con énfasis en aceros.

skus_prueba <- tribble(
  ~sku,          ~descripcion,
  "0201000002",  "Deacero Alambre Galvanizado Cal 12.5, Kg",
  "0201000008",  "Deacero Alambre Recocido Cal 16, Kg",
  "0101000003",  "Cemex Cemento Gris CPC40RS big bag tonelada",
  "0101000002",  "Cemex Cemento Gris CPC40 big bag tonelada"
)

# --- Paso 5: consultar precio por (tienda x producto) -------
# El camino descubierto: URL /<alias>/p/<sku> abre la página
# del producto en la tienda específica, saltándose el modal
# de "elige tienda". Si la tienda publica precio, está en
# .andes-money-amount o en patrones "$n,nnn.nn".

obtener_precio_tienda <- function(alias, sku) {
  url <- paste0("/", alias, "/p/", sku)
  body <- req_cr(url) %>% resp_body_string()

  precios_crudo <- str_extract_all(
    body, "\\$\\s*[0-9][0-9,]*\\.[0-9]{2}"
  )[[1]] %>%
    unique() %>%
    discard(~ .x == "$0.00")

  precio_num <- if (length(precios_crudo) > 0) {
    precios_crudo[[1]] %>%
      str_replace_all("[^0-9.,]", "") %>%
      str_replace_all(",", "") %>%
      parse_double()
  } else {
    NA_real_
  }

  tibble(
    sku = sku,
    url = paste0(base_url, url),
    pide_cp = str_detect(body, "Para ver precio"),
    precio_publicado = precio_num,
    precio_raw = if (length(precios_crudo) > 0) {
      precios_crudo[[1]]
    } else {
      NA_character_
    }
  )
}

# Grid: 3 CPs × 4 SKUs = 12 requests
matriz <- crossing(
  tienda_por_cp %>%
    select(cp, ciudad_ref, alias, nombre, dist_km),
  skus_prueba
)

resultados <- matriz %>%
  mutate(
    consulta = pmap(
      list(alias, sku),
      function(a, s) {
        pausa()
        tryCatch(
          obtener_precio_tienda(a, s),
          error = function(e) {
            tibble(sku = s, url = NA, pide_cp = NA,
                   precio_publicado = NA, precio_raw = NA)
          }
        )
      }
    )
  ) %>%
  unnest(consulta, names_sep = "_") %>%
  select(cp, ciudad_ref, nombre, alias, dist_km,
         descripcion, consulta_sku, consulta_url,
         consulta_pide_cp, consulta_precio_publicado,
         consulta_precio_raw)

print(resultados, width = Inf)

# --- Paso 6: reporte honesto ---------------------------------
# Resumen de cuántas combinaciones arrojaron precio numérico.

reporte <- resultados %>%
  group_by(cp, ciudad_ref, nombre) %>%
  summarise(
    n_consultas = n(),
    n_con_precio = sum(!is.na(consulta_precio_publicado)),
    n_pide_cp = sum(consulta_pide_cp, na.rm = TRUE),
    .groups = "drop"
  )

print(reporte)

# Persistir salidas
write_csv(tiendas, "construrama_tiendas_nacional.csv")
write_csv(tienda_por_cp, "construrama_tienda_por_cp.csv")
write_csv(resultados, "construrama_precios_por_cp.csv")
write_csv(reporte, "construrama_precios_reporte.csv")

# =============================================================
# Conclusión técnica (para comentar en clase)
# =============================================================
# 1. Flujo XHR de Construrama totalmente mapeado:
#      GET  /Comun/store-finder/getStoresByStateAndCity
#           -> catálogo de 937 tiendas con lat/lon/urlAlias
#      GET  /Comun/store-finder/getPlaceIdFromGoogle?lat=&lng=
#           -> place_id de Google (proxy gratuito)
#      GET  /Comun/store-finder/setStoresByCity?cityId=...
#           -> fija cobertura en sesión
#      GET  /<urlAlias>/p/<sku>
#           -> página del producto en la tienda, sin modal
#
# 2. La URL /<urlAlias>/p/<sku> funciona SIN sesión: basta
#    construirla con el alias de la tienda y el SKU.
#
# 3. Los precios en HTML vienen como "$0.00" para todas las
#    tiendas probadas. El sitio es de cara al público pero
#    sólo publica catálogo, no precios. Para precios reales:
#      - login B2B (cuenta mayorista con cliente) o
#      - contactar tienda física para cotización
#
# 4. Para análisis de precios comparables, el camino efectivo
#    sigue siendo Mercado Libre (ver 01_prueba_escrapeo.R),
#    complementado con el INPP de materiales de construcción
#    del INEGI como ancla oficial.
