
# Librerias ----
library(tidyverse)
library(readxl)

graproes <- read_excel("indicador_municipios_GRAPROES.xlsx")
pobreza <- read_excel("indicador_municipios_POBREZA.xlsx")
poblacion <- read_excel("indicador_municipios_PROY_POBLACION.xlsx")

graproes_2020 <- graproes %>% 
  filter(year == 2020) %>% 
  rename(grado_promedio = valor) %>% 
  select(-c(no, ponderador))

pobreza_2020 <- pobreza %>% 
  filter(year == 2020) %>% 
  rename(pobreza = valor) %>% 
  select(-c(no, ponderador))

poblacion_2020 <- poblacion %>% 
  filter(year == 2020) %>% 
  rename(poblacion = valor) %>% 
  # select(cve_mun, year, poblacion)
  select(-c(no, ponderador))

# Hacer uniones de tablas 
tabla_unida <- left_join(graproes_2020, pobreza_2020, 
          by = c("cve_mun", "year")) %>% 
  left_join(poblacion_2020, by = c("cve_mun", "year"))

# pobreza > 30%; 
# Escolaridad < 9 
# Los más poblados

los_10_municipios_prioritarios <- tabla_unida %>% 
  filter(pobreza > 30) %>% 
  filter(grado_promedio < 9) %>% 
  arrange(-poblacion) %>% 
  head(10)

los_10_municipios_prioritarios

cat_munis <- read_csv("https://raw.githubusercontent.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/master/Datos/cat_mun_revisado.csv")

# Join 
los_10_municipios_prioritarios <- left_join(los_10_municipios_prioritarios, cat_munis,
          by = c("cve_mun" = "cvegeo"))


