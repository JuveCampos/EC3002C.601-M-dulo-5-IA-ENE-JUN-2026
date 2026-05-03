# Sesión 06 — ENIGH (Encuesta Nacional de Ingresos y Gastos de los Hogares)

## Programa de la clase
Encuestas en hogares como instrumento estadístico, diseño muestral, factores de expansión, error estándar y manipulación de la ENIGH en R con `srvyr`.

## ¿Qué es la ENIGH?

La **Encuesta Nacional de Ingresos y Gastos de los Hogares (ENIGH)** es un levantamiento estadístico que realiza el **INEGI cada dos años** en México. Recopila información detallada sobre la **composición, distribución y destino de los ingresos y gastos de los hogares**.

- **Unidad de análisis**: el **hogar** (conjunto de personas que comparten una misma vivienda y destinan parte o totalidad de sus recursos a cubrir necesidades básicas).

### Significado del acrónimo ENIGH
| Letra | Significado | Detalle |
|---|---|---|
| **E** | Encuesta | Ejercicio estadístico que recopila información de una **muestra** representativa, no de toda la población. |
| **N** | Nacional | Cobertura de **todo el territorio mexicano**; permite estimaciones a nivel país y desagregaciones por entidad federativa, tamaño de localidad, ámbitos rural/urbano y ciudad autorrepresentada. |
| **I** | Ingresos | Levantamiento sistemático de las **fuentes de ingreso** del hogar: sueldos, salarios, trabajo independiente, transferencias (programas sociales, remesas), rentas, pensiones. |
| **G** | Gastos | Detalle de las **erogaciones del hogar**: alimentación, vivienda, transporte, salud, educación, recreación, servicios. Insumo de la canasta CONEVAL para medir pobreza. |
| **H** | Hogares | Unidad de análisis: el hogar (no la persona individual). |

## Encuesta vs Censo

Una **encuesta** recopila información de una **muestra** (subconjunto de la población) diseñada para ser **representativa** del universo.

### Ventajas de la encuesta sobre el censo
1. **Costo y recursos**: mucho menos cara.
2. **Profundidad temática**: cuestionarios más detallados.
3. **Frecuencia**: levantamientos más seguidos.
4. **Calidad del dato**: mayor inversión en capacitación, supervisión y validación.
5. **Oportunidad**: resultados se procesan y publican más rápido.

## Hogar vs Vivienda

| Concepto | Definición |
|---|---|
| **Vivienda** | Espacio físico delimitado por paredes y techos, destinado a funciones humanas (dormir, comer, protegerse). Se refiere al **inmueble**. |
| **Hogar (censal)** | Unidad formada por una o más personas, **vinculadas o no por parentesco**, que residen habitualmente en la misma vivienda particular. Se refiere a las **personas**, no al espacio. |

> **Una vivienda puede contener más de un hogar**: si en una misma casa viven dos familias que no comparten gastos de alimentación, INEGI las cuenta como dos hogares dentro de una sola vivienda.

## Diseño muestral

El **diseño muestral** es el conjunto de reglas y procedimientos que definen **cómo se seleccionan los hogares** que serán entrevistados.

### Características del diseño muestral de la ENIGH
- **Probabilístico**: cada hogar tiene una probabilidad **conocida y distinta de cero** de ser seleccionado.
- **Estratificado**: el país se divide en **estratos** (entidad federativa, urbano vs. rural) para asegurar representación de cada uno.
- **Conglomerado** (cluster): primero se seleccionan **áreas geográficas** (manzanas, AGEBs), y dentro de ellas se eligen los hogares.

## Factores de expansión

Cuando INEGI selecciona un hogar para la ENIGH, ese hogar **representa a muchos otros hogares similares**. El **factor de expansión** indica a cuántos hogares de la población equivale cada hogar encuestado.

- Ejemplo: muestra de 100,000 hogares; en México hay ~35 millones. Cada hogar de la muestra representa a cientos de hogares reales.
- Si un hogar tiene factor de expansión = **350**, sus respuestas representan lo que hacen 350 hogares similares en la población.

## Variables clave del diseño muestral

Para declarar el diseño de encuesta en R necesitas tres variables presentes en todas las tablas:

| Variable | Rol | Descripción |
|---|---|---|
| `factor` | **Peso muestral (weights)** | Cuántas unidades de la población representa cada observación |
| `upm` | **Conglomerado** | Unidad Primaria de Muestreo (cluster) |
| `est_dis` | **Estrato** | Estrato de diseño muestral |

> El nombre exacto del factor varía por tabla: `factor`, `factor_hog`, `factor_per`. Verifica con el descriptor de la base.

## Error estándar

Imagina que INEGI levantara la ENIGH **miles de veces**, cada vez con una muestra distinta. Cada muestra daría una estimación ligeramente diferente del ingreso promedio. Esa **distribución de estimaciones** tiene una desviación estándar: el **error estándar**.

> El error estándar mide **qué tanto variarían tus estimaciones de muestra en muestra**.

- **Error estándar pequeño** → estimación estable y confiable; cualquier muestra te habría dado un resultado parecido.
- **Error estándar grande** → tu muestra pudo haber tenido "suerte" o "mala suerte"; otra muestra podría dar un número bastante diferente.

