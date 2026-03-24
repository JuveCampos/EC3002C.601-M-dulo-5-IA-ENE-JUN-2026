# Guión - Clase 07: ENOE (Encuesta Nacional de Ocupación y Empleo)

## Diapositiva 1: Portada
- Título: **07. ENOE**
- Subtítulo: Módulo 5. Inteligencia Artificial
- Autor: Jorge Juvenal Campos Ferreira
- Contacto: juvenal.campos@tec.mx

---

## Diapositiva 2: ¿Qué es la ENOE?
La **Encuesta Nacional de Ocupación y Empleo (ENOE)** es el principal instrumento estadístico que realiza el **INEGI** de forma continua (trimestral) en México, con el objetivo de recopilar información detallada sobre las **condiciones del mercado laboral**: empleo, desempleo, informalidad, subocupación y características de la fuerza de trabajo.

Su unidad de análisis son las **personas de 15 años y más** que residen en viviendas particulares seleccionadas en todo el territorio nacional.

---

## Diapositiva 3: Desglose de las siglas E-N-O-E
- **E** → Encuesta
- **N** → Nacional
- **O** → Ocupación
- **E** → Empleo

(Slide visual con cada letra en un cuadro de color, similar al desglose ENIGH)

---

## Diapositiva 4: E – Encuesta
Una encuesta ("E") es un ejercicio estadístico en el que se recopila información de una muestra representativa de la población.

En el caso de la ENOE, el INEGI selecciona aproximadamente **120,000 viviendas cada trimestre** distribuidas a lo largo del territorio nacional, y a partir de las respuestas de sus habitantes infiere las condiciones laborales de toda la población de 15 años y más en México.

A diferencia de un censo, la encuesta permite:
1. Mayor frecuencia (trimestral vs. cada 10 años)
2. Profundidad temática sobre el mercado laboral
3. Seguimiento continuo de indicadores clave
4. Publicación oportuna de resultados

---

## Diapositiva 5: N – Nacional
La "N" corresponde a *Nacional*. La ENOE tiene cobertura de todo el territorio mexicano y permite realizar estimaciones a nivel nacional, por entidad federativa, por tamaño de localidad, por ámbito rural/urbano y por 39 ciudades autorrepresentadas.

El carácter nacional le da legitimidad para ser la fuente oficial de las estadísticas de empleo en México, utilizadas por instituciones como Banxico, CONEVAL, la STPS y organismos internacionales como la OIT.

---

## Diapositiva 6: O – Ocupación
La "O" corresponde a *Ocupación*. Este componente captura las actividades económicas que realizan las personas: qué tipo de trabajo desempeñan, en qué sector económico, qué posición tienen (empleado, cuenta propia, empleador), cuántas horas trabajan, cuánto ganan y bajo qué condiciones.

La ENOE permite clasificar a la población ocupada por:
- Sector de actividad (primario, secundario, terciario)
- Posición en la ocupación (subordinados, cuenta propia, empleadores, sin pago)
- Tamaño de establecimiento
- Nivel de ingresos
- Formalidad/informalidad
- Jornada laboral

---

## Diapositiva 7: E – Empleo
La segunda "E" corresponde a *Empleo*. Este componente clasifica a toda la población de 15 años y más en categorías mutuamente excluyentes:

**Población Económicamente Activa (PEA):**
- Ocupados: tienen un empleo
- Desocupados: no tienen empleo pero lo buscan activamente

**Población No Económicamente Activa (PNEA):**
- Disponibles: no buscan pero aceptarían trabajar
- No disponibles: estudiantes, jubilados, personas dedicadas al hogar

Esta clasificación sigue las recomendaciones de la **Organización Internacional del Trabajo (OIT)**.

---

## Diapositiva 8: ENOE vs. ENIGH – Diferencias clave

