
# Librerías ----
library(tidyverse)
library(readxl)

pob <- read_excel("df_pob_ent2.xlsx")
ncol(pob)
nrow(pob)

# ¿Cuál es el estado con mayor porcentaje de población de pobreza (pobreza) en 2024? 

pob %>% 
  filter(anio == 2024) %>% 
  filter(pobreza == max(pobreza))

pob %>% 
  filter(anio == 2024) %>% 
  arrange(-pobreza)

# ¿Cuál es el estado con menor porcentaje de carencia por acceso a la salud (ic_asalud) en 2024? 
pob %>% 
  filter(anio == 2024) %>% 
  filter(ic_asalud == min(ic_asalud))

pob %>% 
  select(anio, entidad, ic_asalud) %>% 
  filter(anio == 2024) %>% 
  arrange(ic_asalud)

# ¿Cuales son los 10 estados con mayor porcentaje de pobreza extrema en 2024 (pobreza_e)? 

pob %>% 
  select(anio, entidad, pobreza_e) %>% 
  filter(anio == 2024) %>% 
  arrange(desc(pobreza_e)) %>% 
  head(10)

# ¿Cuál es el promedio simple del porcentaje de pobreza moderada de los estados del centro del país (CDMX, Puebla, EDOMEX, Morelos e Hidalgo) en 2024?

pob %>% 
  filter(anio == 2024) %>% 
  filter(entidad_abr_m %in% c("CDMX", "PUE", "MEX", "MOR", "HGO")) %>% 
  summarise(promedio_pobreza = mean(pobreza_m))

# ¿En qué año alcanzó Chiapas su porcentaje más alto de población con carencia por acceso a la seguridad social? 

pob %>% 
  select(anio, entidad, ic_segsoc) %>% 
  filter(entidad == "Chiapas") %>% 
  arrange(desc(ic_segsoc))


# ¿Cuál es el valor más bajo de pobreza que ha alcanzado algún estado (con los datos de la tabla)? 

pob %>% 
  select(anio, entidad, pobreza) %>% 
  filter(pobreza == min(pobreza))

# Obtenga el promedio y la desviación estándar del porcentaje de pobreza para todos los estados, para cada año 
  
unique(pob$anio)

pob %>% 
  group_by(anio) %>% 
  summarise(promedio_estados = mean(pobreza), 
            desviacion_estandar = sd(pobreza), 
            maximo = max(pobreza), 
            minimo = min(pobreza))




  









