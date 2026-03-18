
# Librerías ----
library(tidyverse)
library(srvyr)
library(foreign)

list.files(pattern = ".dbf", 
           recursive = TRUE, full.names = TRUE) %>% 
  writeLines()

# concentrado_hogares <- read.dbf("enigh/concentrado_hogar.rds")
concentrado_hogares <- read.dbf("enigh/concentradohogar.dbf")

concentrado_hogares %>%
  as_tibble() %>% 
  as_survey_design(ids = upm, 
                   strata = est_dis, 
                   weights = factor,
                   nest = TRUE) %>% 
  summarise(ing_prom = survey_mean(ing_cor, na.rm = T, vartype = "ci"), 
            ing_trab_promedio = survey_mean(ingtrab, na.rm = T, vartype = "ci")
            )


concentrado_hogares %>%
  as_tibble() %>% 
  as_survey_design(ids = upm, 
                   strata = est_dis, 
                   weights = factor,
                   nest = TRUE) %>% 
  summarise(rentas_prom = survey_mean(rentas, na.rm = T, vartype = "ci"))


# concentrado_hogares$ing_cor
# mean(concentrado_hogares$ing_cor)


# sum(concentrado_hogares$factor)
# 38,830,230

# ingresos corrientes por estados

ing_prom_estados <- concentrado_hogares %>%
  as_tibble() %>% 
  mutate(cve_ent = str_extract(ubica_geo, pattern = "^\\d\\d")) %>% 
  as_survey_design(ids = upm, 
                   strata = est_dis, 
                   weights = factor,
                   nest = TRUE) %>% 
  group_by(cve_ent) %>% 
  summarise(ing_prom_estado = survey_mean(ing_cor, na.rm = T, vartype = "ci"))

ing_prom_estados %>%
  arrange(-ing_prom_estado)



#gasto corriente por estado
gast_prom_estados <- concentrado_hogares %>% 
  as_tibble() %>%
  mutate(cve_ent = str_extract(ubica_geo, pattern = "^\\d\\d" )) %>% 
  as_survey_design(ids = upm, strata = est_dis, weights = factor, nest = TRUE) %>% 
  group_by(cve_ent) %>% 
  summarise(gast_prom_estados = survey_mean(gasto_mon, na.rm = T, vartype = "ci"))

gast_prom_estados %>% 
  arrange(-gast_prom_estados)

# Cargo la tabla de poblacion ----
poblacion <- read.dbf("enigh/poblacion.dbf") %>% tibble() %>% 
  select(folioviv, foliohog, numren, sexo, factor, upm, est_dis )

ingresos <- read.dbf("enigh/ingresos.dbf") %>% tibble() %>% 
  filter(clave %in% c("P001", "P004", "P006", 
                      "P007","P008", "P009")) %>% 
  group_by(folioviv, foliohog, numren) %>% 
  summarise(ing_tri = sum(ing_tri, na.rm = T))

tabla_ingreso_sexo <- left_join(poblacion, ingresos,
                                by = c("folioviv", 
                                      "foliohog",
                                      "numren"))

ingreso_trabajo_por_sexo <- tabla_ingreso_sexo %>% 
  as_survey_design(ids = upm, 
                   strata = est_dis, 
                   weights = factor, 
                   nest = TRUE) %>% 
  group_by(sexo) %>% 
  summarise(ing_prom_sexo = survey_mean(ing_tri, 
                                      na.rm = TRUE,
                                      vartype = c("ci", "se"))) %>% 
  mutate(sexo_2 = ifelse(sexo == 1, yes = "Hombre", no = "Mujer"))



ingreso_trabajo_por_sexo %>% 
  ggplot(aes(x = sexo_2, 
             y = ing_prom_sexo, 
             fill = sexo_2)) + 
  geom_col() + 
  geom_errorbar(aes(ymin = ing_prom_sexo_low, 
                    ymax = ing_prom_sexo_upp)) + 
  scale_fill_manual(values = c("Hombre" = "green", 
                               "Mujer" = "#eb02b1")) + 
  labs(title = "Ingreso trimestral laboral promedio por sexo", 
       subtitle = "Datos de la ENIGH, 2024", 
       y = "Ingreso", fill = "Sexo: ", x = NULL) + 
  theme_minimal() + 
  theme(plot.title = element_text(face = "bold"),
        legend.position = "bottom") 
  
  
