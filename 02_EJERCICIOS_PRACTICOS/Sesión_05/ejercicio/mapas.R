
# Librerias ----
library(tidyverse)
library(sf)
library(readxl)
library(raster)
library(terra)
library(tidyterra)
library(leaflet)
library(htmlwidgets)

# Cargue el excel de Delitos 2019 y, a partir de las coordenadas de latitud y longitud, conviertan en un objeto sf. Elabore el mapa.

delitos_2019 <- read_excel("DATOS/DATOS_delitos_2019.xlsx")
class(delitos_2019)

delitos_2019_mapa <- delitos_2019 %>% 
  st_as_sf(coords = c("longitud", "latitud"), crs = 4326)
class(delitos_2019_mapa)

# Mapa ----
delitos_2019_mapa %>% 
  ggplot() + 
  geom_sf(size = 0.01, alpha = 0.01)

# 2. Cargue los polígonos de las alcaldías (alcaldias.kml). Explore los datos, identifique geometrías y atributos. Grafique. Investigue el partido que gobierna cada alcaldía y haga un mapa de alcaldías por partido político.

alcaldias <- st_read("DATOS/POLIGONOS_alcaldias.kml")

alcaldias$Name

alcaldias_partido <- alcaldias %>% 
  mutate(partido_gobernante = case_when(Name %in% c("Cuauhtémoc", 
                                                    "Cuajimalpa de Morelos", 
                                                    "Miguel Hidalgo", 
                                                    "Benito Juárez", 
                                                    "Coyoacán") ~ "PAN", 
                                        Name %in% c("Álvaro Obregón") ~ "PVEM", 
                                        Name %in% c("Xochimilco" ) ~ "PT", 
                                        TRUE ~ "MORENA"
                                        ))
# Mapa partido gobierno 

paleta_partidos <- c("PAN" = "navy",
                     "MORENA" = "brown",
                     "PT" = "red",
                     "PVEM" = "olivedrab")

alcaldias_partido %>% 
  ggplot(aes(fill = partido_gobernante)) + 
  geom_sf() + 
  scale_fill_manual(values = paleta_partidos) + 
  theme_minimal() + 
  labs(title = "Partido gobernante por alcaldía, 2026", 
       fill = "Partido") + 
  theme(legend.position = "bottom")

# 3. Cargue los datos de “POLIGONOS_municipios_2022.geojson”. ¿Qué información encuentra?
  
municipios <- st_read("DATOS/POLIGONOS_municipios_2022.geojson")
class(municipios)

# Cargue los datos del archivo “prec_9_extrema.tif” sobre precipitación extrema en territorio mexicano. ¿Qué tipo de información es? Grafique. 

prec_extrema <- rast("DATOS/RASTER_prec_9_extrema.tif")
# ?rast
ggplot() + 
  geom_spatraster(data = prec_extrema) + 
  scale_fill_viridis_c()

# 5. Exporte solo los delitos pertenecientes a la alcaldía Cuauhtémoc a un archivo llamado “delitos_cuauhtemoc.geojson”. Haga un mapa con esos datos. 

unique(delitos_2019_mapa$AlcaldiaHechos)

# Nos quedamos con los delitos de la cuauhtemoc
delitos_cuauhtemoc <- delitos_2019_mapa %>% 
  filter(AlcaldiaHechos == "CUAUHTEMOC")

# Para guardar los datos en el archivo: 
st_write(obj = delitos_cuauhtemoc,
         "delitos_cuauhtemoc.geojson")

# 6. Cargue el archivo de “Índice de Desarrollo Humano.csv” y replique en ggplot el siguiente mapa (sin el post-it). 


idh <- read_csv("DATOS/DATOS_Indice de Desarrollo Humano.csv")
# Valores del IDH solo de los municipios de Morelos
atributos_idh <- idh %>% 
  filter(Entidad == "Morelos") %>% 
  filter(Year == max(Year))
class(atributos_idh)
# Geometrías solo de los municipios de Morelos
municipios_morelos_geom <- municipios %>% 
  filter(CVE_ENT == "17")
