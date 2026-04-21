# =============================================================
# 01_prueba_escrapeo.R
# =============================================================
# Propósito: demostrar, con código ejecutable, que se pueden
# escrapear catálogos de precios de materiales para construcción
# y aceros vendidos en línea en México.
#
# Foco temático: varilla corrugada, cemento, alambre recocido
# y lámina de acero (productos típicos de una casa de materiales).
#
# Este script es una PRUEBA DE CONCEPTO. No busca cosechar todo
# el catálogo, sino confirmar extremo a extremo que el pipeline
#       HTTP -> parseo -> tibble con precios
# funciona en varios sitios y con distintas estrategias.
#
# Tras un mapeo inicial de ~10 sitios, el hallazgo honesto es:
#
#   * Mercado Libre México (listado HTML) -> viable sin fricción
#   * Construrama (red Cemex) -> NO es SPA; es SAP Hybris y
#     publica 2048 productos en un sitemap XML público. El
#     catálogo (marca, SKU, unidad, categoría) es cosechable
#     sin JS; los PRECIOS, en cambio, se cargan vía XHR al
#     elegir tienda (CP), así que quedan como siguiente paso.
#   * The Home Depot MX / Sodimac -> son SPAs que hidratan el
#     catálogo con JavaScript. El HTML inicial NO trae
#     productos. Requieren chromote/Playwright. Se muestran
#     aquí como caso negativo ilustrativo.
#   * Sitios regionales (PrestaShop/WooCommerce) -> varían:
#     algunos tiran 403 con User-Agent de bot (ConstruActivo)
#     y otros no publican precios en catálogo sino sólo en
#     cotización (Más Que Materiales).
#
# La API pública JSON de Mercado Libre (/sites/MLM/search) ya
# NO está abierta sin token OAuth (responde 403), por eso este
# script usa el listado HTML público como ruta de entrada.
# =============================================================

library(tidyverse)
library(rvest)
library(httr2)
library(janitor)

# --- Configuración global ------------------------------------

# User-Agent realista: varios sitios responden 403 al default
# de httr2 porque saben que no es un navegador.
user_agent <- paste0(
  "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) ",
  "AppleWebKit/537.36 (KHTML, like Gecko) ",
  "Chrome/122.0.0.0 Safari/537.36"
)

# Pausa educada entre requests para no saturar al servidor
pausa <- function(min_s = 1, max_s = 2) {
  Sys.sleep(runif(1, min_s, max_s))
}

# Helper central: trae una URL como HTML con reintento y UA
pedir_html <- function(url) {
  request(url) %>%
    req_user_agent(user_agent) %>%
    req_timeout(25) %>%
    req_retry(max_tries = 2, backoff = ~ 2) %>%
    req_perform() %>%
    resp_body_html()
}

# Variante para contenido que puede llegar como text/xml o
# text/plain (por ejemplo sitemaps). resp_body_html() rechaza
# estos content-types, así que parseamos el string nosotros.
pedir_markup <- function(url) {
  request(url) %>%
    req_user_agent(user_agent) %>%
    req_timeout(25) %>%
    req_retry(max_tries = 2, backoff = ~ 2) %>%
    req_perform() %>%
    resp_body_string() %>%
    read_html()
}

# Convierte un string tipo "$ 1,234.50" o "$210,60" a numérico.
# En México aparecen dos convenciones mezcladas:
#   "$1,234.50" -> coma = miles, punto = decimal
#   "$210,60"   -> coma = decimal (formato latinoamericano)
# Heurística: si el string termina en ",DD" y NO tiene punto,
# tratamos la coma como decimal; en otros casos, como miles.
limpiar_precio <- function(texto) {
  primero <- texto %>%
    str_extract("[0-9][0-9.,]*")

  tiene_punto <- str_detect(primero, "\\.")
  coma_es_decimal <- !tiene_punto &
    str_detect(primero, ",[0-9]{2}$")

  normalizado <- if_else(
    coma_es_decimal,
    str_replace(primero, ",", "."),
    str_replace_all(primero, ",", "")
  )

  parse_double(normalizado, na = c("", "NA"))
}

