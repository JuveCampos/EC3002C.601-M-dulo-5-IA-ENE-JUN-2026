# Sesión 03 — Tidyverse y ggplot

## Programa de la clase
- ¿Qué es el procesamiento de datos?
- Práctica de apertura de datos.
- Introducción al **tidyverse**: operador pipa (`%>%`), `filter()`, `select()`, `slice()`, `group_by()`, `mutate()`, `summarise()`, `arrange()` y otras funciones adicionales.
- Joins (uniones de tablas).
- Reestructuración de datos (`pivot_longer` / `pivot_wider`).
- Introducción a ggplot.

## Estructuras de datos en R (recapitulación)
- **Escalares**: vectores 1×1.
- **Vectores**: arreglos n×1.
- **Matrices**: arreglos n×n con un único tipo de dato.
- **Arrays**: matrices multidimensionales n×n×…×n.
- **DataFrames**: arreglos n×n con múltiples tipos de dato (la estructura más usada).
- **Listas**: contenedores de cualquier cosa.

## Configuración de un proyecto básico de R

Estructura sugerida de carpetas:
- Carpeta principal con archivo `*.Rproj`.
- Subcarpeta `Data/` para los datos.
- Subcarpeta `Script/` (con `Functions/`, scripts de análisis).
- Subcarpeta `Output/` (con `Plots/` y `Data/`).

### Estructura sugerida de un script
1. Configuración (encabezado con autor, fecha, descripción).
2. Carga de librerías.
3. Carga de parámetros y funciones propias.
4. Carga de datos.
5. Limpieza de datos.
6. Análisis exploratorio de datos.
7. Generación de funciones.
8. Generación y pruebas de modelos.
9. Generación de gráficas.
10. Guardado de archivos.

```r
# -------------------------------------------
# Autor: Juvenal Campos
# Fecha: 2025-08-18
# Proyecto: Ejemplo para el Tec de Monterrey
# Descripción: Script dummy que ilustra la estructura básica.
# -------------------------------------------

# 1) Configuración -------------------------
options(digits = 3)
set.seed(42)

# 2) Carga de librerías ---------------------
library(dplyr)
library(readr)
library(ggplot2)

# 3) Parámetros y funciones propias ---------
params <- list(
  input = "data/input.csv",
  output_dir = "out",
  target = "mpg"
)
paleta_colores <- c("#6950d8", "#3CEAFA", "#00b783",
                    "#ff6260", "#ffaf84", "#ffbd41")
if (!dir.exists(params$output_dir)) dir.create(params$output_dir, recursive = TRUE)

clean_names <- function(x){
  names(x) <- tolower(gsub("[^a-z0-9_]+", "_", names(x)))
  x
}
rmse <- function(y, yhat) sqrt(mean((y - yhat)^2))

# 4) Carga de datos -------------------------
df <- clean_names(mtcars)

# 5) Limpieza de datos ---------------------
df <- df %>%
  mutate(across(everything(), \(v) v)) %>%
  filter(!is.na(.data[[params$target]]))

# 8) Modelado (dummy) -----------------------
mod <- lm(mpg ~ wt + hp, data = df)
pred <- predict(mod, df)
cat("RMSE:", rmse(df$mpg, pred), "\n")

# 9) Gráficas -------------------------------
p <- ggplot(df, aes(wt, mpg)) +
  geom_point() +
  geom_smooth(method = "lm", se = FALSE)
ggsave(file.path(params$output_dir, "scatter.png"), p, width = 5, height = 4, dpi = 150)

# 10) Guardado de archivos ------------------
write_csv(df, file.path(params$output_dir, "data_clean.csv"))
saveRDS(mod, file.path(params$output_dir, "model.rds"))
```

## Importar datos

### Conceptos clave
- **Directorio de trabajo (working directory)**: la carpeta de la computadora donde se está trabajando. Idealmente, ahí van todos los archivos de datos y los archivos derivados.
- **Ubicaciones posibles de un archivo**: A) tu computadora; B) en internet.
- **Archivos en internet**: a veces se leen directamente (texto plano, archivos únicos), otras se descargan (Excel, shapefile, .dta).
- **Archivos locales**: necesitas la **función correcta** y la **ubicación** del archivo.

### Ruta global vs ruta relativa

| | Ruta global (absoluta) | Ruta local (relativa) |
|---|------------------------|------------------------|
| **Definición** | Ruta absoluta y única del archivo en la computadora | Ruta relativa a otra ubicación (al `.Rproj`) |
| **Ejemplo** | `/Users/usuario/Documents/.../empleados_empresa.xlsx` | `01_Datos/empleados_empresa.xlsx` |
| **Ventaja** | Siempre funciona en tu computadora | Funciona en tu compu y en las de otras personas → mejora **replicabilidad** |
| **Desventaja** | No es útil para compartir código | — |

