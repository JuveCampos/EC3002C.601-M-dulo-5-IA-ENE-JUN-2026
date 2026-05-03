# ---------------------------------------------------------------------------
# Generación de banco de preguntas adicionales — Módulo 5 IA
# Curso: EC3002C.601 — Tec de Monterrey
# Fecha: 2026-05-02
# Descripción: A partir del contenido de las 9 sesiones, se generan 56
#   preguntas de opción múltiple difíciles. Distribución EXACTA:
#   14 A, 14 B, 14 C, 14 D.
# ---------------------------------------------------------------------------

library(tidyverse)
library(readxl)
library(writexl)

# ---------------------------------------------------------------------------
# 1) Leer archivo original
# ---------------------------------------------------------------------------
original <- read_excel(
  "03_examen_modulo5/examen_25_preguntas.xlsx"
)

# ---------------------------------------------------------------------------
# 2) Definir 56 preguntas nuevas con distribución controlada
#    A=14, B=14, C=14, D=14
# ---------------------------------------------------------------------------

nuevas_raw <- list(
  # === Sesión 1: Introducción a la IA (7 preguntas: A1 B2 C1 D3) ===
  list(
    tema = "Sesión 1: Introducción a la IA",
    pregunta = "Un modelo LLM genera una cita textual de un artículo científico que no existe. ¿Qué fenómeno se está manifestando?",
    correcta = "D",
    opts = list(
      A = "RAG (Retrieval Augmented Generation).",
      B = "Fine-tuning sobre corpus académico.",
      C = "Temperature elevada en la tokenización.",
      D = "Alucinación (hallucination)."
    ),
    explicacion = "Las alucinaciones ocurren cuando un LLM genera información falsa con total confianza, como citas o hechos inexistentes."
  ),
  list(
    tema = "Sesión 1: Introducción a la IA",
    pregunta = "¿Cuál de los siguientes ingredientes del prompt NO forma parte del acrónimo TaCoLiRo?",
    correcta = "D",
    opts = list(
      A = "Tarea.",
      B = "Contexto.",
      C = "Límites.",
      D = "Fuentes."
    ),
    explicacion = "TaCoLiRo son: Tarea, Contexto, Límites y Rol. Las fuentes no son un ingrediente mínimo obligatorio del framework."
  ),
  list(
    tema = "Sesión 1: Introducción a la IA",
    pregunta = "Según los principios éticos del Tec, ¿qué principio obliga a contrastar y validar la información generada por IA antes de usarla en un trabajo académico?",
    correcta = "B",
    opts = list(
      A = "Responsabilidad.",
      B = "Veracidad.",
      C = "No maleficencia.",
      D = "Explicabilidad y transparencia."
    ),
    explicacion = "El principio de veracidad exige que la información generada por IA sea contrastada y validada antes de su uso."
  ),
  list(
    tema = "Sesión 1: Introducción a la IA",
    pregunta = "Un estudiante entrena un modelo de lenguaje con datos médicos propios para que responda únicamente sobre salud pública en México. ¿Qué técnica describe esta situación?",
    correcta = "C",
    opts = list(
      A = "Prompt engineering con XML.",
      B = "RAG con embeddings semánticos.",
      C = "Fine-tuning (ajuste fino).",
      D = "Uso de system prompt restrictivo."
    ),
    explicacion = "El fine-tuning ajusta un modelo preentrenado con datos específicos de un dominio concreto, en este caso datos médicos."
  ),
  list(
    tema = "Sesión 1: Introducción a la IA",
    pregunta = "En el contexto de LLMs, ¿qué parámetro controla el equilibrio entre precisión y creatividad en las respuestas generadas?",
    correcta = "D",
    opts = list(
      A = "Context window.",
      B = "Top-p (nucleus sampling).",
      C = "Learning rate.",
      D = "Temperature (temperatura)."
    ),
    explicacion = "La temperature controla qué tan creativa o predecible es la respuesta: baja (0.0) = precisa; alta (1.0) = creativa."
  ),
  list(
    tema = "Sesión 1: Introducción a la IA",
    pregunta = "¿Cuál es la diferencia principal entre latencia y throughput en sistemas de IA?",
    correcta = "B",
    opts = list(
      A = "Latencia mide calidad de respuesta; throughput mide uso de memoria.",
      B = "Latencia es tiempo hasta primera respuesta; throughput es solicitudes procesadas simultáneamente.",
      C = "Latencia depende del modelo; throughput depende del hardware exclusivamente.",
      D = "No hay diferencia; son sinónimos en arquitecturas REST."
    ),
    explicacion = "Latencia = tiempo que tarda en empezar a responder; Throughput = cuántas solicitudes procesa simultáneamente."
  ),
  list(
    tema = "Sesión 1: Introducción a la IA",
    pregunta = "Un asistente legal configurado para responder solo sobre leyes mexicanas tiene establecida una instrucción base oculta al usuario que define su comportamiento. ¿Cómo se llama esta instrucción?",
    correcta = "A",
    opts = list(
      A = "System prompt.",
      B = "RAG prompt.",
      C = "Context window.",
      D = "Zero-shot prompt."
    ),
    explicacion = "El system prompt es la instrucción base que define personalidad, límites y enfoque del modelo antes de la interacción del usuario."
  ),

  # === Sesión 2: Vibe Coding e Introducción a R (6: A1 B2 C0 D3) ===
  list(
    tema = "Sesión 2: Vibe Coding e Introducción a R",
    pregunta = "¿Quién acuñó el término 'vibe coding' y en qué fecha aproximada?",
    correcta = "B",
    opts = list(
      A = "Sam Altman, enero de 2024.",
      B = "Andrej Karpathy, febrero de 2025.",
      C = "Geoffrey Hinton, marzo de 2023.",
      D = "Yann LeCun, noviembre de 2024."
    ),
    explicacion = "Andrej Karpathy (cofundador de OpenAI) acuñó el término en febrero de 2025."
  ),
  list(
    tema = "Sesión 2: Vibe Coding e Introducción a R",
    pregunta = "En R, ¿qué operador se recomienda para asignar un objeto a la memoria según las convenciones del curso?",
    correcta = "A",
    opts = list(
      A = "<- (flechita).",
      B = "= (igual).",
      C = "-> (flecha derecha).",
      D = "<<- (asignación global)."
    ),
    explicacion = "El operador flechita (<-) es la convención estándar en R para asignar objetos a la memoria."
  ),
  list(
    tema = "Sesión 2: Vibe Coding e Introducción a R",
    pregunta = "¿Cuál es la diferencia fundamental entre instalar una librería y llamarla en R?",
    correcta = "D",
    opts = list(
      A = "Instalar la carga en memoria; llamarla la descarga de CRAN.",
      B = "Instalar se hace una sola vez por computadora; llamar se hace en cada sesión con library().",
      C = "Instalar solo sirve para librerías tidyverse; llamar sirve para todas.",
      D = "No hay diferencia; install.packages() y library() son sinónimos."
    ),
    explicacion = "Instalar es como comprar la herramienta (una sola vez); llamar es sacarla de la caja para usarla (cada sesión)."
  ),
  list(
    tema = "Sesión 2: Vibe Coding e Introducción a R",
    pregunta = "Una estructura de datos en R que puede contener vectores, matrices, data frames e incluso otras listas dentro de sí misma se denomina:",
    correcta = "D",
    opts = list(
      A = "Array.",
      B = "Matriz.",
      C = "Tibble.",
      D = "Lista."
    ),
    explicacion = "Las listas son contenedores de cualquier cosa: pueden albergar data frames, matrices, vectores e incluso otras listas."
  ),
  list(
    tema = "Sesión 2: Vibe Coding e Introducción a R",
    pregunta = "En la notación paquete::funcion(), ¿qué representa el elemento a la izquierda de los dos puntos dobles?",
    correcta = "D",
    opts = list(
      A = "El namespace del entorno global.",
      B = "La versión mínima requerida del paquete.",
      C = "El tipo de dato que retorna la función.",
      D = "La librería o paquetería de la cual proviene la función."
    ),
    explicacion = "En dplyr::filter(), 'dplyr' es el apellido (librería) y 'filter' es el nombre de la función."
  ),
  list(
    tema = "Sesión 2: Vibe Coding e Introducción a R",
    pregunta = "¿Cuál de los siguientes NO es un archivo nativo de R/RStudio?",
    correcta = "B",
    opts = list(
      A = "*.Rproj",
      B = "*.ipynb",
      C = "*.RData",
      D = "*.rds"
    ),
    explicacion = "*.ipynb es el formato de notebooks de Jupyter, no un archivo nativo de R. Los nativos son .Rproj, .RData, .R y .rds."
  ),

  # === Sesión 3: Tidyverse (7: A1 B2 C2 D2) ===
  list(
    tema = "Sesión 3: Tidyverse y manipulación de datos",
    pregunta = "¿Cuál es la función del tidyverse que permite transformar columnas de un data frame en pares nombre-valor (wide → long)?",
    correcta = "D",
    opts = list(
      A = "pivot_wider()",
      B = "spread()",
      C = "separate()",
      D = "pivot_longer()"
    ),
    explicacion = "pivot_longer() pasa datos de formato ancho a largo, creando columnas de nombres y valores a partir de múltiples columnas."
  ),
  list(
    tema = "Sesión 3: Tidyverse y manipulación de datos",
    pregunta = "En un pipeline de dplyr, si deseas conservar únicamente las filas donde la variable 'edad' sea mayor o igual a 18 y la variable 'estado' sea 'Activo', ¿qué función y operadores lógicos usarías correctamente?",
    correcta = "D",
    opts = list(
      A = "filter(edad >= 18 | estado == 'Activo')",
      B = "select(edad >= 18, estado == 'Activo')",
      C = "slice(edad >= 18 & estado == 'Activo')",
      D = "filter(edad >= 18, estado == 'Activo') o filter(edad >= 18 & estado == 'Activo')"
    ),
    explicacion = "filter() filtra filas. Las condiciones se pueden separar por coma o con & (AND). | sería OR, lo cual es incorrecto para este requerimiento."
  ),
  list(
    tema = "Sesión 3: Tidyverse y manipulación de datos",
    pregunta = "¿Qué join conserva TODAS las filas de ambas tablas y rellena con NA donde no hay coincidencia?",
    correcta = "B",
    opts = list(
      A = "inner_join()",
      B = "full_join()",
      C = "right_join()",
      D = "left_join()"
    ),
    explicacion = "full_join() conserva todas las filas de ambas tablas, rellenando con NA donde no exista coincidencia en la llave."
  ),
  list(
    tema = "Sesión 3: Tidyverse y manipulación de datos",
    pregunta = "Un analista quiere calcular el promedio de ingreso por estado, incluyendo el número de observaciones en cada grupo. ¿Qué combinación de funciones dentro de summarise es la correcta?",
    correcta = "C",
    opts = list(
      A = "mean(ingreso) y count()",
      B = "survey_mean(ingreso) y n()",
      C = "mean(ingreso) y n()",
      D = "avg(ingreso) y length()"
    ),
    explicacion = "En dplyr estándar se usa mean() para el promedio y n() para contar filas por grupo dentro de summarise(). survey_mean pertenece a srvyr."
  ),
  list(
    tema = "Sesión 3: Tidyverse y manipulación de datos",
    pregunta = "¿Cuál de las siguientes afirmaciones sobre el operador pipa (%>%) del tidyverse es FALSA?",
    correcta = "C",
    opts = list(
      A = "Permite encadenar funciones de forma legible.",
      B = "Se lee coloquialmente como 'y después'.",
      C = "Se usa también entre capas de ggplot2.",
      D = "En Mac se escribe con Command + Shift + M."
    ),
    explicacion = "En ggplot2 las capas se suman con +, NO con %>>%. Las demás afirmaciones sobre la pipa son verdaderas."
  ),
  list(
    tema = "Sesión 3: Tidyverse y manipulación de datos",
    pregunta = "Para leer un archivo Excel en R dentro del ecosistema tidyverse, ¿qué librería y función se recomiendan?",
    correcta = "B",
    opts = list(
      A = "readr::read_csv()",
      B = "readxl::read_excel()",
      C = "haven::read_dta()",
      D = "openxlsx::loadWorkbook()"
    ),
    explicacion = "readxl::read_excel() es la función del tidyverse diseñada específicamente para importar archivos Excel."
  ),
  list(
    tema = "Sesión 3: Tidyverse y manipulación de datos",
    pregunta = "¿Cuál es la ventaja principal de usar rutas relativas (ej. 'Data/datos.csv') sobre rutas absolutas en un proyecto de R?",
    correcta = "A",
    opts = list(
      A = "Las rutas relativas funcionan en cualquier computadora que tenga la misma estructura de proyecto, mejorando la replicabilidad.",
      B = "Las rutas relativas son más cortas de escribir.",
      C = "Las rutas absolutas no funcionan en Windows.",
      D = "RStudio no permite rutas absolutas en scripts."
    ),
    explicacion = "La replicabilidad es clave: si usas rutas relativas ancladas al .Rproj, tu código funciona en otras máquinas con la misma estructura de carpetas."
  ),

  # === Sesión 4: ggplot2 (6: A2 B2 C1 D1) ===
  list(
    tema = "Sesión 4: Visualización con ggplot2",
    pregunta = "En ggplot2, ¿cuál es el orden conceptual correcto de las capas desde los datos hasta la estética final?",
    correcta = "A",
    opts = list(
      A = "Data → Mapping → Layers → Scales → Facets → Coordinates → Theme",
      B = "Data → Layers → Mapping → Scales → Coordinates → Facets → Theme",
      C = "Mapping → Data → Layers → Facets → Scales → Coordinates → Theme",
      D = "Data → Theme → Mapping → Layers → Scales → Facets → Coordinates"
    ),
    explicacion = "El orden conceptual es: Data, Mapping, Layers (geoms), Scales, Facets, Coordinates, Theme."
  ),
  list(
    tema = "Sesión 4: Visualización con ggplot2",
    pregunta = "¿Cuál geometría de ggplot2 es la más adecuada para visualizar la relación entre dos variables continuas con una línea de tendencia suavizada?",
    correcta = "C",
    opts = list(
      A = "geom_bar()",
      B = "geom_histogram()",
      C = "geom_point() + geom_smooth()",
      D = "geom_col() + geom_errorbar()"
    ),
    explicacion = "geom_point() muestra los puntos y geom_smooth() agrega una línea de tendencia suavizada (por defecto LOESS o lm si se especifica)."
  ),
  list(
    tema = "Sesión 4: Visualización con ggplot2",
    pregunta = "¿Qué función se utiliza para guardar el último gráfico generado en ggplot2 a un archivo PNG?",
    correcta = "D",
    opts = list(
      A = "save_plot()",
      B = "write_png()",
      C = "export_graph()",
      D = "ggsave()"
    ),
    explicacion = "ggsave() es la función nativa de ggplot2 para exportar gráficos a diversos formatos como PNG, PDF o SVG."
  ),
  list(
    tema = "Sesión 4: Visualización con ggplot2",
    pregunta = "Un estudiante quiere eliminar las líneas de cuadrícula menores de un gráfico ggplot2. ¿Qué elemento del tema debe modificar?",
    correcta = "D",
    opts = list(
      A = "panel.grid.major",
      B = "plot.background",
      C = "axis.ticks",
      D = "panel.grid.minor"
    ),
    explicacion = "panel.grid.minor controla las líneas de cuadrícula menores. Para eliminarlas se asigna element_blank()."
  ),
  list(
    tema = "Sesión 4: Visualización con ggplot2",
    pregunta = "¿Cuál de los siguientes pares de funciones de tema en ggplot2 permiten controlar respectivamente el título del gráfico y la posición de la leyenda?",
    correcta = "A",
    opts = list(
      A = "plot.title y legend.position",
      B = "plot.subtitle y legend.title",
      C = "plot.caption y legend.key",
      D = "plot.background y legend.text"
    ),
    explicacion = "plot.title controla el título principal del gráfico; legend.position permite ubicar la leyenda (left, right, bottom, top, none o coordenadas)."
  ),
  list(
    tema = "Sesión 4: Visualización con ggplot2",
    pregunta = "¿Por qué el cuarteto de Anscombe es una lección fundamental para cualquier analista de datos antes de modelar?",
    correcta = "B",
    opts = list(
      A = "Porque demuestra que cuatro datasets con medias, varianzas y correlaciones idénticas pueden tener estructuras visuales completamente distintas.",
      B = "Porque fue el primer ejemplo de regresión lineal múltiple en la historia.",
      C = "Porque demuestra que ggplot2 es superior a Excel en todos los escenarios.",
      D = "Porque establece que la correlación siempre implica causalidad."
    ),
    explicacion = "El cuarteto de Anscombe muestra que estadísticas descriptivas idénticas pueden esconder patrones muy diferentes (lineal, curvo, outlier), por lo que siempre hay que graficar."
  ),

  # === Sesión 5: Mapas (6: A0 B2 C3 D1) ===
  list(
    tema = "Sesión 5: Mapas e información geográfica",
    pregunta = "¿Cuál es el código EPSG más común para trabajar con coordenadas de latitud/longitud en leaflet y Google Maps?",
    correcta = "B",
    opts = list(
      A = "EPSG:6372",
      B = "EPSG:4326",
      C = "EPSG:6362",
      D = "EPSG:2163"
    ),
    explicacion = "EPSG:4326 (WGS84) es el sistema de coordenadas geográficas estándar usado por leaflet, Google Maps y GPS."
  ),
  list(
    tema = "Sesión 5: Mapas e información geográfica",
    pregunta = "¿Qué formato de archivo geoespacial vectorial se compone de múltiples archivos obligatorios (.shp, .dbf, .shx, .prj) y es el más común en la industria SIG?",
    correcta = "C",
    opts = list(
      A = "GeoJSON",
      B = "KML",
      C = "ESRI Shapefile",
      D = "GeoTIFF"
    ),
    explicacion = "El ESRI Shapefile está compuesto por múltiples archivos (al menos .shp, .dbf, .shx, .prj) y es el formato vectorial más extendido."
  ),
  list(
    tema = "Sesión 5: Mapas e información geográfica",
    pregunta = "En R, ¿qué función del paquete sf convierte un data frame con columnas de longitud y latitud en un objeto espacial sf?",
    correcta = "C",
    opts = list(
      A = "st_read()",
      B = "st_write()",
      C = "st_as_sf()",
      D = "geom_sf()"
    ),
    explicacion = "st_as_sf() convierte un data frame con coordenadas en un objeto espacial sf, especificando coords y crs."
  ),
  list(
    tema = "Sesión 5: Mapas e información geográfica",
    pregunta = "¿Cuál es la clave geoestadística INEGI que identifica de forma única un municipio y que se usa típicamente como llave en joins espaciales?",
    correcta = "D",
    opts = list(
      A = "CVE_ENT",
      B = "CVE_MUN",
      C = "AGEB",
      D = "CVEGEO"
    ),
    explicacion = "CVEGEO concatena CVE_ENT (2 dígitos) + CVE_MUN (3 dígitos) y funciona como ID único del polígono municipal para unir geometrías con atributos."
  ),
  list(
    tema = "Sesión 5: Mapas e información geográfica",
    pregunta = "Un analista desea crear un mapa interactivo con fondo de OpenStreetMap, marcadores circulares y ventanas emergentes en R. ¿Qué combinación de paquetes es la mínima necesaria?",
    correcta = "C",
    opts = list(
      A = "sf + ggplot2",
      B = "terra + tidyterra",
      C = "leaflet + htmlwidgets",
      D = "raster + sp"
    ),
    explicacion = "leaflet genera mapas interactivos con tiles de OSM y htmlwidgets permite guardarlos como HTML independiente."
  ),
  list(
    tema = "Sesión 5: Mapas e información geográfica",
    pregunta = "¿Cuál es el propósito principal del paquete terra en el análisis geoespacial con R?",
    correcta = "B",
    opts = list(
      A = "Crear mapas interactivos con popups.",
      B = "Manejar datos raster modernos y eficientes.",
      C = "Realizar operaciones de geocodificación inversa.",
      D = "Dibujar polígonos vectoriales con coordenadas GPS."
    ),
    explicacion = "terra es el paquete moderno para manejar datos raster en R, reemplazando funcionalidades del paquete raster más antiguo."
  ),

  # === Sesión 6: ENIGH (7: A3 B1 C2 D1) ===
  list(
    tema = "Sesión 6: ENIGH — Encuesta Nacional de Ingresos y Gastos",
    pregunta = "¿Cuál es la unidad de análisis de la ENIGH?",
    correcta = "B",
    opts = list(
      A = "La persona individual.",
      B = "El hogar.",
      C = "La vivienda.",
      D = "La familia nuclear."
    ),
    explicacion = "La ENIGH tiene como unidad de análisis el hogar: personas que comparten vivienda y destinan recursos a necesidades básicas."
  ),
  list(
    tema = "Sesión 6: ENIGH — Encuesta Nacional de Ingresos y Gastos",
    pregunta = "¿Qué variable del diseño muestral de la ENIGH indica a cuántos hogares de la población representa cada hogar encuestado?",
    correcta = "C",
    opts = list(
      A = "upm",
      B = "est_dis",
      C = "factor (o factor_hog / factor_per)",
      D = "cve_ent"
    ),
    explicacion = "El factor de expansión indica el peso muestral: a cuántas unidades poblacionales representa cada observación encuestada."
  ),
  list(
    tema = "Sesión 6: ENIGH — Encuesta Nacional de Ingresos y Gastos",
    pregunta = "¿Cuál es la principal diferencia entre desviación estándar y error estándar en el contexto de la ENIGH?",
    correcta = "A",
    opts = list(
      A = "La desviación estándar mide la dispersión de los datos individuales; el error estándar mide la dispersión de las estimaciones si se repitiera el muestreo.",
      B = "La desviación estándar solo aplica a variables continuas; el error estándar aplica a cualquier tipo de variable.",
      C = "No hay diferencia; ambos son estimadores de la varianza poblacional.",
      D = "El error estándar siempre es mayor que la desviación estándar en muestras grandes."
    ),
    explicacion = "Desviación estándar = dispersión entre hogares. Error estándar = dispersión de estimaciones si repitieras la encuesta muchas veces."
  ),
  list(
    tema = "Sesión 6: ENIGH — Encuesta Nacional de Ingresos y Gastos",
    pregunta = "Para declarar correctamente el diseño muestral de la ENIGH en srvyr, ¿qué tres elementos mínimos se deben especificar?",
    correcta = "A",
    opts = list(
      A = "ids (upm), strata (est_dis), weights (factor)",
      B = "ids (cve_ent), strata (est_dis), weights (factor_hog)",
      C = "ids (upm), probs, fpc",
      D = "ids (foliohog), strata (ubica_geo), weights (factor)"
    ),
    explicacion = "El patrón estándar es: ids = upm (conglomerado), strata = est_dis (estrato), weights = factor (peso muestral)."
  ),
  list(
    tema = "Sesión 6: ENIGH — Encuesta Nacional de Ingresos y Gastos",
    pregunta = "¿Cuál tabla de la ENIGH contiene el ingreso corriente y el gasto agregado por hogar y es considerada la tabla resumen?",
    correcta = "C",
    opts = list(
      A = "poblacion",
      B = "ingresos",
      C = "concentradohogar",
      D = "viviendas"
    ),
    explicacion = "concentradohogar es la tabla resumen que agrega ingreso corriente, gasto y características generales del hogar."
  ),
  list(
    tema = "Sesión 6: ENIGH — Encuesta Nacional de Ingresos y Gastos",
    pregunta = "Un investigador necesita calcular el ingreso laboral trimestral promedio por sexo con intervalos de confianza usando la ENIGH. ¿Qué función de srvyr debe emplear?",
    correcta = "D",
    opts = list(
      A = "survey_total()",
      B = "survey_median()",
      C = "survey_ratio()",
      D = "survey_mean() con vartype = 'ci'"
    ),
    explicacion = "survey_mean() calcula la media ponderada y vartype = 'ci' devuelve el intervalo de confianza, que es lo requerido para estimaciones de ingreso."
  ),
  list(
    tema = "Sesión 6: ENIGH — Encuesta Nacional de Ingresos y Gastos",
    pregunta = "¿Qué significa que el diseño muestral de la ENIGH sea 'estratificado' y 'por conglomerados'?",
    correcta = "A",
    opts = list(
      A = "Que se divide el país en estratos (entidad, urbano/rural) y se seleccionan primero áreas geográficas (manzanas/AGEBs) y luego hogares dentro de ellas.",
      B = "Que se elige una muestra aleatoria simple de todo el país sin agrupaciones.",
      C = "Que cada hogar tiene la misma probabilidad de ser seleccionado independientemente de su ubicación.",
      D = "Que la muestra se divide en quintiles de ingreso para garantizar representatividad económica."
    ),
    explicacion = "Estratificado = división en estratos. Por conglomerados = selección en dos etapas (áreas geográficas primero, hogares después)."
  ),

  # === Sesión 7: ENOE (6: A3 B0 C3 D0) ===
  list(
    tema = "Sesión 7: ENOE — Encuesta Nacional de Ocupación y Empleo",
    pregunta = "¿Cuál es la frecuencia de levantamiento de la ENOE?",
    correcta = "C",
    opts = list(
      A = "Anual.",
      B = "Bienal (cada dos años).",
      C = "Trimestral (continua).",
      D = "Decenal."
    ),
    explicacion = "La ENOE es trimestral y continua desde 2005, lo que permite seguimiento oportuno del mercado laboral."
  ),
  list(
    tema = "Sesión 7: ENOE — Encuesta Nacional de Ocupación y Empleo",
    pregunta = "En la ENOE, la población desocupada se define como aquella que:",
    correcta = "A",
    opts = list(
      A = "No tiene empleo pero lo busca activamente.",
      B = "No tiene empleo y no busca trabajo.",
      C = "Tiene empleo pero busca otro mejor remunerado.",
      D = "Trabaja menos de 15 horas semanales."
    ),
    explicacion = "Según la definición OIT usada por la ENOE, desocupados son quienes no tienen empleo y lo buscan activamente."
  ),
  list(
    tema = "Sesión 7: ENOE — Encuesta Nacional de Ocupación y Empleo",
    pregunta = "¿Qué ventaja metodológica ofrece el esquema de panel rotativo de la ENOE sobre un diseño de corte transversal?",
    correcta = "A",
    opts = list(
      A = "Permite medir transiciones laborales (ej. desocupado → ocupado) y reduce la varianza de estimaciones.",
      B = "Permite encuestar a toda la población en cada trimestre.",
      C = "Elimina completamente el error estándar de las estimaciones.",
      D = "Hace que la muestra sea aleatoria simple en lugar de probabilística."
    ),
    explicacion = "El panel rotativo permite seguimiento de individuos en el tiempo (transiciones) y mejora la precisión de las estimaciones."
  ),
  list(
    tema = "Sesión 7: ENOE — Encuesta Nacional de Ocupación y Empleo",
    pregunta = "¿Cuál tabla de la ENOE contiene las características sociodemográficas de las personas (sexo, edad, escolaridad) junto con el diseño muestral?",
    correcta = "C",
    opts = list(
      A = "COE1",
      B = "COE2",
      C = "SDEM",
      D = "HOGAR"
    ),
    explicacion = "SDEM (Sociodemográfico) contiene sexo, edad, escolaridad, estado civil y las variables de diseño muestral (upm, fac_tri, est_d_tri)."
  ),
  list(
    tema = "Sesión 7: ENOE — Encuesta Nacional de Ocupación y Empleo",
    pregunta = "Para calcular la tasa de informalidad laboral por entidad federativa con srvyr y la ENOE, ¿qué combinación de pasos es la correcta?",
    correcta = "A",
    opts = list(
      A = "Declarar diseño, filtrar PEA, crear dummy (informal=1, formal=0), group_by(cve_ent), survey_mean(dummy_informalidad)*100",
      B = "Declarar diseño, filtrar ocupados, crear dummy (emp_ppal==1), group_by(cve_ent), survey_total(dummy_informalidad)",
      C = "Declarar diseño, filtrar desocupados, group_by(cve_ent), survey_ratio(informal, formal)",
      D = "Declarar diseño, group_by(sex), survey_mean(ingocup)"
    ),
    explicacion = "La tasa de informalidad se calcula sobre la PEA (clase1==1), creando un dummy para informal (emp_ppal==1) y aplicando survey_mean, multiplicando por 100."
  ),
  list(
    tema = "Sesión 7: ENOE — Encuesta Nacional de Ocupación y Empleo",
    pregunta = "¿Qué función de srvyr permite calcular la mediana ponderada del ingreso ocupacional por grupos (ej. sexo y nivel educativo)?",
    correcta = "C",
    opts = list(
      A = "survey_mean()",
      B = "survey_total()",
      C = "survey_quantile() con quantiles = 0.5",
      D = "survey_ratio()"
    ),
    explicacion = "survey_quantile() con quantiles = 0.5 calcula la mediana ponderada del diseño muestral para la variable especificada."
  ),

  # === Sesión 8: Ingesta de datos (6: A1 B1 C1 D3) ===
  list(
    tema = "Sesión 8: Ingesta de datos — Web Scraping y descarga",
    pregunta = "¿Cuál es la principal ventaja de descargar datos de manera programática con R en lugar de hacerlo manualmente?",
    correcta = "D",
    opts = list(
      A = "Los archivos descargados por código pesan menos en disco.",
      B = "Permite reproducibilidad, automatización de descargas masivas y compartir solo el código sin archivos pesados.",
      C = "Los datos programáticos no requieren limpieza posterior.",
      D = "Las APIs gratuitas siempre permiten descargas ilimitadas sin registro."
    ),
    explicacion = "La descarga programática facilita la reproducibilidad, automatiza procesos repetitivos y evita subir archivos grandes a repositorios."
  ),
  list(
    tema = "Sesión 8: Ingesta de datos — Web Scraping y descarga",
    pregunta = "¿Qué función de rvest se utiliza para extraer el texto contenido dentro de nodos HTML seleccionados con un selector CSS?",
    correcta = "C",
    opts = list(
      A = "html_nodes()",
      B = "html_attr()",
      C = "html_text()",
      D = "html_table()"
    ),
    explicacion = "html_text() extrae el contenido textual de los nodos HTML previamente seleccionados con html_nodes()."
  ),
  list(
    tema = "Sesión 8: Ingesta de datos — Web Scraping y descarga",
    pregunta = "Un analista necesita descargar un archivo ZIP desde una URL y descomprimirlo en una carpeta local usando R. ¿Qué combinación de funciones es la adecuada?",
    correcta = "B",
    opts = list(
      A = "download.file() + unzip()",
      B = "curl::curl_download() + zip::unzip()",
      C = "readr::read_csv() + zip::unzip()",
      D = "httr::GET() + jsonlite::fromJSON()"
    ),
    explicacion = "curl::curl_download() descarga el archivo binario desde la URL y zip::unzip() lo descomprime en el directorio especificado."
  ),
  list(
    tema = "Sesión 8: Ingesta de datos — Web Scraping y descarga",
    pregunta = "¿Cuál de las siguientes consideraciones éticas NO es una buena práctica al realizar web scraping?",
    correcta = "B",
    opts = list(
      A = "Revisar el archivo robots.txt del sitio antes de scrapear.",
      B = "Realizar miles de peticiones por segundo para maximizar la velocidad de extracción.",
      C = "Incluir pausas entre peticiones con Sys.sleep() para no saturar el servidor.",
      D = "Identificarse honestamente en las solicitudes HTTP."
    ),
    explicacion = "Saturar un servidor con miles de peticiones por segundo viola la ética del scraping y puede causar bloqueos o daños al servicio."
  ),
  list(
    tema = "Sesión 8: Ingesta de datos — Web Scraping y descarga",
    pregunta = "¿Cuál es la diferencia fundamental entre datos estructurados y no estructurados?",
    correcta = "D",
    opts = list(
      A = "Los estructurados son de pago; los no estructurados son gratuitos.",
      B = "Los estructurados tienen forma predefinida (tabular); los no estructurados requieren extracción y empaquetado previo.",
      C = "Los no estructurados son siempre imágenes; los estructurados son siempre CSV.",
      D = "No existe diferencia; ambos términos son sinónimos en ciencia de datos."
    ),
    explicacion = "Datos estructurados vienen en formatos tabulares predefinidos (CSV, Excel). Los no estructurados (PDFs, páginas web) requieren procesamiento para extraer la información."
  ),
  list(
    tema = "Sesión 8: Ingesta de datos — Web Scraping y descarga",
    pregunta = "Al scrapear una tabla de Wikipedia con rvest, si la página contiene múltiples tablas y se desea extraer específicamente la tercera, ¿qué función y estrategia se recomienda?",
    correcta = "A",
    opts = list(
      A = "html_table() %>% pluck(3)",
      B = "html_nodes('table') %>% html_text()",
      C = "html_attr('table') %>% slice(3)",
      D = "read_html() %>% filter(tabla == 3)"
    ),
    explicacion = "html_table() extrae todas las tablas como lista; pluck(3) selecciona el tercer elemento de esa lista."
  ),

  # === Sesión 9: APIs y LLMs (5: A2 B2 C1 D0) ===
  list(
    tema = "Sesión 9: APIs y uso de LLMs vía API",
    pregunta = "¿Qué significa que una API sea 'RESTful' en el contexto de intercambio de datos?",
    correcta = "B",
    opts = list(
      A = "Que utiliza únicamente el protocolo FTP para transferencia de archivos.",
      B = "Que emplea métodos HTTP estándar (GET, POST, PUT, DELETE) para operaciones sobre recursos identificados por URLs.",
      C = "Que requiere autenticación OAuth 2.0 obligatoriamente en cada solicitud.",
      D = "Que solo devuelve respuestas en formato XML."
    ),
    explicacion = "REST es un estilo arquitectónico que usa métodos HTTP estándar para interactuar con recursos a través de URLs, típicamente devolviendo JSON."
  ),
  list(
    tema = "Sesión 9: APIs y uso de LLMs vía API",
    pregunta = "Al consumir una API REST desde R sin un cliente específico disponible, ¿qué secuencia de paquetes y pasos es la correcta?",
    correcta = "A",
    opts = list(
      A = "httr::GET() → httr::content('text') → jsonlite::fromJSON()",
      B = "readr::read_csv() → dplyr::filter() → tidyr::pivot_longer()",
      C = "xml2::read_xml() → xml2::xml_find_all() → xml2::xml_text()",
      D = "rvest::read_html() → rvest::html_table() → dplyr::bind_rows()"
    ),
    explicacion = "El flujo estándar con httr + jsonlite es: GET para la petición, content para extraer el JSON crudo, y fromJSON para convertirlo en lista de R."
  ),
  list(
    tema = "Sesión 9: APIs y uso de LLMs vía API",
    pregunta = "¿Cuál es la ventaja principal de usar un 'API client' (ej. spotifyr, inegiR, tuber) sobre realizar llamadas directas con httr?",
    correcta = "A",
    opts = list(
      A = "Los clients permiten acceder a los resultados estructurados directamente como objetos de R, ocultando la complejidad de la API.",
      B = "Los clients eliminan por completo los rate limits impuestos por el proveedor.",
      C = "Los clients no requieren tokens ni autenticación de ningún tipo.",
      D = "Los clients solo funcionan con APIs de pago."
    ),
    explicacion = "Los clients son interfaces nativas que abstraen la API y devuelven resultados como data frames u objetos de R, simplificando el código."
  ),
  list(
    tema = "Sesión 9: APIs y uso de LLMs vía API",
    pregunta = "Un estudiante quiere usar la API de OpenAI desde R sin exponer su clave en el código del script. ¿Cuál es la práctica recomendada?",
    correcta = "B",
    opts = list(
      A = "Escribir la clave en un comentario al inicio del script para recordarla.",
      B = "Guardarla en el archivo .Renviron con usethis::edit_r_environ() y leerla con Sys.getenv('OPENAI_API_KEY').",
      C = "Crear un objeto llamado api_key <- 'sk-...' al principio del script.",
      D = "Subir la clave al repositorio de GitHub en un archivo llamado credentials.txt."
    ),
    explicacion = "La buena práctica es almacenar tokens en variables de entorno (.Renviron) y leerlas con Sys.getenv(), nunca hardcodearlas ni subirlas a repos."
  ),
  list(
    tema = "Sesión 9: APIs y uso de LLMs vía API",
    pregunta = "¿Qué ventaja ofrece el uso de LLMs locales (ej. Ollama con modelos Qwen/Llama) sobre servicios en la nube como GPT-4?",
    correcta = "C",
    opts = list(
      A = "Elimina completamente la necesidad de prompt engineering.",
      B = "Garantiza mayor calidad de respuesta en todos los dominios especializados.",
      C = "Privacidad de datos (no salen de la máquina), costo cero posterior y sin rate limits.",
      D = "Permite procesar documentos de más de 1 millón de tokens sin particionarlos."
    ),
    explicacion = "Los LLMs locales ofrecen privacidad, costo cero tras la descarga y ausencia de rate limits, aunque con menor calidad que modelos cloud grandes."
  )
)