# =============================================================
# Bloque 1 — Mercado Libre México vía selectores CSS del listado
# =============================================================
# Estrategia: hacer una búsqueda pública en
# listado.mercadolibre.com.mx y parsear el HTML.
#
# Selectores verificados el 2026-04-21:
#   .poly-card                   -> tarjeta de cada producto
#   a.poly-component__title      -> nombre + URL del producto
#   .andes-money-amount          -> precio visible (el PRIMER
#     match dentro del card es el precio vigente; los siguientes
#     son mensualidades sin intereses o precios tachados)
#   .poly-component__seller      -> vendedor (cuando existe)
#
# Si Mercado Libre renombra estas clases, hay que volver a
# inspeccionar con DevTools. Por eso el Bloque 2 explora una
# ruta alternativa más estable (schema.org JSON-LD).

buscar_ml_listado <- function(consulta) {
  # ML construye la URL con guiones en vez de espacios
  slug <- consulta %>%
    str_to_lower() %>%
    str_replace_all("[/\\s]+", "-")

  url <- paste0("https://listado.mercadolibre.com.mx/", slug)
  html_doc <- pedir_html(url)

  tarjetas <- html_doc %>% html_elements(".poly-card")

  tibble(
    nombre = tarjetas %>%
      html_element("a.poly-component__title") %>%
      html_text2(),
    url = tarjetas %>%
      html_element("a.poly-component__title") %>%
      html_attr("href"),
    # html_element() devuelve el PRIMER match por tarjeta,
    # que es el precio vigente (no las mensualidades posteriores)
    precio_texto = tarjetas %>%
      html_element(".andes-money-amount") %>%
      html_text2(),
    vendedor = tarjetas %>%
      html_element(".poly-component__seller") %>%
      html_text2()
  ) %>%
    mutate(
      precio = limpiar_precio(precio_texto),
      fuente_url = url
    )
}

# Consultas objetivo: materiales pesados y aceros
consultas_objetivo <- c(
  "varilla corrugada 3/8",
  "cemento gris 50 kg",
  "alambre recocido calibre 18",
  "lamina acero galvanizado"
)

# Ejecutamos cada búsqueda con manejo de errores por consulta
resultados_ml <- consultas_objetivo %>%
  set_names() %>%
  map(function(consulta) {
    pausa()
    tryCatch(
      buscar_ml_listado(consulta),
      error = function(e) {
        print(paste("ML falló en:", consulta, "->",
                    conditionMessage(e)))
        tibble()
      }
    )
  }) %>%
  list_rbind(names_to = "consulta")

# Muestra rápida de lo extraído
print(paste("ML productos totales:", nrow(resultados_ml)))
if (nrow(resultados_ml) > 0) {
  resultados_ml %>%
    select(consulta, nombre, precio, vendedor) %>%
    slice_head(n = 8) %>%
    print()
}

# =============================================================
# Bloque 2 — Mercado Libre vía JSON-LD (schema.org)
# =============================================================
# Muchos sitios (incluyendo ML) exponen metadatos estructurados
# schema.org dentro de <script type="application/ld+json">.
# Es MÁS ROBUSTO que parsear CSS porque:
#   - es un estándar W3C, no cambia con el rediseño visual
#   - lo usan Google Rich Results, así que al sitio le conviene
#     mantenerlo estable
#
# Esto es una habilidad transferible: revísalo SIEMPRE antes
# de pelearte con CSS.

extraer_jsonld <- function(url) {
  html_doc <- pedir_html(url)

  scripts <- html_doc %>%
    html_elements('script[type="application/ld+json"]') %>%
    html_text()

  # Cada script puede contener uno o varios objetos Product.
  # Normalizamos todo a una lista plana.
  productos <- scripts %>%
    map(~ tryCatch(jsonlite::fromJSON(.x,
                                      simplifyVector = FALSE),
                   error = function(e) NULL)) %>%
    compact() %>%
    map(function(doc) {
      # schema.org permite @graph o un solo objeto
      if (!is.null(doc$`@graph`)) doc$`@graph` else list(doc)
    }) %>%
    flatten() %>%
    keep(~ identical(.x$`@type`, "Product"))

  # map() + list_rbind() en lugar de lapply: aquí aporta valor
  # porque encadena directo a tibble y trata campos opcionales
  # con %||% sin romper la estructura de columnas.
  productos %>%
    map(function(p) {
      tibble(
        nombre = p$name %||% NA_character_,
        marca = p$brand$name %||% NA_character_,
        precio = p$offers$price %||% NA_real_,
        moneda = p$offers$priceCurrency %||% NA_character_,
        disponibilidad = p$offers$availability %||% NA_character_
      )
    }) %>%
    list_rbind()
}

url_listado_varilla <- paste0(
  "https://listado.mercadolibre.com.mx/",
  "varilla-corrugada-3-8"
)