| Aspecto | ENOE | ENIGH |
|---|---|---|
| Objetivo | Mercado laboral | Ingresos y gastos de hogares |
| Frecuencia | Trimestral (continua) | Bienal (cada 2 años) |
| Unidad de análisis | Personas de 15+ años | Hogares |
| Muestra | ~120,000 viviendas/trimestre | ~90,000 viviendas/levantamiento |
| Diseño temporal | Panel rotativo (5 visitas) | Corte transversal (1 visita) |
| Ingresos | Solo laborales (cuestionario corto) | Todos los ingresos + gastos detallados |
| Usuarios principales | STPS, Banxico, OIT | CONEVAL, política social |

---

## Diapositiva 9: El esquema de panel rotativo
La ENOE utiliza un **esquema de panel rotativo** donde cada vivienda seleccionada es visitada durante **5 trimestres consecutivos**.

- Cada trimestre, se rota aproximadamente el **20% de la muestra** (entra muestra nueva, sale muestra que ya cumplió sus 5 visitas).
- En cualquier trimestre dado, 4/5 de la muestra se comparte con el trimestre anterior.

Ventajas del panel rotativo:
1. Permite medir **transiciones laborales** (ej. de desocupado a ocupado)
2. Reduce la varianza de las estimaciones
3. Distribuye la carga de trabajo de campo
4. Permite análisis longitudinales de trayectorias de empleo

---

## Diapositiva 10: Seguimiento panel de trabajadores
Gracias al panel rotativo, la ENOE permite hacer **análisis de flujos laborales**:

- ¿Cuántas personas pasaron de la informalidad a la formalidad?
- ¿Cuántos desempleados encontraron trabajo en el siguiente trimestre?
- ¿Cuántos ocupados perdieron su empleo?

Este seguimiento se logra porque las mismas viviendas son revisitadas, permitiendo observar cómo cambia la situación laboral de las personas a lo largo del tiempo (hasta 5 trimestres = ~15 meses).

INEGI publica bases de datos de **flujos laborales** derivadas de este esquema panel.

---

## Diapositiva 11: Diseño muestral
El diseño muestral de la ENOE es:

- **Probabilístico**: cada vivienda tiene una probabilidad conocida y distinta de cero de ser seleccionada.
- **Bietápico**: primero se seleccionan áreas geográficas (UPM), luego viviendas dentro de ellas.
- **Estratificado**: se divide el país en estratos (entidades, urbano vs. rural) para asegurar representación.
- **Por conglomerados**: se agrupan viviendas en unidades primarias de muestreo (manzanas o AGEBs).

Este diseño determina el tamaño de muestra y la precisión de los indicadores.

---

## Diapositiva 12: Factores de expansión
Igual que en la ENIGH, cada persona/vivienda en la ENOE tiene un **factor de expansión** que indica a cuántas personas de la población representa.

La ENOE incluye factores de expansión ajustados por:
- Probabilidad de selección
- No respuesta
- Proyecciones demográficas

Es indispensable usar estos factores al calcular cualquier indicador a nivel poblacional.

---

## Diapositiva 13: Variables clave del diseño muestral

| Variable | Rol | Descripción |
|---|---|---|
| `fac_tri` | Peso muestral (weights) | Factor de expansión trimestral |
| `fac_men` | Peso muestral mensual | Factor para estimaciones mensuales |
| `upm` | Conglomerado | Unidad Primaria de Muestreo (cluster) |
| `est_d_tri` | Estrato | Estrato de diseño muestral trimestral |

Nota: los nombres exactos pueden variar entre ediciones. Siempre verificar con el descriptor de la base.

---

## Diapositiva 14: Indicadores principales
La ENOE produce los indicadores estratégicos del mercado laboral:

- **Tasa de desocupación (TD)**: % de la PEA sin empleo que busca activamente
- **Tasa de informalidad laboral (TIL)**: % de ocupados en condiciones de informalidad
- **Tasa de subocupación**: % de ocupados que buscan más horas de trabajo
- **Tasa de participación**: % de la población 15+ que es económicamente activa
- **Tasa de condiciones críticas de ocupación (TCCO)**: ocupados en condiciones precarias

---

## Diapositiva 15: Indicadores principales (continuación)

- **Población ocupada** por sector, posición, nivel de ingresos
- **Población desocupada** por tiempo de búsqueda, experiencia laboral
- **PNEA disponible**: personas que podrían trabajar pero no buscan empleo
- **Ingresos laborales** por hora, por nivel educativo, por sector