### Tres formas de crear rutas relativas en R
1. Con `setwd()`.
2. Con `here::here()`.
3. **Utilizando archivos de proyecto de RStudio** ← la más recomendada.

> El archivo `.Rproj` actúa como un "ancla": cuando R abre un proyecto, las rutas relativas se interpretan respecto a la carpeta donde está el `.Rproj`.

### Archivos más utilizados para datos
- **Información tabular**: CSV, Excel, .sav (SPSS), JSON.
- **Objetos de R**: .RData, .rds.
- **Información geográfica**: TIFF, GeoJSON, SHP, KML.
- **Otros formatos**: MongoDB, SQL, SQLite.

### Librerías para importar datos

| Librería | Uso |
|----------|-----|
| `library(readr)` | Archivos texto plano (CSV, TSV). |
| `library(readxl)` | Para Excel. |
| `library(haven)` | Para Stata, SAS o SPSS. |
| `library(foreign)` | Para Stata, SAS o SPSS. |
| `library(sf)` | Leer archivos geográficos. |

### Dos formas de importar datos
1. **Asistente de RStudio** (`File > Import Dataset > From__ > Browse > Archivo > Import`).
   - Ventajas: acceso directo, agrega parámetros simples (sheets, skip), visualización previa.
   - Desventajas: pasos extra para replicabilidad, no permite todos los parámetros (stringsAsFactors, encoding).
2. **Sólo con código.**
   - Ventajas: importar múltiples archivos a la vez, agregar argumentos específicos, incluir importación dentro de loops o funciones, más rápido si conoces la función.
   - Desventajas: requiere saber la función exacta, conocer cómo es el archivo por dentro, posibles errores no detectados.

### Problemas comunes de importación
1. **Encodings raros**: el `encoding` es el conjunto de símbolos que un programa usa para desplegar texto. R puede usar uno distinto al de otras oficinas/programas/países; a veces hay que modificarlo.
2. **Errores humanos**:
   - Escribiste mal la ruta y R no encuentra el archivo.
   - No conoces bien el archivo y no te saltaste las líneas necesarias.
   - No especificaste la hoja correcta de Excel.
   - No especificaste el encoding correcto.

## Procesamiento de datos

### Definición
- Es el **proceso previo** a la creación de análisis, modelos y visualizaciones.
- Consiste en tomar una base de datos y darle una estructura útil.
- Siempre hay que tener clara la estructura a la que se quiere llegar.

> Pipeline general (Wickham): `Import → Tidy → Transform ↔ Visualise / Model → Communicate`. La fase **Transform / Tidy** es lo que llamamos *Wrangle*.

### Procesos típicos
1. **Limpieza de datos**: convertir tipos (texto → número), eliminar NAs, eliminar duplicados y outliers, estandarizar categorías ("CdMx" → "CDMX").
2. Unir tablas.
3. Reestructurar tablas.
4. Agregar datos por grupos.
5. Cambiar nombres de columnas.
6. Reclasificar grupos.
7. Deflactar cifras.
8. Transformar valores.
9. Reconvertir columnas.

## ¿Qué es el tidyverse?

El **tidyverse** es una colección de paquetes de R diseñados para ciencia de datos. Todos sus paquetes comparten una **filosofía de diseño, estructura de datos y gramática comunes**.

### Paquetes del tidyverse
- `ggplot2` — visualización de datos.
- `dplyr` — manipulación de datos (data wrangling).
- `readr` — lectura de datos.
- `tibble` — data frames modernos.
- `tidyr` — limpieza de datos (tidying).
- `purrr` — programación funcional.
- `stringr` — manipulación de strings.
- `forcats` — manejo de factores.

## Operador pipa (`%>%`)

### Definición
La pipa es el elemento central del tidyverse y su misión es **concatenar funciones**: vincula los objetos del lado izquierdo con las funciones del lado derecho.

> Coloquialmente, `%>%` se lee como **"y después"**.

### Cómo escribirlo
- **Mac**: `command + shift + m`.
- **Windows**: `control + shift + m`.

### Ejemplo
Sin pipa (anidado tipo "capas de cebolla", difícil de leer):
```r
x <- c(0.109, 0.359, 0.63, 0.996, 0.515, 0.142, 0.017, 0.829, 0.907)
round(exp(diff(log(x))), 1)
## [1] 3.3 1.8 1.6 0.5 0.3 0.1 48.8 1.1
```

