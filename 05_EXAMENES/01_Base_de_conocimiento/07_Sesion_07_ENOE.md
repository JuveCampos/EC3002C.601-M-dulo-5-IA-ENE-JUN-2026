# Sesión 07 — ENOE (Encuesta Nacional de Ocupación y Empleo)

## Programa de la clase
La ENOE como instrumento de medición del mercado laboral mexicano: diseño muestral con panel rotativo, indicadores estratégicos (desocupación, informalidad), y manipulación con `srvyr` para cálculo de totales, medias, razones, cuantiles e intervalos de confianza.

## ¿Qué es la ENOE?

La **Encuesta Nacional de Ocupación y Empleo (ENOE)** es el principal instrumento estadístico que realiza el INEGI de forma **continua (trimestral)** en México, con el objetivo de recopilar información detallada sobre las **condiciones del mercado laboral**: empleo, desempleo, informalidad y características de la fuerza de trabajo.

- **Unidad de análisis**: personas de **15 años y más** que residen en viviendas particulares.
- **Inicio**: primer trimestre de **2005**, reemplazando a la ENE.
- **Tamaño**: ~120,000 viviendas / ~400,000 personas por trimestre.

## Significado del acrónimo ENOE

| Letra | Significado | Detalle |
|---|---|---|
| **E** | Encuesta | Recopila información de una muestra representativa (~120,000 viviendas/trimestre) |
| **N** | Nacional | Cobertura nacional; desagregaciones por entidad federativa, tamaño de localidad, urbano/rural y **39 ciudades autorrepresentadas** |
| **O** | Ocupación | Captura las **actividades económicas**: tipo de trabajo, sector, posición, horas, ingresos |
| **E** | Empleo | Clasifica a la población según condición de actividad (PEA, PNEA, ocupados, desocupados) siguiendo recomendaciones de la **OIT** |

### Ventajas de la encuesta continua
1. **Frecuencia** trimestral (no cada 10 años como un censo).
2. **Profundidad temática** focalizada en mercado laboral.
3. **Oportunidad**: resultados pocas semanas después del cierre del trimestre.
4. **Seguimiento**: panel rotativo permite observar cambios en el tiempo.

## Clasificación de la población (categorías OIT)

| **Población Económicamente Activa (PEA)** | **Población No Económicamente Activa (PNEA)** |
|---|---|
| **Ocupados**: tienen empleo (formal o informal) | **Disponibles**: no buscan pero aceptarían trabajar |
| **Desocupados**: no tienen empleo pero **lo buscan activamente** | **No disponibles**: estudiantes, jubilados, personas del hogar |

### Indicadores derivados
- **Tasa de desocupación (TD)**: % de la PEA sin empleo que busca trabajo activamente.
- **Tasa de informalidad laboral (TIL)**: % de ocupados en condiciones de informalidad.
- **Tasa de subocupación**: % de ocupados que buscan trabajar más horas.
- **Tasa de participación**: % de la población de 15+ económicamente activa.
- **Tasa de condiciones críticas de ocupación (TCCO)**: precariedad (jornadas excesivas, ingresos bajos).
- **Tasa de presión general (TPRG)**.

## ENOE vs ENIGH

| Aspecto | **ENOE** | **ENIGH** |
|---|---|---|
| Objetivo | Mercado laboral | Ingresos y gastos del hogar |
| Frecuencia | Trimestral (continua) | Bienal (cada 2 años) |
| Unidad de análisis | Personas 15+ años | Hogares |
| Muestra | ~120,000 viv./trimestre | ~90,000 viv./levantamiento |
| Diseño temporal | **Panel rotativo** (5 visitas) | Corte transversal (1 visita) |
| Ingresos | Solo laborales (cuestionario corto) | Todos los ingresos + gastos detallados |
| Usuarios clave | STPS, Banxico, OIT | CONEVAL, política social |

> En resumen: la ENOE mide **quién trabaja, en qué y cómo**; la ENIGH mide **cuánto ganan y en qué gastan** los hogares.

## Esquema de panel rotativo

La ENOE utiliza un **panel rotativo** donde cada vivienda seleccionada es visitada durante **5 trimestres consecutivos**. Cada trimestre, se rota el **20%** de la muestra (sale el grupo más antiguo, entra uno nuevo).