Estos indicadores se publican a nivel nacional, por entidad federativa y por ciudad.

---

## Diapositiva 16: La transición COVID – ETOE y ENOEN
- En **abril 2020**, el levantamiento presencial de la ENOE fue suspendido por la pandemia.
- Se implementó la **ETOE** (Encuesta Telefónica de Ocupación y Empleo) de abril a junio 2020 como medida emergente. Sus resultados **no son directamente comparables** con la ENOE.
- A partir de **julio 2020**, inició la **ENOEN** (Nueva Edición), que combinó levantamiento presencial con entrevistas telefónicas.
- Desde **2022**, el levantamiento regresó a ser predominantemente presencial con modalidad mixta integrada.

---

## Diapositiva 17: Preparación de los datos de la ENOE
La ENOE viene en múltiples tablas. Las principales son:

| Tabla | Contenido |
|---|---|
| `SDEM` | Variables sociodemográficas (sexo, edad, escolaridad, parentesco) |
| `COE1` | Condición de actividad, búsqueda de empleo |
| `COE2` | Características del empleo: ocupación, sector, horas, ingresos |
| `HOGAR` | Características de la vivienda y el hogar |
| `VIVIENDA` | Datos de identificación y control de la vivienda |

```r
sdem    <- read_csv("SDEMT125.csv")
coe1    <- read_csv("COE1T125.csv")
coe2    <- read_csv("COE2T125.csv")
hogar   <- read_csv("HOGARTRIM125.csv")
vivienda <- read_csv("VIVTRIM125.csv")
```

---

## Diapositiva 18: Clasificadores y catálogos
La ENOE utiliza clasificadores estandarizados:

- **SINCO** (Sistema Nacional de Clasificación de Ocupaciones): clasifica las ocupaciones
- **SCIAN** (Sistema de Clasificación Industrial de América del Norte): clasifica las actividades económicas
- **Catálogos de entidades, municipios y localidades**: identifican la ubicación geográfica

Estos catálogos son fundamentales para interpretar correctamente los códigos en las bases de datos.

---

## Diapositiva 19: Documentos importantes
- Página general: https://www.inegi.org.mx/programas/enoe/15ymas/
- Microdatos: sección de Microdatos en la página de la ENOE
- Tabulados interactivos: https://www.inegi.org.mx/app/tabulados/interactivos/
- Documentación conceptual y cuestionarios disponibles en la página del programa

---

## Diapositiva 20: Error estándar en encuestas

Cuando estimamos un indicador a partir de una encuesta (por ejemplo, la tasa de desocupación), el valor que obtenemos **no es el valor exacto** de la población, sino una **estimación** basada en una muestra.

Si pudiéramos levantar la ENOE miles de veces, cada muestra daría un resultado ligeramente diferente. El **error estándar** mide qué tan dispersas estarían esas estimaciones: es la desviación estándar de la distribución muestral del estimador.

- Un **error estándar pequeño** = la estimación es estable y confiable.
- Un **error estándar grande** = alta variabilidad; otra muestra podría dar un resultado muy diferente.

### ¿Por qué es importante reportarlo?

Toda estimación de una encuesta tiene un **componente de incertidumbre** inherente. Reportar solo el valor puntual (ej. "la tasa de informalidad es 55.6%") sin su error estándar o intervalo de confianza es **incompleto y potencialmente engañoso**, porque:

1. **Permite evaluar la precisión**: un resultado con error estándar de 0.3% es mucho más confiable que uno con error de 5%.
2. **Permite construir intervalos de confianza**: el rango donde probablemente se encuentra el valor real (ej. 55.6% ± 1.2%).
3. **Permite comparar estimaciones**: para determinar si la diferencia entre dos grupos es estadísticamente significativa o solo es ruido muestral.
4. **Es un estándar internacional**: la OIT, el Banco Mundial y las buenas prácticas estadísticas exigen reportar medidas de variabilidad.