Con pipa (lectura natural, tipo bloques de Lego):
```r
x %>% log() %>%
  diff() %>%
  exp() %>%
  round(1)
```

### Tips del operador pipa
- **Tip 1**: si un día sale un error y no sabes en qué parte del pipeline está, corre uno por uno los bloques hasta encontrarlo.
- **Tip 2**: la estructura con pipelines permite quitar (o silenciar como comentario) pedazos de código fácilmente para hacer pruebas.

## Verbos principales del tidyverse (dplyr)

| Verbo | Descripción |
|-------|-------------|
| `filter()` | Filtrar **renglones** que cumplan condiciones. |
| `select()` | Seleccionar **columnas**. |
| `mutate()` | Generar nuevas columnas (mantiene las existentes). |
| `arrange()` | Ordenar los renglones según una variable. |
| `group_by()` | Generar grupos o clusters de renglones. |
| `summarise()` | Generar cálculos con las agrupaciones de `group_by()`. |
| `slice()` | Seleccionar renglones por posición. |

### filter()
Mantiene las filas que satisfacen condiciones lógicas:
```r
filter(df, type == "otter" & site == "bay")
```

### select()
Selecciona columnas:
```r
select(data.frame, a, c)
```

### mutate()
Agrega columnas, conserva las existentes.

### arrange()
Ordena las filas en función de una variable.

### group_by() + summarise()
**Intuición — group_by() como dividir una baraja de cartas:** `group_by()` separa las cartas por palo (corazones, diamantes, etc.); `summarise()` cuenta cuántas hay en cada montón, calcula el promedio, etc. Sin `group_by()`, `summarise()` opera sobre toda la baraja junta.

### Funciones útiles dentro de un summarise

| Función | Qué calcula | Ejemplo |
|---------|-------------|---------|
| `n()` | Número de filas | `n()` |
| `mean()` | Promedio | `mean(ingreso, na.rm = TRUE)` |
| `median()` | Mediana | `median(escolaridad)` |
| `sd()` | Desviación estándar | `sd(pobreza)` |
| `sum()` | Suma total | `sum(poblacion)` |
| `min()`, `max()` | Mínimo y máximo | `min(pobreza)`, `max(pobreza)` |
| `first()`, `last()` | Primer y último valor | `first(nombre)` |
| `n_distinct()` | Valores únicos | `n_distinct(estado)` |

### Ejemplo combinado
```r
datos <- prep %>%
  select(ECS, AJM, LMGBH, TOTAL_VOTOS, LISTA_NOMINAL, MUNICIPIO, DISTRITO) %>%
  filter(!is.na(MUNICIPIO)) %>%
  group_by(MUNICIPIO) %>%
  summarise(ECS = sum(ECS, na.rm = TRUE),
            AJM = sum(AJM, na.rm = TRUE),
            LMGBH = sum(LMGBH, na.rm = TRUE),
            Total_Votos = sum(TOTAL_VOTOS, na.rm = TRUE),
            ListaNominal = sum(LISTA_NOMINAL, na.rm = TRUE))
```

## Joins (uniendo tablas)

En el mundo real, la información está dispersa en múltiples tablas. Los **joins (uniones)** permiten combinar dos data frames usando una columna común como **llave (key)**:

| Join | Comportamiento |
|------|----------------|
| `inner_join(x, y)` | Solo conserva filas con coincidencia en ambas tablas. |
| `left_join(x, y)` | Conserva todas las filas de `x`; rellena con NA donde `y` no tiene coincidencia. |
| `right_join(x, y)` | Conserva todas las filas de `y`. |
| `full_join(x, y)` | Conserva todas las filas de ambas; rellena con NA. |

### Sintaxis típica
```r
left_join(casos, fall, by = "Municipios")
inner_join(fall, hosp, by = "Municipios")
full_join(casos, pop, by = "Municipios")
```

### Relaciones entre tablas
- **Relación 1 a 1**: un valor de una tabla hace match con un valor de otra.
- **Relación 1 a muchos**: un valor de una tabla se corresponde con muchos valores de la otra.
- **Relación muchos a muchos**: situación rara, no es muy deseable en general.

## Reestructurar datos (tidyr)

Las dos operaciones más comunes son **pivotar** entre formato largo y formato ancho:

### pivot_longer()
Pasa de **wide → long**.
```r
data %>%
  pivot_longer(
    cols = 1999:2002,
    names_to = "year",
    values_to = "cases"
  )
```

### pivot_wider()
Pasa de **long → wide**.
```r
df %>% pivot_wider(
  names_from = "year",
  names_prefix = "yr",
  values_from = "metric"
)
```

## Introducción a ggplot

