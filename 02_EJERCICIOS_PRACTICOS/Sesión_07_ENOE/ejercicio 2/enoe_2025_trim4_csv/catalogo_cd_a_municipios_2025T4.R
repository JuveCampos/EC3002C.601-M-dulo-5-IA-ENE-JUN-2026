# ---------------------------------------------------------------
# Catálogo: ciudades autorrepresentadas (CD_A) y municipios
# que las componen - ENOE 2025T4
#
# Idea: la tabla VIVT contiene, para cada vivienda en muestra,
# la triada (cd_a, cve_ent, cve_mun). Los municipios únicos por
# cd_a se obtienen tomando combinaciones distinct sobre esa triada
# y enriqueciéndola con nombres oficiales (entidad/municipio).
# ---------------------------------------------------------------

library(readr)
library(dplyr)
library(tidyr)
library(tibble)
library(stringr)
library(writexl)
library(mxmaps)

# ---------------------------------------------------------------
# 1. Catálogo de ciudades autorrepresentadas (campo CD_A, tabla VIVT)
#    En el CSV los códigos llegan sin cero a la izquierda
#    (ej. "1" en lugar de "01"); se almacenan así para hacer match
#    directo con el archivo. 81-86 = complemento urbano-rural y
#    se excluyen porque NO son autorrepresentadas.
# ---------------------------------------------------------------
catalogo_ciudades <- tribble(
  ~cd_a, ~ciudad_autorrepresentada,
  "1",  "México",
  "2",  "Guadalajara",
  "3",  "Monterrey",
  "4",  "Puebla",
  "5",  "León",
  "6",  "Torreón",
  "7",  "San Luis Potosí",
  "8",  "Mérida",
  "9",  "Chihuahua",
  "10", "Tampico",
  "12", "Veracruz",
  "13", "Acapulco",
  "14", "Aguascalientes",
  "15", "Morelia",
  "16", "Toluca",
  "17", "Saltillo",
  "18", "Villahermosa",
  "19", "Tuxtla Gutiérrez",
  "20", "Ciudad Juárez",
  "21", "Tijuana",
  "24", "Culiacán",
  "25", "Hermosillo",
  "26", "Durango",
  "27", "Tepic",
  "28", "Campeche",
  "29", "Cuernavaca",
  "30", "Coatzacoalcos",
  "31", "Oaxaca",
  "32", "Zacatecas",
  "33", "Colima",
  "36", "Querétaro",
  "39", "Tlaxcala",
  "40", "La Paz",
  "41", "Cancún",
  "42", "Ciudad del Carmen",
  "43", "Pachuca",
  "44", "Mexicali",
  "46", "Reynosa",
  "52", "Tapachula"
)

# ---------------------------------------------------------------
# 2. Catálogo de municipios desde mxmaps (df_mxmunicipio_2020)
#    Trae state_code (2 dígitos), municipio_code (3 dígitos),
#    state_name y municipio_name -> usados para enriquecer con
#    nombres oficiales de entidad y municipio.
# ---------------------------------------------------------------
data(df_mxmunicipio_2020)

cat_municipios <- df_mxmunicipio_2020 %>%
  select(cve_ent_pad = state_code,
         cve_mun_pad = municipio_code,
         entidad     = state_name,
         municipio   = municipio_name)

# ---------------------------------------------------------------
# 3. Lectura de la tabla de vivienda (VIVT) del 2025T4
#    Cada renglón es una vivienda en muestra. Para este catálogo
#    NO se requieren ponderadores: solo combinaciones únicas.
# ---------------------------------------------------------------
ruta_vivt <- "ENOE_VIVT425.csv"

vivt <- read_csv(
  ruta_vivt,
  col_types = cols(.default = col_character())
)

stopifnot(all(c("cd_a", "cve_ent", "cve_mun") %in% names(vivt)))

# ---------------------------------------------------------------
# 4. Construcción del catálogo CD_A -> municipios
#    - Filtra cd_a dentro del catálogo (excluye 81-86 y blancos)
#    - Descarta filas donde cve_mun viene vacío (INEGI lo omite
#      por baja densidad poblacional, ver descriptor pág. 3)
#    - Toma combinaciones distinct (cd_a, cve_ent, cve_mun)
#    - Empata con nombres oficiales usando códigos con padding
# ---------------------------------------------------------------
catalogo_cd_a_mun <- vivt %>%
  filter(cd_a %in% catalogo_ciudades$cd_a,
         !is.na(cve_mun),
         str_trim(cve_mun) != "") %>%
  distinct(cd_a, cve_ent, cve_mun) %>%
  mutate(cve_ent_pad = str_pad(cve_ent, width = 2, pad = "0"),
         cve_mun_pad = str_pad(cve_mun, width = 3, pad = "0"),
         cvegeo      = paste0(cve_ent_pad, cve_mun_pad)) %>%
  left_join(catalogo_ciudades, by = "cd_a") %>%
  left_join(cat_municipios,    by = c("cve_ent_pad", "cve_mun_pad")) %>%
  arrange(as.integer(cd_a), cve_ent_pad, cve_mun_pad) %>%
  select(cd_a,
         ciudad_autorrepresentada,
         cve_ent = cve_ent_pad,
         entidad,
         cve_mun = cve_mun_pad,
         municipio,
         cvegeo)

# Diagnóstico: filas donde no se encontró nombre de municipio
sin_nombre <- catalogo_cd_a_mun %>%
  filter(is.na(municipio))

if (nrow(sin_nombre) > 0) {
  print(sprintf("ATENCION: %d municipios sin nombre en el catalogo mxmaps",
                nrow(sin_nombre)))
  print(sin_nombre)
}

# ---------------------------------------------------------------
# 5. Resumen: cuántos municipios componen cada ciudad
# ---------------------------------------------------------------
resumen_ciudades <- catalogo_cd_a_mun %>%
  group_by(cd_a, ciudad_autorrepresentada) %>%
  summarise(n_entidades  = n_distinct(cve_ent),
            n_municipios = n(),
            entidades    = paste(sort(unique(entidad)), collapse = "; "),
            municipios   = paste(municipio, collapse = "; "),
            .groups      = "drop") %>%
  arrange(as.integer(cd_a))

print(resumen_ciudades, n = Inf, width = Inf)

# ---------------------------------------------------------------
# 6. Exportar a Excel con dos hojas:
#    - "Catalogo": un renglón por (ciudad, municipio)
#    - "Resumen":  un renglón por ciudad con conteo y lista
# ---------------------------------------------------------------
ruta_salida <- "catalogo_cd_a_municipios_2025T4.xlsx"

write_xlsx(
  list(Catalogo = catalogo_cd_a_mun,
       Resumen  = resumen_ciudades),
  path = ruta_salida
)

print(sprintf("Archivo Excel generado: %s | %d ciudades, %d municipios",
              ruta_salida,
              nrow(resumen_ciudades),
              nrow(catalogo_cd_a_mun)))