pausa()
resultados_jsonld <- tryCatch(
  extraer_jsonld(url_listado_varilla),
  error = function(e) {
    print(paste("JSON-LD falló ->", conditionMessage(e)))
    tibble()
  }
)

print(paste("JSON-LD productos extraídos:",
            nrow(resultados_jsonld)))
if (nrow(resultados_jsonld) > 0) {
  resultados_jsonld %>% slice_head(n = 8) %>% print()
}

# =============================================================
# Bloque 3 — Construrama (Cemex) vía sitemap XML
# =============================================================
# Descubrimiento clave: Construrama no es un SPA. Es SAP Hybris
# Commerce y publica TODO su catálogo en un sitemap XML público
# (~2048 URLs de producto, agrupadas en 7 categorías raíz:
# cemento, aceros, otros-materiales, herramientas, acabados,
# plomería y una fila vacía de imágenes).
#
# Cada URL de producto sigue el patrón:
#   /catalogo/<categoria>/<subcategoria>/<slug>/p/<sku>
# y responde HTTP 200 con HTML estático para nombre, marca,
# unidad, breadcrumb y código de fabricante.
#
# Lo que NO está en el HTML: el precio. Aparece literalmente el
# texto "Para ver precio elige una tienda" y el precio se carga
# vía XHR tras escoger CP. Por eso aquí demostramos que el
# CATÁLOGO es cosechable, y dejamos el precio como siguiente
# iteración (capturar la request XHR con DevTools o usar
# chromote para simular la selección de tienda).

descargar_sitemap_construrama <- function() {
  # El sitemap.xml raíz es un índice que apunta a sub-sitemaps.
  # Buscamos el que se llama "Product-..."
  indice <- pedir_markup("https://www.construrama.com/sitemap.xml")

  url_productos <- indice %>%
    html_elements("loc") %>%
    html_text() %>%
    keep(~ str_detect(.x, "Product-")) %>%
    first()

  if (length(url_productos) == 0 || is.na(url_productos)) {
    return(tibble(url = character(), sku = character(),
                  categoria_raiz = character(), slug = character()))
  }

  pedir_markup(url_productos) %>%
    html_elements("url") %>%
    map(function(entrada) {
      loc <- entrada %>% html_element("loc") %>% html_text()
      tibble(
        url = loc,
        sku = str_extract(loc, "(?<=/p/)[0-9]+$"),
        categoria_raiz = str_match(loc, "/catalogo/([^/]+)/")[, 2],
        slug = str_extract(loc, "[^/]+(?=/p/)")
      )
    }) %>%
    list_rbind() %>%
    filter(!is.na(sku))
}

extraer_producto_construrama <- function(url) {
  html_doc <- pedir_html(url)

  titulo_raw <- html_doc %>% html_element("title") %>% html_text2()
  texto <- html_doc %>% html_text2()

  # La unidad aparece como "Unidad: Kilos / Pieza / Saco 50 kg"
  unidad <- str_match(texto, "Unidad:\\s*([A-Za-zñáéíóú ]+)")[, 2] %>%
    str_trim()

  # Señal explícita de que el precio requiere elegir tienda
  pide_cp <- str_detect(texto, "Para ver precio elige una tienda")

  tibble(
    titulo = titulo_raw %>%
      str_remove("\\s*\\|\\s*Construrama\\s*$"),
    unidad = unidad,
    precio_requiere_cp = pide_cp,
    url = url
  )
}

catalogo_construrama <- tryCatch(
  descargar_sitemap_construrama(),
  error = function(e) {
    print(paste("Construrama sitemap falló ->",
                conditionMessage(e)))
    tibble()
  }
)

print(paste("Construrama: productos en sitemap:",
            nrow(catalogo_construrama)))

if (nrow(catalogo_construrama) > 0) {
  catalogo_construrama %>% count(categoria_raiz) %>% print()
}

# Demo: jalar metadatos de 5 productos de la categoría aceros.
# (No cosechamos los 99 disponibles para no abusar del sitio).
muestra_construrama <- if (nrow(catalogo_construrama) > 0) {
  catalogo_construrama %>%
    filter(categoria_raiz == "aceros") %>%
    slice_head(n = 5) %>%
    pull(url) %>%
    map(function(u) {
      pausa()
      tryCatch(
        extraer_producto_construrama(u),
        error = function(e) {
          tibble(titulo = NA_character_, unidad = NA_character_,
                 precio_requiere_cp = NA, url = u)
        }
      )
    }) %>%
    list_rbind()
} else {
  tibble()
}