# Junto las geometrías de Morelos con los valores de Morelos
mapx <- left_join(municipios_morelos_geom, atributos_idh, 
          by = c("CVEGEO" = "CODGEO"))

# Elaboramos el mapa: 
mapx %>%
  ggplot(aes(fill = Valor)) +
  geom_sf(color = "gray90") +
  scale_fill_viridis_c() +
  labs(title = "Índice de Desarrollo Humano",
       subtitle = "Año: 2015",
       caption = "Fuente: Informe de Desarrollo Humano Municipal 201-2015.\nTransformando México Desde lo Local") +
  theme_minimal() +
  theme(axis.text = element_blank(),
        panel.grid = element_blank(),
        plot.title = element_text(color = "black",
                                  hjust = 0.5, face = "bold"),
        plot.subtitle = element_text(color = "gray50", hjust = 0.5),
        plot.caption = element_text(hjust = 1, color = "gray50"),
        legend.position = "bottom") +
  guides(fill = guide_colorbar(title.position = "top",
                               title.hjust = 0.5,
                               barwidth = 10))

# Guardamos la imagen: 
ggsave("mapa_morelos.png", height = 10, width = 8)
  
# 7. Cargue el archivo que contiene los datos de la Red Nacional de Caminos de la ciudad de México. Haga un mapa con fondo negro y líneas amarillas con estos datos.

rnc_cdmx <- st_read("DATOS/LINEAS_09_Ciudad de México.geojson")

rnc_cdmx %>% 
  ggplot() + 
  geom_sf(color = "yellow4") + 
  theme(panel.background = element_rect(fill = "black"), 
        panel.grid = element_line(color = "black"))

# 8. Cargue los datos de las ubicaciones del Costco. Haga un mapa de México en el cual se muestren las ubicaciones de los Costcos de todo el país. 

costco <- read_csv("DATOS/PUNTOS_costcos.csv") %>% 
  st_as_sf(coords = c("longitud", "latitud"), crs = 4326)
class(costco)

# Mapa de los costcos de México
mapa_costcos <- leaflet(data = costco) %>% 
  addTiles() %>%
  addCircleMarkers(color = "red", 
                   label = costco$nom_estab)

# Para guardar el archivo: 
htmlwidgets::saveWidget(widget = mapa_costcos, 
                        "mapa_costcos.html")

# 9. Haga un mapa interactivo de los resultados del PREP de la elección de 2024. Con un click, el municipio seleccionado debe mostrar el nombre del municipio, el estado y el porcentaje de votos por partido político.

"DATOS/DATOS_prep_municipal.csv"
prep <- read_csv("DATOS/DATOS_prep_municipal.csv")
class(prep)

municipios
class(municipios)  

mapa_prep <- left_join(municipios, prep, by = c("CVEGEO" = "CVE_INEGI"))


paleta_coalicion <- colorFactor(domain = mapa_prep$coalicion_ganadora, 
                     palette = c("navy", "orange", "brown"))


edos_shp <- read_sf("https://raw.githubusercontent.com/JuveCampos/Shapes_Resiliencia_CDMX_CIDE/master/geojsons/Division%20Politica/DivisionEstatal.geojson")

edos_shp %>% 
  ggplot() + 
  geom_sf()

mapa_prep %>% 
  leaflet() %>% 
  addTiles() %>% 
  addPolygons(color = "black", 
              weight = 0.5, 
              label = str_c("Municipio: ", mapa_prep$NOMGEO), 
              popup = str_c("Municipio: ", mapa_prep$NOMGEO, "<br>", 
                            "Coalición ganadora: ", mapa_prep$coalicion_ganadora),
              fillColor = paleta_coalicion(mapa_prep$coalicion_ganadora), 
              highlightOptions = highlightOptions(
                weight = 2,
                color = "white",
                fillOpacity = 0.9,
                bringToFront = TRUE), 
              fillOpacity = 0.9) %>% 
  addPolygons(data = edos_shp, 
              weight = 3, color = "white", fill = NA) %>% 
  addLegend(title = "Coalición ganadora",
            pal = paleta_coalicion, 
            values = mapa_prep$coalicion_ganadora)
  