En R, las funciones del paquete `srvyr` (como `survey_mean`, `survey_total`) calculan automáticamente el error estándar cuando se declara correctamente el diseño de encuesta.

---

## Diapositiva 21: Imputación de valores faltantes (NAs)

### ¿Qué es la imputación?

La **imputación** es el proceso de reemplazar valores faltantes (NA) en una base de datos con valores estimados. En encuestas como la ENOE, pueden existir NAs porque:
- El informante no quiso o no pudo responder una pregunta (ej. ingreso).
- Hubo errores de captura.
- La pregunta no aplicaba pero el filtro no se ejecutó correctamente.

### ¿Por qué no simplemente eliminar los NAs?

Eliminar observaciones con NAs puede:
- **Reducir el tamaño de muestra** y perder precisión.
- **Introducir sesgo** si los datos faltantes no son aleatorios (ej. las personas con ingresos altos tienden a no reportarlos).

### Métodos comunes de imputación

| Método | Descripción | Ventajas | Desventajas |
|---|---|---|---|
| **Media/Mediana** | Reemplaza NA con la media o mediana del grupo | Simple, rápido | Reduce variabilidad, no respeta distribución |
| **Regresión** | Predice el valor faltante con un modelo de regresión | Usa relaciones entre variables | Puede sobreajustar |
| **KNN** | Usa los K vecinos más cercanos para estimar | Respeta relaciones locales | Computacionalmente costoso |
| **Hot Deck** | Reemplaza NA con el valor de un "donante" similar | Respeta distribución real, simple | Depende de buenas variables de matching |
| **Imputación múltiple** | Genera M versiones imputadas y combina resultados | Captura incertidumbre de la imputación | Más complejo |

---

## Diapositiva 22: Método Hot Deck

### ¿Cómo funciona?

El método **Hot Deck** reemplaza cada valor faltante con el valor observado de un **"donante"**: una observación similar que sí tiene respuesta.

**Pasos:**
1. Se definen **variables de estratificación** (ej. sexo, edad, estado, nivel educativo).
2. Se agrupan las observaciones en **celdas** según esas variables.
3. Dentro de cada celda, a cada registro con NA se le asigna el valor de un registro **aleatorio** que sí tiene dato.

**Ventaja clave:** los valores imputados son valores *reales* que alguien reportó, por lo que respetan la distribución natural de los datos.

### Implementación en R

```r
library(tidyverse)
library(VIM)  # Paquete para imputación Hot Deck

# --- Método 1: Usando el paquete VIM ---
datos_imputados <- hotdeck(
  data = datos_enoe,
  variable = "ingocup",           # Variable a imputar
  ord_var = c("sex", "eda", "cs_p13_1"),  # Variables de ordenamiento
  domain_var = "ent"              # Variable de dominio (estrato)
)

# --- Método 2: Implementación manual con tidyverse ---
datos_imputados <- datos_enoe %>%
  group_by(sex, niv_edu, ent) %>%          # Celdas de matching
  mutate(
    ingocup_imp = ifelse(
      is.na(ingocup),
      sample(ingocup[!is.na(ingocup)], 1),  # Donante aleatorio
      ingocup
    )
  ) %>%
  ungroup()

# Verificar la imputación
sum(is.na(datos_enoe$ingocup))        # NAs antes
sum(is.na(datos_imputados$ingocup_imp))  # NAs después (debe ser 0)
```

---

## Diapositiva 23: Ejercicios con la ENOE — survey_mean y survey_total

**Contexto:** Usaremos los microdatos de la ENOE más reciente. Primero cargamos y declaramos el diseño:

```r
library(tidyverse)
library(srvyr)

# Cargar y unir tablas
sdem <- read_csv("SDEMT125.csv")
coe2 <- read_csv("COE2T125.csv")
enoe <- sdem %>% left_join(coe2)

# Declarar diseño de encuesta
enoe_diseno <- enoe %>%
  as_survey_design(
    ids = upm,
    strata = est_d_tri,
    weights = fac_tri,
    nest = TRUE
  )
```

