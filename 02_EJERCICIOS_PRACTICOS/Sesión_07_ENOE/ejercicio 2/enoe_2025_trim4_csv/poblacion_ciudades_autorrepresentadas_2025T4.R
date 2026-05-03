# ---------------------------------------------------------------
# Población en ciudades autorrepresentadas - ENOE 2025T4
# Diseño muestral con srvyr a partir de la tabla SDEMT
# ---------------------------------------------------------------

library(readr)
library(dplyr)
library(tidyr)
library(purrr)
library(srvyr)
library(survey)
library(writexl)

# ENOE tiene estratos con un solo PSU; INEGI recomienda "adjust"
options(survey.lonely.psu = "adjust")

# ---------------------------------------------------------------
# 1. Catálogo de ciudades autorrepresentadas
#    Tomado del descriptor de variables (campo CD_A, tabla VIVT).
#    En el CSV los códigos llegan sin cero a la izquierda
#    (ej. "1" en lugar de "01"), por eso se almacenan así.
#    81-86 = "Complemento urbano-rural" -> NO autorrepresentadas
# ---------------------------------------------------------------
catalogo_ciudades <- tribble(
  ~cd_a, ~ciudad,
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
# 2. Lectura de la tabla sociodemográfica (SDEMT) del 2025T4
#    Cada renglón es una persona; fac_tri expande a la población.
# ---------------------------------------------------------------
ruta_sdem <- "ENOE_SDEMT425.csv"

sdem <- read_csv(
  ruta_sdem,
  col_types = cols(.default   = col_character(),
                   fac_tri    = col_double(),
                   est_d_tri  = col_character(),
                   upm        = col_character())
)

stopifnot(all(c("cd_a", "fac_tri", "est_d_tri", "upm",
                "r_def", "c_res") %in% names(sdem)))

# ---------------------------------------------------------------
# 3. Universo poblacional restringido a ciudades autorrepresentadas
#    - r_def == "0" : entrevista con resultado definitivo
#    - c_res en {1,3}: residente habitual o nuevo residente
#    - cd_a en catálogo: excluye complemento urbano-rural (81-86)
# ---------------------------------------------------------------
sdem_universo <- sdem %>%
  filter(r_def == "0",
         c_res %in% c("1", "3"),
         cd_a %in% catalogo_ciudades$cd_a)

# ---------------------------------------------------------------
# 4. Diseño muestral complejo con srvyr
#    - estratos: est_d_tri
#    - PSU/UPM: upm
#    - pesos:   fac_tri
# ---------------------------------------------------------------
disenio_enoe <- sdem_universo %>%
  as_survey_design(ids     = upm,
                   strata  = est_d_tri,
                   weights = fac_tri,
                   nest    = TRUE)

# ---------------------------------------------------------------
# 5. Estimación de población por ciudad con srvyr
#    Iteramos con purrr::map_dfr para evitar un bug de
#    group_by + survey_total en srvyr 1.3.0; cada llamada usa
#    srvyr::filter sobre el diseño y survey_total para expandir.
#    map_dfr aporta valor frente a lapply: combina los resultados
#    en un solo tibble sin necesidad de bind_rows manual.
# ---------------------------------------------------------------
z_95 <- qnorm(0.975)

estimar_poblacion_ciudad <- function(codigo) {
  disenio_enoe %>%
    filter(cd_a == codigo) %>%
    summarise(poblacion = survey_total(vartype = "se")) %>%
    transmute(cd_a               = codigo,
              poblacion_estimada = poblacion,
              error_estandar     = poblacion_se,
              lim_inf_95         = poblacion_estimada - z_95 * error_estandar,
              lim_sup_95         = poblacion_estimada + z_95 * error_estandar,
              coef_variacion     = error_estandar / poblacion_estimada)
}

poblacion_por_ciudad <- catalogo_ciudades$cd_a %>%
  map_dfr(estimar_poblacion_ciudad) %>%
  left_join(catalogo_ciudades, by = "cd_a") %>%
  arrange(desc(poblacion_estimada)) %>%
  select(cd_a, ciudad, poblacion_estimada,
         error_estandar, lim_inf_95, lim_sup_95, coef_variacion)

# Total agregado de las 39 ciudades autorrepresentadas
total_autorrepresentadas <- disenio_enoe %>%
  summarise(poblacion = survey_total(vartype = "se")) %>%
  transmute(cd_a               = "TOTAL",
            ciudad             = "Total ciudades autorrepresentadas",
            poblacion_estimada = poblacion,
            error_estandar     = poblacion_se,
            lim_inf_95         = poblacion_estimada - z_95 * error_estandar,
            lim_sup_95         = poblacion_estimada + z_95 * error_estandar,
            coef_variacion     = error_estandar / poblacion_estimada)

tabla_final <- bind_rows(poblacion_por_ciudad, total_autorrepresentadas)

print(tabla_final, n = Inf)

# ---------------------------------------------------------------
# 6. Exportar a Excel
# ---------------------------------------------------------------
ruta_salida <- "poblacion_ciudades_autorrepresentadas_2025T4.xlsx"

write_xlsx(
  list(`Población 2025T4` = tabla_final),
  path = ruta_salida
)

print(sprintf("Archivo Excel generado: %s (%d ciudades + total)",
              ruta_salida, nrow(poblacion_por_ciudad)))
