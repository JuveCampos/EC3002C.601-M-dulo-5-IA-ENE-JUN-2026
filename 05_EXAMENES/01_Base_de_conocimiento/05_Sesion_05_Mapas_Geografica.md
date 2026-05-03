# Sesión 05 — Mapas e información geográfica

## Programa de la clase
Manejo de información geográfica en R: conceptos básicos, librerías `sf`, `terra`, `leaflet`, formatos de archivos, sistemas de coordenadas y construcción de mapas estáticos e interactivos.

## Herramientas de manejo de información geográfica (SIG)

| Herramienta | Tipo | Notas |
|---|---|---|
| **ArcGIS** (Esri) | SIG líder, comercial (caro) | Estándar de la industria |
| **QGIS (Quantum GIS)** | Código abierto, gratis | Alternativa libre a ArcGIS |
| **Google Earth Engine** | Plataforma cloud | Análisis a escala global |
| **AutoCAD Map 3D** (Autodesk) | CAD + SIG | Para diseño con datos espaciales |
| **GRASS GIS** | Modelado | Nicho |
| **ERDAS IMAGINE** | Análisis de imágenes satelitales | Nicho |
| **PostGIS** | Extensión espacial de PostgreSQL | Almacenamiento de datos espaciales |

### ¿Por qué usar R (o Python)?
1. **Integración**: todo el análisis en la misma herramienta y workspace.
2. **Automatización**: scripts permiten repetir procesos complejos.
3. **Comunidad y recursos**: gran cantidad de paquetes y comunidad activa.

> La gran mayoría de los mapas usados en economía se pueden hacer en R.

## Información geográfica: definición

> Información geográfica = **componente espacial** (ubicación) + **atributo(s)** (información descriptiva).

- **Componente espacial**: puntos, líneas, polígonos, áreas, matrices de píxeles.
- **Atributos**: nombres de calles, estadísticas, precios, población, índices.

## Formatos de archivos para información geográfica

### Vectoriales
- **ESRI Shapefile** (`.shp`): el más común, diseñado para ArcGIS/QGIS. Compuesto por **múltiples archivos**:
  - `.shp`: geometría (forma) de las entidades.
  - `.dbf`: base de datos en formato dBase con los atributos.
  - `.shx`: índice de geometrías.
  - `.prj`: información sobre el sistema de coordenadas / **proyección cartográfica**.
  - Otros: `.mxs`, `.cpj`, `.ixs`, `.fbn`, `.sbn`.
  - **Ojo**: si se borra uno de los archivos componentes, el shapefile puede no cargar.
- **JSON / GeoJSON / TopoJSON**: muy populares en R y Python. Ligeros, fáciles de almacenar y acceder desde web.
- **KML / KMZ**: formato Google, para usar con Google Maps y Google Earth.
- **CSV / XLSX con coordenadas**: una hoja con columnas de latitud y longitud también puede almacenar info geográfica.

### Raster
- **TIFF / GeoTIFF**: formato más usado para almacenar bases de datos raster e imágenes satelitales georreferenciadas.

## Conceptos importantes antes de mapear

### Mapa
- **Representación gráfica simplificada de un territorio** con propiedades métricas sobre una superficie bidimensional.
- Sirve para visualizar información que **varía o se distribuye en el espacio**.
- Siempre considerar el propósito al elaborar uno (no siempre el mapa es la mejor visualización; a veces una barra ordenada es más clara).

### Sistema de coordenadas de referencia (CRS)
- **CRS** es el sistema de coordenadas que se utiliza para localizar las entidades geográficas.
- Debe incluir: a) **proyección geográfica**, b) **punto de referencia**, c) **sistema de traducción a otro CRS** y d) **datum o elipsoide de referencia**.
- **CRS más común para esta clase**: `EPSG:4326` (WGS84, lat/long). Lo usan por default leaflet y Google Maps.

### Otros CRS útiles
| EPSG | Uso |
|---|---|
| **6372** | Proyección default de **INEGI** (datos de INEGI no siempre vienen en lat/lon) |
| **2163** | Mapas de EE.UU. (US National Atlas Equal Area) |
| **6362** | UTM zona 14N — para pasar de lat/lon a metros en CDMX |