### ¿Por qué visualizar?
**Lección del cuarteto de Anscombe**: cuatro datasets con la **misma media de X e Y, misma varianza, misma correlación (r = 0.816), misma recta de regresión** se ven completamente diferentes al graficarlos: uno lineal, uno curvo, uno con outlier, otro con estructura distinta.

> Nunca confíes solo en las estadísticas descriptivas. **SIEMPRE** trata de graficar tus datos antes de modelar.

### ¿Por qué ggplot?
- `ggplot2` es el paquete de visualización **más usado en R** y uno de los más influyentes en la historia de la visualización de datos.
- Creado por **Hadley Wickham** basándose en la *gramática de gráficos* (Grammar of Graphics, **gg**) de Leland Wilkinson.
- **Idea central**: un gráfico es una composición de capas con una gramática definida, no una colección de tipos de gráfico predefinidos.

### Ventajas frente a base R y Excel
- **Consistencia**: todos los gráficos se construyen con la misma sintaxis.
- **Composición por capas**: agregar elementos progresivamente (datos + geometría + color + facetas + tema).
- **Calidad profesional**: gráficos publicables directamente.
- **Integración con dplyr**: encadenable con la pipa: `datos %>% filter(...) %>% ggplot(...)`.

### Componentes mínimos de un ggplot
1. **Datos (data)**: el data frame con la información a graficar.
2. **Estéticas (aes)**: el mapeo entre variables y propiedades visuales (qué va en X, qué en Y, qué determina el color).
3. **Geometría (geom)**: la forma visual que representa los datos (puntos, líneas, barras, etc.).

> Analogía gramatical: el SUJETO son los datos, el VERBO es la geometría, los COMPLEMENTOS son las estéticas.

### Capas de un ggplot (se suman con `+`)
1. Data
2. Mapping
3. Layers (geoms)
4. Scales
5. Facets
6. Coordinates
7. Theme

> ⚠️ En ggplot **NO se usa `%>%`** entre capas: se usa el símbolo `+`.

### Geometrías comunes

| Categoría | Geom | Uso |
|-----------|------|-----|
| Una variable | `geom_histogram`, `geom_density`, `geom_bar`, `geom_freqpoly`, `geom_dotplot`, `geom_area` | Distribuciones |
| Dos variables | `geom_point` (jitter, point), `geom_smooth`, `geom_text`, `geom_boxplot`, `geom_violin`, `geom_hex`, `geom_density2d` | Relaciones |
| Error | `geom_crossbar`, `geom_errorbar`, `geom_linerange`, `geom_pointrange` | Intervalos |
| Tres variables | `geom_contour`, `geom_raster`, `geom_tile` | Superficies |
| Mapas | `geom_map` | Mapas |

### Ejemplo de construcción por etapas

**Datos:**
```r
library(tidyverse)
datos <- tribble(
  ~profesion,             ~pct, ~pct_low, ~pct_upp,
  "Periodistas",           42.3, 38.1, 46.5,
  "Economistas",           67.8, 63.2, 72.4,
  "Diseñadores",           58.1, 53.5, 62.7,
  "Abogados",              23.6, 19.8, 27.4,
  "Ingenieros de software", 81.2, 77.4, 85.0,
  "Contadores",            35.9, 31.7, 40.1,
  "Médicos",               29.4, 25.3, 33.5,
  "Profesores",            44.7, 40.2, 49.2
) %>%
  mutate(es_max = pct == max(pct))
```

**Etapa 1: Esqueleto.**
```r
p1 <- ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col() +
  coord_flip()
p1
```

**Etapa 2: Color y barras de error.**
```r
p2 <- ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col(fill = "#6950d8", width = 0.7) +
  geom_errorbar(aes(ymin = pct_low, ymax = pct_upp), width = 0.2, linewidth = 0.4) +
  coord_flip()
```

**Etapa 3: Etiquetas de texto.**
```r
p3 <- ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col(fill = "#6950d8", width = 0.7) +
  geom_errorbar(aes(ymin = pct_low, ymax = pct_upp), width = 0.2, linewidth = 0.4) +
  geom_text(aes(y = pct_upp, label = paste0(pct, "%")), hjust = -0.15, size = 3.5) +
  coord_flip()
```

**Etapa 4: Títulos y espacio.**
```r
p4 <- p3 +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(
    title = "Adopción de herramientas de IA por profesión",
    subtitle = "Porcentaje de profesionistas que usan IA en su trabajo diario, 2025",
    x = NULL,
    y = "Porcentaje (%)",
    caption = "Datos ficticios | Barras de error: IC al 95%"
  )
```