print(muestra_construrama)

# =============================================================
# Bloque 4 — Diagnóstico de sitios SPA (caso negativo)
# =============================================================
# Propósito didáctico: mostrar en código cómo se ve un sitio
# que NO es scrapeable con el pipeline anterior. The Home Depot
# MX y Sodimac devuelven HTML 200 con ~1 MB, pero el catálogo
# se hidrata con JavaScript. Si buscamos tarjetas de producto
# en el HTML crudo, encontramos 0.
#
# La lección: antes de invertir en selectores, PROBAR si el
# HTML estático ya contiene los datos. Si no, hay dos opciones:
#   (a) levantar un navegador headless (chromote, RSelenium)
#   (b) identificar la API interna XHR que consume el SPA
#       y pegarle directo (DevTools -> Network -> Fetch/XHR).

diagnosticar_spa <- function(url, selectores_candidatos) {
  resultado <- tryCatch({
    html_doc <- pedir_html(url)
    selectores_candidatos %>%
      map_int(~ length(html_elements(html_doc, .x))) %>%
      set_names(selectores_candidatos)
  }, error = function(e) {
    c(error = NA_integer_)
  })

  tibble(
    url = url,
    selector = names(resultado),
    n_encontrados = as.integer(resultado)
  )
}

pausa()
diag_home_depot <- diagnosticar_spa(
  "https://www.homedepot.com.mx/search?q=varilla+corrugada",
  c(".product-pod", ".product-tile", "[data-testid*=product]")
)

pausa()
diag_sodimac <- diagnosticar_spa(
  "https://www.sodimac.com.mx/sodimac-mx/search?Ntt=varilla",
  c(".product-card", ".ui-item", "[class*=Product]")
)

print(bind_rows(diag_home_depot, diag_sodimac))

# =============================================================
# Resumen de factibilidad
# =============================================================

resumen <- tribble(
  ~sitio,                 ~estrategia,                      ~n_productos, ~con_precio,
  "Mercado Libre (CSS)",  "HTML listing + selectores",      nrow(resultados_ml),                    TRUE,
  "Mercado Libre (LD)",   "JSON-LD schema.org",             nrow(resultados_jsonld),                TRUE,
  "Construrama (sitemap)", "sitemap XML + HTML producto",   nrow(catalogo_construrama),             FALSE,
  "Home Depot MX",        "HTML (SPA -> vacío)",            sum(diag_home_depot$n_encontrados, na.rm = TRUE), FALSE,
  "Sodimac MX",           "HTML (SPA -> vacío)",            sum(diag_sodimac$n_encontrados, na.rm = TRUE),    FALSE
) %>%
  mutate(viable_sin_headless = n_productos > 0)

print(resumen)

# =============================================================
# Persistencia de muestras para inspección posterior
# =============================================================

if (nrow(resultados_ml) > 0) {
  write_csv(resultados_ml, "muestra_mercadolibre_css.csv")
}
if (nrow(resultados_jsonld) > 0) {
  write_csv(resultados_jsonld, "muestra_mercadolibre_jsonld.csv")
}
if (nrow(catalogo_construrama) > 0) {
  write_csv(catalogo_construrama, "catalogo_construrama_sitemap.csv")
}
if (nrow(muestra_construrama) > 0) {
  write_csv(muestra_construrama, "muestra_construrama_aceros.csv")
}
write_csv(resumen, "resumen_factibilidad.csv")

# =============================================================
# Siguientes pasos sugeridos
# =============================================================
# 1. Extender el Bloque 1 a paginación (param _Desde_= en la
#    URL de ML) para cosechar más allá de los primeros 50.
# 2. Para Home Depot / Sodimac: abrir DevTools -> Network ->
#    Fetch/XHR en una búsqueda y copiar la petición JSON
#    interna. Suele ser más estable que renderizar con JS.
# 3. Ancla oficial: API del INEGI (BIE) con el INPP de
#    materiales de construcción. Requiere token gratuito en
#    https://www.inegi.org.mx/servicios/api_indicadores.html
#    y sirve para calibrar los precios raspados y detectar
#    outliers/anomalías.
# 4. Candidatos pendientes que respondieron 200 pero requieren
#    exploración de URLs de catálogo: Sucovi, Materiales
#    Cortés, Aceros Levinson, Truper, Deacero.