### Ejercicio 1: survey_total
**Estima el total de personas ocupadas en México, por sexo.**
```r
enoe_diseno %>%
  filter(clase1 == 1) %>%      # clase1 == 1: Ocupados
  group_by(sex) %>%
  summarise(total = survey_total())
```
*¿Cuántos hombres y cuántas mujeres están ocupados? ¿Cuál es el error estándar de cada estimación?*

### Ejercicio 2: survey_total por entidad
**Estima el total de personas desocupadas por entidad federativa.**
```r
enoe_diseno %>%
  filter(clase1 == 2) %>%      # clase1 == 2: Desocupados
  group_by(ent) %>%
  summarise(total_desocupados = survey_total())
```
*¿Qué entidad tiene más personas desocupadas? ¿El error estándar es mayor o menor que en la estimación nacional?*

### Ejercicio 3: survey_mean (proporción)
**Calcula la tasa de informalidad laboral por entidad federativa.**
```r
enoe_diseno %>%
  filter(clase1 == 1) %>%
  mutate(informal = as.numeric(emp_ppal == 1)) %>%
  group_by(ent) %>%
  summarise(tasa_informalidad = survey_mean(informal, na.rm = TRUE))
```
*¿En qué estados la informalidad supera el 70%? ¿Qué tamaño tiene el error estándar en esos estados?*

### Ejercicio 4: survey_mean (media)
**Calcula el ingreso promedio por ocupación principal, por nivel educativo.**
```r
enoe_diseno %>%
  filter(clase1 == 1, ingocup > 0) %>%
  group_by(cs_p13_1) %>%       # Nivel de escolaridad
  summarise(ingreso_medio = survey_mean(ingocup, na.rm = TRUE))
```
*¿Cómo varía el ingreso promedio entre niveles educativos? ¿La diferencia entre primaria y universidad es estadísticamente significativa (los intervalos de confianza no se traslapan)?*

---

## Diapositiva 24: Ejercicios con la ENOE — survey_ratio y survey_quantile

### Ejercicio 5: survey_ratio
**Calcula el ingreso por hora trabajada, por sexo.**
```r
enoe_diseno %>%
  filter(clase1 == 1, ingocup > 0, hrsocup > 0) %>%
  group_by(sex) %>%
  summarise(
    ingreso_por_hora = survey_ratio(
      numerator = ingocup,
      denominator = hrsocup * 4.33,  # horas mensuales aprox.
      na.rm = TRUE
    )
  )
```
*¿Existe brecha salarial por hora entre hombres y mujeres? ¿Es estadísticamente significativa?*

### Ejercicio 6: survey_ratio
**Calcula la razón entre población informal y formal, por entidad.**
```r
enoe_diseno %>%
  filter(clase1 == 1) %>%
  mutate(
    informal = as.numeric(emp_ppal == 1),
    formal = as.numeric(emp_ppal == 2)
  ) %>%
  group_by(ent) %>%
  summarise(
    razon_inf_for = survey_ratio(
      numerator = informal,
      denominator = formal,
      na.rm = TRUE
    )
  )
```
*Una razón > 1 significa que hay más informales que formales. ¿Qué entidades tienen la razón más alta?*

### Ejercicio 7: survey_quantile
**Calcula los percentiles 25, 50 (mediana) y 75 del ingreso por ocupación principal.**
```r
enoe_diseno %>%
  filter(clase1 == 1, ingocup > 0) %>%
  summarise(
    percentiles = survey_quantile(
      ingocup,
      quantiles = c(0.25, 0.50, 0.75),
      na.rm = TRUE
    )
  )
```
*¿Cuál es la mediana del ingreso? ¿Qué tan amplio es el rango intercuartílico?*

### Ejercicio 8: survey_quantile por grupo
**Calcula la mediana del ingreso por sexo y nivel educativo.**
```r
enoe_diseno %>%
  filter(clase1 == 1, ingocup > 0) %>%
  group_by(sex, cs_p13_1) %>%
  summarise(
    mediana = survey_quantile(
      ingocup,
      quantiles = 0.5,
      na.rm = TRUE
    )
  )
```
*¿En qué nivel educativo se observa la mayor brecha de ingresos entre hombres y mujeres?*
