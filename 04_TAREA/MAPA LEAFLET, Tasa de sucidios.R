library(tidyverse)
library(sf)
library(leaflet)
library(htmlwidgets)

# PREPARACION DE DATOS
datos_esta <- read_csv("datos_estatales_mapa.csv")

tasa_suicidios <- datos_esta %>% 
  filter(no == 360, year == max(year[no == 360], na.rm = TRUE)) 
entidades_shp <- st_read("estados_32.geojson")

entidades_shp <- entidades_shp %>% 
  rename(cve_ent = CVE_EDO)

mapa_data <- entidades_shp %>%
  left_join(tasa_suicidios, by = "cve_ent")

mapa_data$fecha <- as.Date(paste0(mapa_data$year, "-01-01"))



# CONTRUCCION DEL MAPA
paleta <- colorNumeric("OrRd", domain = mapa_data$valor)

mapa_suicidios <- mapa_data %>% 
  leaflet() %>%
  setView(lng = -102, lat = 23.5, zoom = 5) %>%
  addTiles() %>% 
  addPolygons(color = "black", 
              weight = 0.5, 
              label = ~ENTIDAD,
              popup = ~paste0("<b>Entidad:</b> ", ENTIDAD, "<br>",
                              "<b>Indicador:</b> Tasa de suicidios<br>",
                              "<b>Valor:</b> ", format(round(valor, 2), big.mark = ","), "<br>",
                              "<b>Año:</b> ", year),
              fillColor = paleta(mapa_data$valor),
              highlightOptions = highlightOptions(
                weight = 3,
                color = "white",
                fillOpacity = 0.9,
                bringToFront = TRUE),
              fillOpacity = 0.9) %>% 
  addLegend(title = "Tasa de suicidios",
            pal = paleta, 
            values = mapa_data$valor, 
            position = "bottomright") %>% 
  addControl("<h3>Mapa de tasa de suicidios en México</h3>",
             position = "topright")
mapa_suicidios
  htmlwidgets::saveWidget(widget = mapa_suicidios, 
                        "mapa_suicidios.html")
