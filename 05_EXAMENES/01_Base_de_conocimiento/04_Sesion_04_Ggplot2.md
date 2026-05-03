# Sesión 04 — ggplot2

## Programa de la clase
Profundización en ggplot2: capas, geometrías, escalas, facetas, temas y construcción de gráficos profesionales. La sesión retoma y extiende lo cubierto al final de Clase 03.

## ¿Por qué visualizar?

**Cuarteto de Anscombe**: cuatro datasets con la **misma media de X e Y, misma varianza, misma correlación (r ≈ 0.816) y misma recta de regresión**, pero al graficarlos se ven completamente diferentes (lineal, curvo, con outlier, estructura distinta).

> **Lección**: Nunca confíes solo en estadísticas descriptivas. **Trata de graficar tus datos antes de modelar.** Un gráfico de dispersión simple puede revelar patrones (no linealidad, outliers, agrupamientos) que la media y la correlación ocultan completamente.

## ¿Por qué ggplot?

- `ggplot2` es el paquete de visualización **más usado en R**.
- Creado por **Hadley Wickham** basándose en la *Grammar of Graphics* (gg) de **Leland Wilkinson**.
- **Idea central**: un gráfico es una **composición de capas con una gramática definida**, no una colección de tipos predefinidos.

### Ventajas frente a base R / Excel
- **Consistencia**: misma sintaxis para todos los gráficos.
- **Composición por capas**: agregar elementos progresivamente.
- **Calidad profesional**: gráficos publicables.
- **Integración con dplyr**: `datos %>% filter(...) %>% ggplot(...)`.

## Componentes mínimos

1. **Datos (data)**: data frame o tibble con la información a graficar en el formato adecuado.
2. **Geometría (geom)**: cómo representar los datos gráficamente (puntos, líneas, barras, histogramas).
3. **Estética (aes)**: mapeos visuales — X, Y, color, tamaño, forma. (Cómo representar las variables de la tabla en la gráfica).
4. **Opcionales**: facetas, temas, etiquetas, escalas personalizadas.

> Analogía gramatical: SUJETO = datos, VERBO = geometría, COMPLEMENTOS = estéticas.

## Capas (se suman con `+`, **NO con `%>%`**)

Orden conceptual:
1. **Data** (datos)
2. **Mapping** (estéticas)
3. **Layers** (geoms)
4. **Scales** (escalas)
5. **Facets** (facetas)
6. **Coordinates** (coordenadas)
7. **Theme** (tema)

Ejemplo:
```r
ggplot(labdata) +
  aes(Date, Result) +
  geom_line() +
  facet_wrap(~Suburb) +
  geom_smooth() +
  scale_y_log10() +
  theme_bw()
```

## Reestructuración de datos (insumo para ggplot)
Reaparecen `pivot_longer()` y `pivot_wider()` (paquete `tidyr`) porque ggplot trabaja mejor con datos en formato largo.

```r
data %>% pivot_longer(cols = 1999:2002, names_to = "year", values_to = "cases")

df %>% pivot_wider(names_from = "year",
                   names_prefix = "yr",
                   values_from = "metric")
```

## Geometrías comunes (cheatsheet)

### Una variable
- Continua: `geom_area`, `geom_density`, `geom_dotplot`, `geom_freqpoly`, `geom_histogram`.
- Discreta: `geom_bar`.

### Dos variables (ambas continuas)
`geom_label`, `geom_point`, `geom_quantile`, `geom_rug`, `geom_smooth(method = "lm")`, `geom_text`, `geom_jitter`.

### Una discreta + una continua
`geom_col`, `geom_boxplot`, `geom_violin`, `geom_dotplot`, `geom_linerange`, `geom_pointrange`, `geom_crossbar`, `geom_errorbar`.

### Ambas discretas
`geom_count`, `geom_jitter`.

### Distribución bivariada continua
`geom_bin2d`, `geom_density_2d`, `geom_hex`.

### Función continua
`geom_area`, `geom_line`, `geom_step`.

### Tres variables
`geom_contour`, `geom_contour_filled`, `geom_raster`, `geom_tile`.

### Mapas
`geom_sf` (de paquete `sf`), `geom_map`.

### Primitivas
`geom_blank`, `geom_curve`, `geom_path`, `geom_polygon`, `geom_rect`, `geom_ribbon`, `geom_abline`, `geom_hline`, `geom_vline`, `geom_segment`.