### Claves geoestadísticas INEGI
- Identifican estado, municipio, AGEB, comunidad, colonia o manzana.
- Funcionan como el **ID de un polígono** y son fundamentales para **unir bases de datos atributivas con bases geográficas** (variable "llave" en joins).
- Estructura: `CVEGEO` = `CVE_ENT` (estado, 2 dígitos) + `CVE_MUN` (municipio, 3 dígitos). Ej: `01001` = Aguascalientes.

### Capas
- Las capas son una analogía a **hojas apiladas de acetato**: se modifican individualmente y al final se superponen para generar la visualización final.

## Librerías clave en R

```r
library(tidyverse)
library(sf)          # vectoriales (puntos, líneas, polígonos)
library(readxl)
library(raster)
library(terra)       # raster moderno
library(tidyterra)   # geom_spatraster() para ggplot
library(leaflet)     # mapas interactivos
library(htmlwidgets) # guardar mapas interactivos como HTML
```

## Funciones esenciales de `sf`

| Función | Uso |
|---|---|
| `st_read("archivo.kml")` | Lee shapefile, geojson, kml |
| `st_as_sf(coords = c("lon","lat"), crs = 4326)` | Convierte un dataframe con coordenadas en objeto `sf` |
| `st_write(obj, "archivo.geojson")` | Exporta objeto `sf` |
| `geom_sf()` | Geometría ggplot para datos `sf` |

## Funciones esenciales de `terra`

```r
prec_extrema <- rast("RASTER_prec_9_extrema.tif")
ggplot() +
  geom_spatraster(data = prec_extrema) +
  scale_fill_viridis_c()
```

## Mapas interactivos con `leaflet`

Estructura básica:
```r
leaflet(data = costco) %>%
  addTiles() %>%                          # mapa base de OpenStreetMap
  addCircleMarkers(color = "red",
                   label = costco$nom_estab)
```

Para polígonos con popup y leyenda:
```r
paleta <- colorFactor(domain = mapa$variable,
                      palette = c("navy", "orange", "brown"))

mapa %>%
  leaflet() %>%
  addTiles() %>%
  addPolygons(color = "black",
              weight = 0.5,
              label = str_c("Municipio: ", mapa$NOMGEO),
              popup = str_c("Municipio: ", mapa$NOMGEO, "<br>",
                            "Coalición: ", mapa$coalicion_ganadora),
              fillColor = paleta(mapa$coalicion_ganadora),
              highlightOptions = highlightOptions(
                weight = 2, color = "white",
                fillOpacity = 0.9, bringToFront = TRUE),
              fillOpacity = 0.9) %>%
  addLegend(title = "Coalición",
            pal = paleta, values = mapa$coalicion_ganadora)

htmlwidgets::saveWidget(mapa_interactivo, "mapa.html")
```

## Ejercicios prácticos (script `mapas.R`)

1. **Convertir un excel con coordenadas a `sf`** (delitos 2019 CDMX): `st_as_sf(coords = c("longitud","latitud"), crs = 4326)`.
2. **Cargar polígonos KML** de alcaldías y mapearlas por partido gobernante con `case_when()` y `scale_fill_manual()`.
3. **Cargar geojson** de municipios 2022.
4. **Cargar raster TIFF** de precipitación extrema con `rast()` y graficar con `geom_spatraster()`.
5. **Filtrar y exportar** delitos de la alcaldía Cuauhtémoc a `delitos_cuauhtemoc.geojson` con `st_write()`.
6. **Join geometría con atributos** del IDH municipal de Morelos: `left_join(municipios_morelos_geom, atributos_idh, by = c("CVEGEO" = "CODGEO"))`. Mapear con `scale_fill_viridis_c()` y `theme_minimal()`.
7. **Mapa con fondo negro y líneas amarillas** de la Red Nacional de Caminos CDMX (`geom_sf(color = "yellow4")` + `panel.background = element_rect(fill = "black")`).
8. **Mapa interactivo de Costcos** en México con `leaflet()` + `addCircleMarkers()` + `saveWidget()`.
9. **Mapa interactivo del PREP 2024** (resultados de elección municipal): join municipios + resultados, paleta de coalición ganadora, popup con info por municipio.

## Patrón típico para mapas en R

1. Cargar geometrías (`st_read` / `rast`).
2. Cargar atributos (`read_csv` / `read_excel`).
3. **Unir** geometría + atributos con `left_join` usando una variable llave (típicamente `CVEGEO`).
4. Graficar (`ggplot + geom_sf` para estático, `leaflet` para interactivo).
5. Guardar (`ggsave` para PNG/PDF, `saveWidget` para HTML interactivo).
