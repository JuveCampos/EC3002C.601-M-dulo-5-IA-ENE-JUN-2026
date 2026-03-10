
library(openrouteservice)
library(tidyverse)
library(leaflet)
token = "5b3ce3597851110001cf6248944acc2635404692ab9e65eee60fa366"
ors_api_key("5b3ce3597851110001cf6248944acc2635404692ab9e65eee60fa366")

# Definir el punto de partida (latitud, longitud)
punto_partida <- c(-98.780913, 18.861283)
  # c(-99.166803, 19.420377)
  # c(-3.70379, 40.41678) # Madrid, España
c(-99.166803, 19.420377)
# Generar isocronas
isocronas <- ors_isochrones(locations = list(punto_partida),
                            profile = "driving-car",
                            range = c(600, 1200), 
                            output = "sf") # 600s y 1200s (10 y 20 minutos)
# isocronas %>% class()

# Crear un mapa con leaflet
mapa <- leaflet() %>%
  addTiles() %>%
  addPolygons(data = isocronas, color = "blue", weight = 2, opacity = 0.5, fillOpacity = 0.2) %>%
  addMarkers(lng = punto_partida[1], lat = punto_partida[2], popup = "Punto de partida")

# Mostrar el mapa
mapa



?ors_api_key()
ors_api_key(key = token)
# openrouteservice::ors_isochrones()
# get_isochrone(lat, lng, 15)  # 15-minute isochrone
# ?openrouteservice::ors_isochrones
# 
# ors_profile()

# 18.861283, 
# -98.780913
tibble(lat = 18.861283, 
       lng = -98.780913)

openrouteservice::ors_isochrones()
ors_isochrones(locations = c(18.861283, -98.780913),
              profile = "foot-walking", 
              # api_key = ors_api_key(key = token),
              output = "sf")