## Estéticas comunes (aes)
- `color` y `fill`: texto ("red", "#FFGGBB").
- `linetype`: 0 = "blank", 1 = "solid", 2 = "dashed", 3 = "dotted", 4 = "dotdash", 5 = "longdash", 6 = "twodash".
- `size`: número en mm (puntos y texto).
- `linewidth`: número en mm (líneas).
- `shape`: número (1-25) o un carácter ("a").

## Construcción por etapas (ejemplo del curso)

### Datos
```r
library(tidyverse)
datos <- tribble(
  ~profesion,             ~pct, ~pct_low, ~pct_upp,
  "Periodistas",            42.3, 38.1, 46.5,
  "Economistas",            67.8, 63.2, 72.4,
  "Diseñadores",            58.1, 53.5, 62.7,
  "Abogados",               23.6, 19.8, 27.4,
  "Ingenieros de software", 81.2, 77.4, 85.0,
  "Contadores",             35.9, 31.7, 40.1,
  "Médicos",                29.4, 25.3, 33.5,
  "Profesores",             44.7, 40.2, 49.2
) %>%
  mutate(es_max = pct == max(pct))
```

### Etapa 1 — Esqueleto
```r
ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col() +
  coord_flip()
```

### Etapa 2 — Color y barras de error
```r
ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col(fill = "#6950d8", width = 0.7) +
  geom_errorbar(aes(ymin = pct_low, ymax = pct_upp),
                width = 0.2, linewidth = 0.4) +
  coord_flip()
```

### Etapa 3 — Etiquetas de texto
```r
geom_text(aes(y = pct_upp, label = paste0(pct, "%")),
          hjust = -0.15, size = 3.5)
```

### Etapa 4 — Títulos, ejes, espacio
```r
+ scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(title    = "Adopción de herramientas de IA por profesión",
       subtitle = "Porcentaje de profesionistas que usan IA en su trabajo diario, 2025",
       x = NULL, y = "Porcentaje (%)",
       caption  = "Datos ficticios | Barras de error: IC al 95%")
```

### Etapa 7 — Highlight + tema profesional
```r
scale_fill_manual(values = c("FALSE" = "#6950d8", "TRUE" = "#00b783")) +
theme_minimal(base_family = "Ubuntu") +
theme(
  plot.title    = element_text(face = "bold", size = 16, color = "gray10"),
  plot.subtitle = element_text(size = 11, color = "gray40"),
  plot.caption  = element_text(size = 8, color = "gray50"),
  axis.text.y   = element_text(size = 11, color = "gray20"),
  axis.text.x   = element_blank(),
  panel.grid.major.y = element_blank(),
  panel.grid.major.x = element_line(color = "gray90", linewidth = 0.3),
  panel.grid.minor   = element_blank()
)
```

## Partes del tema (theme elements)
- **Plot**: `plot.title`, `plot.subtitle`, `plot.background`, `plot.margin`, `plot.caption`, `plot.title.position`.
- **Panel**: `panel.background`, `panel.border`, `panel.grid.major(.x/.y)`, `panel.grid.minor`, `panel.spacing`.
- **Axis**: `axis.title(.x/.y)`, `axis.text(.x/.y)`, `axis.ticks`, `axis.line(.x/.y)`.
- **Legend**: `legend.title`, `legend.text`, `legend.background`, `legend.key`, `legend.position` (`"left"`, `"right"`, `"bottom"`, `"top"`, `"none"`, o `c(.85, .85)`), `legend.margin`.
- **Facetting**: `strip.background`, `strip.text`.
- **Funciones para asignar**: `element_text()`, `element_line()`, `element_rect()`, `element_blank()` (remueve un elemento).

## Guardar gráficos
```r
ggsave("plot.png", width = 5, height = 5)
```
- Guarda el último gráfico generado (o el especificado).
- Acepta diferentes extensiones (`.png`, `.pdf`, `.svg`, etc.).
- Devolver el último gráfico: `last_plot()`.

## Ejercicios prácticos

- **Ejercicio 01** (referenciado en Clase 03): replicar gráficos a partir del script `ejercicio_01.R` con datos de **ATUS-INEGI 2023** (Accidentes de Tránsito Terrestre en Zonas Urbanas y Suburbanas):
  - Total de accidentes por día de la semana (barras).
  - Total de heridos por tipo (Ciclista, Conductor, Pasajero, Peatón) y mes del año (líneas).
  - Densidad de accidentes en alcaldías de la CDMX (mapa de densidad).

## Recursos
- Cheatsheet oficial en español: `https://rstudio.github.io/cheatsheets/translations/spanish/data-visualization_es.pdf`