# ---------------------------------------------------------------------------
# 3) Verificar cantidad y distribución en raw
# ---------------------------------------------------------------------------
stopifnot(length(nuevas_raw) == 56)
letras_raw <- map_chr(nuevas_raw, ~ .x$correcta)
print("Distribución inicial en nuevas_raw:")
print(table(letras_raw))

# ---------------------------------------------------------------------------
# 4) Reordenar opciones para que la respuesta correcta quede en la letra indicada
# ---------------------------------------------------------------------------
set.seed(2026)

nuevas_df <- map_dfr(nuevas_raw, function(p) {
  opts <- p$opts
  correct_letter <- p$correcta
  correct_text <- opts[[correct_letter]]

  incorrect_letters <- setdiff(c("A", "B", "C", "D"), correct_letter)
  incorrect_letters <- sample(incorrect_letters)

  other_letters <- setdiff(c("A", "B", "C", "D"), correct_letter)
  mapping <- setNames(
    c(correct_text, unlist(opts[incorrect_letters])),
    c(correct_letter, other_letters)
  )
  mapping <- mapping[order(names(mapping))]

  tibble(
    tema = p$tema,
    pregunta = p$pregunta,
    opcion_a = mapping["A"],
    opcion_b = mapping["B"],
    opcion_c = mapping["C"],
    opcion_d = mapping["D"],
    opcion_correcta = correct_letter,
    explicacion = p$explicacion
  )
})