### Diferencia con la desviación estándar
- **Desviación estándar**: dispersión de los **datos individuales** (variación entre hogares).
- **Error estándar**: dispersión de las **estimaciones** si repitieras el muestreo muchas veces.

## Tablas de la ENIGH

| Tabla | Contenido |
|---|---|
| `concentradohogar` | Ingreso, gasto y características agregadas por hogar (tabla resumen) |
| `hogares` | Características de la vivienda y el hogar, alimentación, equipamiento |
| `poblacion` | Características sociodemográficas por persona |
| `trabajos` | Información laboral por persona |
| `viviendas` | Infraestructura de la vivienda + diseño muestral + factor de expansión |
| `ingresos` | Ingreso detallado por fuente (claves P001, P004, etc.) |
| `gastoshogar` | Gastos monetarios y no monetarios del hogar |
| `gastotarjetas` | Gastos cubiertos con tarjeta de crédito |
| `erogaciones` | Erogaciones financieras y de capital |

## Análisis con `srvyr` (tidyverse para encuestas)

### Librerías
```r
library(tidyverse)
library(srvyr)        # tidyverse para encuestas con diseño muestral
library(foreign)      # para leer archivos .dbf de INEGI
```

### Patrón básico

```r
# Cargar tabla concentrado
concentrado_hogares <- read.dbf("enigh/concentradohogar.dbf")

# Declarar diseño muestral y calcular ingreso promedio con IC
concentrado_hogares %>%
  as_tibble() %>%
  as_survey_design(ids = upm,
                   strata = est_dis,
                   weights = factor,
                   nest = TRUE) %>%
  summarise(ing_prom = survey_mean(ing_cor, na.rm = TRUE, vartype = "ci"),
            ing_trab_promedio = survey_mean(ingtrab, na.rm = TRUE, vartype = "ci"))
```

### Por estado (extrayendo CVE_ENT del campo `ubica_geo`)

```r
ing_prom_estados <- concentrado_hogares %>%
  as_tibble() %>%
  mutate(cve_ent = str_extract(ubica_geo, pattern = "^\\d\\d")) %>%
  as_survey_design(ids = upm, strata = est_dis,
                   weights = factor, nest = TRUE) %>%
  group_by(cve_ent) %>%
  summarise(ing_prom_estado = survey_mean(ing_cor,
                                          na.rm = TRUE, vartype = "ci"))
```

### Joins entre tablas (poblacion + ingresos)

Las llaves típicas en ENIGH son: `folioviv`, `foliohog`, `numren`.

```r
poblacion <- read.dbf("enigh/poblacion.dbf") %>% tibble() %>%
  select(folioviv, foliohog, numren, sexo, factor, upm, est_dis)

ingresos <- read.dbf("enigh/ingresos.dbf") %>% tibble() %>%
  filter(clave %in% c("P001","P004","P006","P007","P008","P009")) %>%
  group_by(folioviv, foliohog, numren) %>%
  summarise(ing_tri = sum(ing_tri, na.rm = TRUE))

tabla_ingreso_sexo <- left_join(poblacion, ingresos,
                                by = c("folioviv","foliohog","numren"))
```

### Análisis con grupo (ingreso por sexo)

```r
ingreso_trabajo_por_sexo <- tabla_ingreso_sexo %>%
  as_survey_design(ids = upm, strata = est_dis,
                   weights = factor, nest = TRUE) %>%
  group_by(sexo) %>%
  summarise(ing_prom_sexo = survey_mean(ing_tri, na.rm = TRUE,
                                        vartype = c("ci","se"))) %>%
  mutate(sexo_2 = ifelse(sexo == 1, "Hombre", "Mujer"))
```

## Funciones clave de `srvyr`

| Función | Uso |
|---|---|
| `as_survey_design(ids, strata, weights, nest)` | Declara el diseño de encuesta |
| `survey_mean(var, na.rm, vartype)` | Media ponderada con error/IC |
| `survey_total(var)` | Total ponderado |
| `survey_median(var)` | Mediana ponderada |
| `survey_quantile(var, quantiles)` | Cuantiles ponderados |
| `vartype = "ci"` o `"se"` | Tipo de varianza: intervalo de confianza o error estándar |

## Documentos clave de la ENIGH 2024

- **Página general**: `https://www.inegi.org.mx/programas/enigh/nc/2024/`
- **Descriptor de la base de datos** (qué significa cada variable y tabla).
- **Cálculo de los indicadores con R** (recetas oficiales).
- **Presentación de resultados**.

## Ejercicios prácticos (script `codigo_analisis_enigh.R`)

1. Cargar `concentradohogar.dbf` con `read.dbf()` (paquete `foreign`).
2. Declarar diseño muestral con `as_survey_design()` y calcular **ingreso corriente promedio** y **rentas promedio** con IC.
3. Calcular **ingreso promedio por estado** extrayendo `cve_ent` de `ubica_geo` con `str_extract("^\\d\\d")`, y ordenar de mayor a menor.
4. Calcular **gasto monetario promedio por estado**.
5. Construir tabla `tabla_ingreso_sexo` haciendo `left_join` entre `poblacion` e `ingresos` filtrando por claves específicas (P001, P004…).
6. Calcular **ingreso laboral trimestral promedio por sexo** y graficar con `geom_col()` + `geom_errorbar()` y `scale_fill_manual(c("Hombre"="green","Mujer"="#eb02b1"))`.