### Ventajas del panel rotativo
1. Permite medir **transiciones laborales** (desocupado → ocupado, ocupado → desocupado, informal → formal).
2. Reduce la varianza de las estimaciones.
3. Distribuye la carga de trabajo de campo.

> INEGI publica **bases de datos de flujos laborales** derivadas de este esquema panel.

## Diseño muestral

- **Probabilístico**: cada vivienda tiene probabilidad conocida ≠ 0.
- **Bietápico**: primero se seleccionan UPM (áreas geográficas), luego viviendas dentro.
- **Estratificado**: por entidad, urbano/rural.
- **Por conglomerados**: AGEBs/manzanas como clusters.

## Variables clave del diseño muestral en ENOE

| Variable | Rol | Descripción |
|---|---|---|
| `fac_tri` | Peso muestral (weights) | Factor de expansión trimestral |
| `fac_men` | Peso muestral mensual | Factor para estimaciones mensuales |
| `upm` | Conglomerado | Unidad Primaria de Muestreo |
| `est_d_tri` | Estrato | Estrato de diseño muestral trimestral |

> El nombre exacto puede variar entre ediciones; verificar siempre con el descriptor.

## COVID-19: ETOE y ENOEN

| Periodo | Qué pasó |
|---|---|
| **Marzo 2020** | Suspensión del levantamiento presencial por la contingencia |
| **Abril–Junio 2020** | **ETOE** (Encuesta Telefónica de Ocupación y Empleo) — datos no estrictamente comparables con ENOE |
| **Julio 2020** | Inicia **ENOEN** (ENOE Nueva Edición) en modo mixto presencial + telefónico |
| **2022 →** | Regreso paulatino al levantamiento predominantemente presencial |

> Al comparar series de tiempo, **cuidado con abril–junio 2020**.

## Tablas principales de la ENOE

| Tabla | Contenido |
|---|---|
| **SDEM** (`SDEMTxxx.csv`) | Variables sociodemográficas (sexo, edad, escolaridad, estado civil) + diseño muestral |
| **COE1** | Condición de actividad, búsqueda de empleo, disponibilidad |
| **COE2** | Características del empleo: ocupación, sector, horas, ingresos |
| **HOGAR** (`HOGARTRIMxxx.csv`) | Características del hogar |
| **VIVIENDA** (`VIVTRIMxxx.csv`) | Datos de identificación y control de la vivienda |

## Clasificadores utilizados

- **SINCO**: Sistema Nacional de Clasificación de Ocupaciones — clasifica el tipo de trabajo.
- **SCIAN**: Sistema de Clasificación Industrial de América del Norte — clasifica las actividades económicas / sectores.
- **Catálogos geográficos**: entidades, municipios, localidades.

## Variables clave para el análisis

| Variable | Descripción |
|---|---|
| `clase1` == 1 | Población económicamente activa (PEA) |
| `clase2` == 1 | Población ocupada |
| `clase2` == 2 | Población desocupada |
| `emp_ppal` == 1 | Empleo principal informal |
| `emp_ppal` == 2 | Empleo principal formal |
| `sex` | Sexo (1 = Hombre, 2 = Mujer) |
| `cve_ent` | Clave de entidad federativa |
| `cs_p13_1` | Nivel educativo (0 = Ninguna, 7 = Profesional, 8 = Maestría, 9 = Doctorado, 99 = No sabe) |
| `ingocup` | Ingreso de la ocupación principal |
| `ing_x_hrs` | Ingreso por hora trabajada |

## Análisis con `srvyr`

### Setup
```r
library(tidyverse)
library(srvyr)
library(janitor)

sdemt <- read_csv("enoe_2025_trim4_csv/ENOE_SDEMT425.csv") %>%
  janitor::clean_names()

sdemt_dis <- sdemt %>%
  as_survey_design(ids = upm,
                   # strata = est_d_tri,
                   weights = fac_tri,
                   nest = TRUE)
```

### Total de personas ocupadas por sexo
```r
sdemt_dis %>%
  filter(clase2 == 1) %>%
  group_by(sex) %>%
  summarise(total_po = survey_total(vartype = "ci"))
```

### Desocupados por entidad federativa
```r
sdemt_dis %>%
  filter(clase2 == 2) %>%
  group_by(cve_ent) %>%
  summarise(total_pdesoc = survey_total(vartype = "ci"))
```