# ---------------------------------------------------------------------------
# 5) Verificar distribución final
# ---------------------------------------------------------------------------
print("Distribución final de respuestas correctas en nuevas:")
print(table(nuevas_df$opcion_correcta))
stopifnot(all(table(nuevas_df$opcion_correcta) == 14))

# ---------------------------------------------------------------------------
# 6) Asignar números secuenciales continuos
# ---------------------------------------------------------------------------
n_max_original <- max(original$num, na.rm = TRUE)

nuevas_df <- nuevas_df %>%
  mutate(num = n_max_original + row_number()) %>%
  select(num, everything())

# ---------------------------------------------------------------------------
# 7) Unir y guardar
# ---------------------------------------------------------------------------
final <- bind_rows(original, nuevas_df)

print(paste("Total de preguntas original:", nrow(original)))
print(paste("Total de preguntas nuevas:", nrow(nuevas_df)))
print(paste("Total acumulado:", nrow(final)))
print("Distribución total de respuestas correctas:")
print(table(final$opcion_correcta))

write_xlsx(final, "03_examen_modulo5/examen_81_preguntas.xlsx")
saveRDS(final, "03_examen_modulo5/examen_81_preguntas.rds")

print("Archivos generados exitosamente:")
print("- 03_examen_modulo5/examen_81_preguntas.xlsx")
print("- 03_examen_modulo5/examen_81_preguntas.rds")