**Etapa 7: Highlight de la barra más alta + tema profesional.**
```r
p7 <- ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col(aes(fill = es_max), width = 0.7, alpha = 0.9, show.legend = FALSE) +
  geom_errorbar(aes(ymin = pct_low, ymax = pct_upp), width = 0.2, linewidth = 0.4, color = "gray30") +
  geom_text(aes(y = pct_upp, label = paste0(pct, "%")), hjust = -0.15, size = 3.5,
            family = "Ubuntu", color = "gray20") +
  coord_flip(clip = "off") +
  scale_fill_manual(values = c("FALSE" = "#6950d8", "TRUE" = "#00b783")) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(title = "Adopción de herramientas de IA por profesión",
       subtitle = "Porcentaje de profesionistas que usan IA en su trabajo diario, 2025",
       x = NULL, y = NULL,
       caption = "Datos ficticios | Barras de error: IC al 95%") +
  theme_minimal(base_family = "Ubuntu") +
  theme(
    plot.title    = element_text(face = "bold", size = 16, color = "gray10"),
    plot.subtitle = element_text(size = 11, color = "gray40", margin = margin(b = 15)),
    plot.caption  = element_text(size = 8, color = "gray50", margin = margin(t = 15)),
    axis.text.y   = element_text(size = 11, color = "gray20"),
    axis.text.x   = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "gray90", linewidth = 0.3),
    panel.grid.minor   = element_blank(),
    plot.margin = margin(20, 20, 20, 20)
  )
```

### Partes del tema (theme) de un ggplot
- **Plot elements**: `plot.title`, `plot.subtitle`, `plot.background`, `plot.margin`, `plot.caption`.
- **Panel elements**: `panel.background`, `panel.border`, `panel.grid` (`panel.grid.major.x`, `panel.grid.major.y`, `panel.grid.minor`).
- **Axis elements**: `axis.title` (`.x`, `.y`), `axis.text` (`.x`, `.y`), `axis.ticks`, `axis.line`.
- **Legend elements**: `legend.title`, `legend.text`, `legend.background`, `legend.position` (`"left"`, `"right"`, `"bottom"`, `"top"`, `"none"`, o `c(.85, .85)`), `legend.key`, `legend.margin`.
- **Facetting elements**: `strip.background`, `strip.text`, `panel.spacing`.
- Las funciones para asignar elementos: `element_text()`, `element_line()`, `element_rect()`, `element_blank()` (para remover).

## Ejercicios prácticos

### Ejercicio I — Procesamiento de datos
Cargar `df_pob_ent2.xlsx` y responder con verbos del tidyverse:
- ¿Cuántas columnas y filas tiene? ¿Qué representa cada fila?
- ¿Cuál es el estado con mayor porcentaje de población en pobreza (`pobreza`) en 2024?
- ¿Cuál es el estado con menor porcentaje de carencia por acceso a la salud (`ic_asalud`) en 2024?
- ¿Cuáles son los 10 estados con mayor porcentaje de pobreza extrema en 2024 (`pobreza_e`)?
- ¿Cuál es el promedio simple del porcentaje de pobreza moderada de los estados del centro del país (CDMX, Puebla, EDOMEX, Morelos e Hidalgo) en 2024?
- ¿En qué año alcanzó Chiapas su porcentaje más alto de población con carencia por acceso a la seguridad social?
- ¿Cuál es el valor más bajo de pobreza que ha alcanzado algún estado?
- Promedio y desviación estándar del porcentaje de pobreza para todos los estados, para cada año.

### Ejercicio II — Joins
Tabla de población, tabla de pobreza municipal y tabla de grado promedio de educación.
> Imagine que la Secretaría del Bienestar le pide priorizar municipios para un nuevo programa de transferencias. Seleccione municipios con **pobreza > 30%, escolaridad promedio < 9 años**, priorizando los más poblados. Detecte los **10 municipios prioritarios para 2020**.

### Ejercicio III — Reestructuración
- Cargue datos de INEGI (PIB trimestral) **sin modificar** la fuente primaria.
- Pase la tabla a formato largo.
- ¿Cuál es el sector que más ha crecido desde el **2009T4**?

### Ejercicio de ggplot — replicación
Descargar el material de la sesión 05. En la carpeta "Ejercicio 01" viene el script `ejercicio_01.R` con código pre-programado para realizar gráficas. Replicar las gráficas mostradas:
1. Total de accidentes por día de la semana (barras, datos ATUS-INEGI 2023).
2. Total de heridos por tipo (Ciclista, Conductor, Pasajero, Peatón) y mes del año (líneas).
3. Ubicación de accidentes registrados en el ATUS en las alcaldías de la CDMX (mapa con densidad).