### Tasa de informalidad por entidad
```r
sdemt_dis %>%
  filter(clase1 == 1) %>%
  mutate(dummy_informalidad = ifelse(emp_ppal == 1, 1, 0)) %>%
  group_by(cve_ent) %>%
  summarise(tasa_informalidad = 100 * survey_mean(dummy_informalidad,
                                                   vartype = "ci")) %>%
  arrange(-tasa_informalidad)
```

### Razón informal/formal con `survey_ratio()`
```r
sdemt_dis %>%
  filter(clase2 == 1) %>%
  mutate(form   = ifelse(emp_ppal == 2, 1, 0),
         inform = ifelse(emp_ppal == 1, 1, 0)) %>%
  group_by(cve_ent) %>%
  summarise(razon = survey_ratio(numerator = inform,
                                  denominator = form,
                                  vartype = "ci"))
```

### Cuantiles del ingreso
```r
sdemt_dis %>%
  filter(clase2 == 1, ingocup > 0) %>%
  summarise(ing_q = survey_quantile(ingocup,
                                     quantiles = c(0.25, 0.5, 0.75),
                                     vartype = "ci"))
```

### Mediana de ingreso por sexo y nivel educativo (con `case_when`)
```r
bd_mediana_sexo_ge <- sdemt_dis %>%
  filter(clase2 == 1, ingocup > 0) %>%
  group_by(sex, cs_p13_1) %>%
  summarise(mediana = survey_quantile(ingocup, quantiles = 0.5,
                                       vartype = "ci")) %>%
  mutate(cs_p13_1_rec = case_when(
    cs_p13_1 == "0" ~ "Ninguna",
    cs_p13_1 == "3" ~ "Secundaria",
    cs_p13_1 == "4" ~ "Preparatoria o bachillerato",
    cs_p13_1 == "7" ~ "Profesional",
    cs_p13_1 == "8" ~ "Maestría",
    cs_p13_1 == "9" ~ "Doctorado",
    TRUE ~ NA_character_))
```

## Funciones clave de `srvyr` (resumen)

| Función | Uso |
|---|---|
| `as_survey_design(ids, strata, weights, nest)` | Declarar diseño |
| `survey_total(var, vartype)` | Total ponderado |
| `survey_mean(var, vartype)` | Media ponderada (también para tasas con dummies) |
| `survey_ratio(num, den, vartype)` | Razón entre dos variables ponderadas |
| `survey_quantile(var, quantiles, vartype)` | Cuantiles ponderados |

## Documentos importantes

- **Página general**: `https://www.inegi.org.mx/programas/enoe/15ymas/`
- **Microdatos**: sección de microdatos en la página del programa.
- **Tabulados interactivos**: `https://www.inegi.org.mx/app/tabulados/interactivos/`
- **Documentación conceptual**: cuestionarios, guías de llenado, diseño muestral.
- **Glosario de la ENOE**: definiciones oficiales de los conceptos.

## Ejercicios prácticos

Script `codigo_sesion_7_visto_en_clase.R`:
1. **Cargar** `ENOE_SDEMT425.csv` (4° trimestre 2025) con `read_csv()` + `janitor::clean_names()`.
2. **Declarar diseño** con `fac_tri` como weights y `upm` como cluster.
3. **Total de ocupados por sexo** (`clase2 == 1`).
4. **Desocupados por entidad** y graficar barras horizontales con `geom_errorbar()` para los IC.
5. **Tasa de informalidad por entidad** (con dummy + `survey_mean`).
6. **Ingreso promedio por nivel educativo** (`cs_p13_1`) con recodificación con `case_when()` y barras ordenadas.
7. **Ingreso por hora** por sexo (`ing_x_hrs`).
8. **Razón informal/formal** con `survey_ratio()`.
9. **Percentiles 25/50/75** del ingreso ocupacional con `survey_quantile()`.
10. **Mediana del ingreso por sexo y nivel educativo**, graficada con `facet_wrap(~cs_p13_1_rec)`.

Otros ejercicios:
- `conteos_gente_doctorado.R` — conteos a nivel doctorado.
- Ejercicio 2: análisis a nivel **ciudad autorrepresentada** del cuarto trimestre 2025 (carpeta `enoe_2025_trim4_csv/`).
