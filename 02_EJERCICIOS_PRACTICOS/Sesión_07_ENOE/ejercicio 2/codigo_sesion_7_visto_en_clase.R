
# librerías 
library(tidyverse) # Manejo de datos 
library(srvyr)     # Encuestas 
library(VIM)
library(foreign)

# foreign::read.dbf()

# Cargar los datos 
sdemt <- read_csv("enoe_2025_trim4_csv/ENOE_SDEMT425.csv") %>% 
  janitor::clean_names()

# Estima el total de personas ocupadas en Mexico, por sexo.
sdemt_dis <- sdemt %>% 
  as_survey_design(ids = upm, 
                   # strata = est_d_tri, 
                   weights = fac_tri, 
                   nest = T)

sdemt_dis %>% 
  filter(clase2 == 1) %>% 
  group_by(sex) %>% 
  summarise(total_po = survey_total(vartype = "ci"))

# Estima el total de desocupados por entidad federativa.

bd_plot <- sdemt_dis %>% 
  filter(clase2 == 2) %>% 
  group_by(cve_ent) %>% 
  summarise(total_pdesoc = survey_total(vartype = "ci"))

bd_plot %>% 
  ggplot(aes(x = reorder(factor(cve_ent), total_pdesoc),
             y = total_pdesoc)) + 
  geom_col() + 
  coord_flip() + 
  geom_errorbar(aes(ymin = total_pdesoc_low,
                    ymax = total_pdesoc_upp))

# Calcula la tasa de informalidad laboral por entidad.
total_informales <- sdemt_dis %>% 
  filter(clase1 == 1) %>% 
  filter(emp_ppal == 1) %>% 
  group_by(cve_ent) %>% 
  summarise(total_informales = survey_total())

total_trabajadores <- sdemt_dis %>% 
  filter(clase1 == 1) %>% 
  group_by(cve_ent) %>% 
  summarise(total_trabajadores = survey_total())

left_join(total_formales, total_trabajadores,
          by = "cve_ent") %>% 
  select(-contains("se")) %>% 
  mutate(pp = 100*(total_formales/total_trabajadores)) %>% 
    arrange(-pp)

# Estimación de la tasa de informalidad: 
sdemt_dis %>% 
  filter(clase1 == 1) %>% 
  mutate(dummy_informalidad = ifelse(emp_ppal == 1, 
                                     yes = 1, 
                                     no = 0)) %>% 
  group_by(cve_ent) %>% 
  summarise(tasa_informalidad = 100*survey_mean(dummy_informalidad,
                                            vartype = "ci")) %>% 
  arrange(-tasa_informalidad)

# Calcula el ingreso promedio por nivel educativo.

bd_plot_gpe <- sdemt_dis %>% 
  filter(clase2 == 1) %>% 
  filter(cs_p13_1 != "99") %>% 
  filter(!is.na(cs_p13_1)) %>% 
  filter(ingocup > 0) %>% 
  group_by(cs_p13_1) %>% 
  summarise(ing_prom = survey_mean(ingocup, vartype = "ci")) %>% 
  arrange(-ing_prom) %>% 
  mutate(
    cs_p13_1_rec = case_when(
      cs_p13_1 == "0" ~ "Ninguna",
      cs_p13_1 == "1" ~ "Preescolar",
      cs_p13_1 == "2" ~ "Primaria",
      cs_p13_1 == "3" ~ "Secundaria",
      cs_p13_1 == "4" ~ "Preparatoria o bachillerato",
      cs_p13_1 == "5" ~ "Normal",
      cs_p13_1 == "6" ~ "Carrera técnica",
      cs_p13_1 == "7" ~ "Profesional",
      cs_p13_1 == "8" ~ "Maestría",
      cs_p13_1 == "9" ~ "Doctorado",
      cs_p13_1 == "99" ~ "No sabe",
      TRUE ~ NA_character_
    )
  )
  
bd_plot_gpe %>% 
  ggplot(aes(x = reorder(cs_p13_1_rec, ing_prom), y = ing_prom)) + 
  geom_col() + 
  geom_errorbar(aes(ymin = ing_prom_low, ymax = ing_prom_upp)) + 
  coord_flip()

# Calcula el ingreso por hora trabajada, por sexo.
bd_ing_hora_sexo <- sdemt_dis %>% 
  filter(clase2 == 1) %>% 
  filter(ingocup > 0) %>% 
  group_by(sex) %>% 
  summarise(ing_x_hora = survey_mean(ing_x_hrs, vartype = "ci"))

bd_ing_hora_sexo %>% 
  ggplot(aes(x = factor(sex), y = ing_x_hora, fill = factor(sex))) + 
  geom_col() + 
  geom_errorbar(aes(ymin = ing_x_hora_low, ymax = ing_x_hora_upp))

# Calcula la razon informal/formal por entidad.
sdemt_dis %>% 
  filter(clase2 == 1) %>% 
  mutate(form = ifelse(emp_ppal == 2, yes = 1, no = 0),
         inform = ifelse(emp_ppal == 1, yes = 1, no = 0)) %>% 
  group_by(cve_ent) %>% 
  summarise(razon = survey_ratio(numerator = inform,
                                 denominator = form, 
                                 vartype = "ci")) %>% 
  arrange(razon)

# Calcula percentiles 25, 50 y 75 del ingreso por ocupacion.
sdemt_dis %>% 
  filter(clase2 == 1) %>% 
  filter(ingocup > 0) %>% 
  summarise(ing_q = survey_quantile(ingocup, 
                                quantiles = c(0.25, 0.5, 0.75), 
                                vartype = "ci"))

# Calcula la mediana del ingreso por sexo y nivel educativo.
bd_mediana_sexo_ge <- sdemt_dis %>% 
  filter(clase2 == 1) %>% 
  filter(ingocup > 0) %>% 
  group_by(sex, cs_p13_1) %>% 
  summarise(mediana = survey_quantile(ingocup, 
                                      quantiles = 0.5, 
                                      vartype = "ci")) %>% 
  arrange(-mediana_q50) %>% 
  mutate(
    cs_p13_1_rec = case_when(
      cs_p13_1 == "0" ~ "Ninguna",
      cs_p13_1 == "1" ~ "Preescolar",
      cs_p13_1 == "2" ~ "Primaria",
      cs_p13_1 == "3" ~ "Secundaria",
      cs_p13_1 == "4" ~ "Preparatoria o bachillerato",
      cs_p13_1 == "5" ~ "Normal",
      cs_p13_1 == "6" ~ "Carrera técnica",
      cs_p13_1 == "7" ~ "Profesional",
      cs_p13_1 == "8" ~ "Maestría",
      cs_p13_1 == "9" ~ "Doctorado",
      cs_p13_1 == "99" ~ "No sabe",
      TRUE ~ NA_character_
    )
  )


bd_mediana_sexo_ge %>% 
  ggplot(aes(x = factor(sex), 
             y = mediana_q50, 
             fill = factor(sex))) + 
  geom_col() + 
  facet_wrap(~cs_p13_1_rec) + 
  geom_errorbar(aes(ymin = mediana_q50_low, ymax = mediana_q50_upp))

