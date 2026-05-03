# ============================================================================
# Generación del banco de 25 preguntas - Examen Módulo 5 (IA)
# Curso: EC3002C.601 - Módulo 5: Inteligencia Artificial
# Tec de Monterrey, ene-jun 2026
# Profesor: Jorge Juvenal Campos Ferreira
# ============================================================================
#
# Este script construye el archivo examen_25_preguntas.xlsx (legible por
# humanos) y examen_25_preguntas.rds (consumido por la app Shiny).
#
# Cubre las 9 sesiones del módulo. Distribución por sesión:
#   Sesión 1 (Intro IA + LLMs):           3 preguntas
#   Sesión 2 (Vibe Coding + RStudio):     3 preguntas
#   Sesión 3 (Tidyverse):                 3 preguntas
#   Sesión 4 (ggplot2):                   3 preguntas
#   Sesión 5 (Mapas):                     3 preguntas
#   Sesión 6 (ENIGH):                     3 preguntas
#   Sesión 7 (ENOE):                      2 preguntas
#   Sesión 8 (Ingesta de datos):          3 preguntas
#   Sesión 9 (APIs y LLMs):               2 preguntas
#
# Las opciones correctas están balanceadas para evitar que adivinar una
# misma letra dé una calificación aprobatoria (~6 correctas por letra).
# ============================================================================

library(tidyverse)
library(openxlsx)

banco <- tribble(
  ~num, ~tema, ~pregunta, ~opcion_a, ~opcion_b, ~opcion_c, ~opcion_d, ~opcion_correcta, ~explicacion,

  # ----- Sesión 1: Introducción a la IA y LLMs (3) -----
  1, "Sesión 1: Introducción a la IA",
  "Según los principios éticos del Tec de Monterrey para el uso de IA, ¿cuál de las siguientes afirmaciones es correcta respecto a los errores que comete una herramienta de IA usada por tu equipo?",
  "Son responsabilidad exclusiva del proveedor del modelo (OpenAI, Anthropic, etc.).",
  "No cuentan como error académico mientras se declare que se usó IA.",
  "Son tus errores y los de tu equipo, con consecuencias para todos los integrantes.",
  "Solo son tu responsabilidad si tú personalmente generaste el prompt.",
  "C",
  "El profesor enfatiza la regla 'la IA no es excusa': los errores de la IA que tú o alguien de tu equipo usen son tus errores. Declarar el uso de IA no exime de responsabilidad.",

  2, "Sesión 1: Introducción a la IA",
  "En el flujo de funcionamiento de un LLM, ¿qué proceso convierte el texto de entrada en números que el modelo puede procesar?",
  "Embedding semántico final",
  "Backpropagation",
  "Fine-tuning",
  "Tokenización",
  "D",
  "El primer paso del flujo de un LLM es la tokenización: el texto se divide en tokens (palabras, sílabas o letras) y se convierten en números. Los embeddings y la atención vienen después en el procesamiento.",

  3, "Sesión 1: Introducción a la IA",
  "Según la nemotecnia 'TaCoLiRo' presentada en clase para construir buenos prompts, ¿cuáles son sus cuatro ingredientes mínimos?",
  "Tarea, Contexto, Lenguaje, Resultado",
  "Tema, Comando, Lista, Respuesta",
  "Tarea, Contexto, Límites, Rol",
  "Texto, Código, Lógica, Razonamiento",
  "C",
  "TaCoLiRo es la nemotecnia para los cuatro ingredientes mínimos de un buen prompt: Tarea (qué hacer), Contexto (información previa), Límites (qué incluir/excluir) y Rol (qué papel debe asumir el modelo).",

  # ----- Sesión 2: Vibe Coding + RStudio (3) -----
  4, "Sesión 2: Vibe Coding y RStudio",
  "El término 'Vibe Coding' fue acuñado por Andrej Karpathy en febrero de 2025. ¿Qué describe principalmente?",
  "Un estilo de programación donde se describe lo que se quiere en lenguaje natural y la IA escribe el código.",
  "Una metodología ágil para gestionar equipos de desarrollo en startups de IA.",
  "Una técnica para escribir código optimizado en GPU usando CUDA.",
  "Un patrón de diseño orientado a objetos para sistemas distribuidos.",
  "A",
  "Vibe Coding (Karpathy, feb 2025) describe el flujo de trabajo donde el programador describe la intención en lenguaje natural y la IA genera el código, dejando al humano el rol de validar resultados más que de teclear sintaxis.",

  5, "Sesión 2: Vibe Coding y RStudio",
  "En RStudio, ¿en cuál de las cuatro ventanas se muestra el resultado de ejecutar una línea de código de R?",
  "Console",
  "Editor",
  "Environment",
  "Viewer",
  "A",
  "La Console (Consola) es donde se ejecutan los comandos y aparecen los resultados textuales. El Editor es para escribir scripts, Environment muestra los objetos creados, y Viewer muestra gráficos y HTML.",

  6, "Sesión 2: Vibe Coding y RStudio",
  "En R, ¿cuál es la diferencia clave entre install.packages() y library()?",
  "install.packages() solo se usa una vez por paquete; library() debe ejecutarse en cada sesión.",
  "library() solo se usa una vez por paquete; install.packages() se ejecuta en cada sesión.",
  "Son sinónimos: cualquiera de las dos descarga y carga el paquete.",
  "install.packages() es para CRAN y library() es para GitHub.",
  "A",
  "install.packages() descarga e instala el paquete en la computadora — basta con hacerlo una vez. library() carga el paquete en la sesión actual y debe ejecutarse cada vez que abres R y quieres usar ese paquete.",

  # ----- Sesión 3: Tidyverse (3) -----
  7, "Sesión 3: Tidyverse",
  "¿Cuál de las siguientes funciones del tidyverse se utiliza para CREAR o MODIFICAR columnas en un data frame, manteniendo todas las filas?",
  "filter()",
  "select()",
  "mutate()",
  "summarise()",
  "C",
  "mutate() crea o modifica columnas conservando todas las filas. filter() elige filas, select() elige columnas existentes, y summarise() colapsa el data frame a una sola fila por grupo (o una sola fila total).",

  8, "Sesión 3: Tidyverse",
  "Si quieres unir dos tablas conservando TODAS las filas de la tabla de la izquierda y agregando información de la derecha cuando exista coincidencia, ¿qué función usas?",
  "inner_join()",
  "right_join()",
  "full_join()",
  "left_join()",
  "D",
  "left_join(x, y) conserva todas las filas de x y agrega columnas de y donde haya coincidencia (NA donde no la haya). inner_join solo conserva coincidencias, right_join al revés, y full_join conserva todas las filas de ambas.",

  9, "Sesión 3: Tidyverse",
  "El operador pipe %>% (magrittr) se lee informalmente como 'y después'. ¿Cuál de las siguientes expresiones es EQUIVALENTE a mean(filter(datos, edad > 18)$ingreso)?",
  "datos %>% filter(edad > 18) %>% pull(ingreso) %>% mean()",
  "datos %>% mean(ingreso) %>% filter(edad > 18)",
  "datos %>% summarise(edad > 18) %>% mean(ingreso)",
  "datos %>% group_by(edad > 18) %>% mean(ingreso)",
  "A",
  "El pipe pasa el resultado de la izquierda como primer argumento a la función de la derecha. La forma legible es: tomar datos, después filtrar por edad > 18, después extraer la columna ingreso, después calcular su media.",

  # ----- Sesión 4: ggplot2 (3) -----
  10, "Sesión 4: ggplot2",
  "En ggplot2, ¿con qué operador se agregan capas (geoms, escalas, temas) a un gráfico?",
  "%>% (pipe de magrittr)",
  "|> (pipe nativo)",
  ", (coma como separador de argumentos)",
  "+ (signo de suma)",
  "D",
  "ggplot2 fue diseñado antes de la popularización del pipe y usa + para sumar capas. Aunque los datos pueden llegar al ggplot vía %>%, dentro del gráfico las capas se concatenan con +.",

  11, "Sesión 4: ggplot2",
  "El cuarteto de Anscombe presentado al inicio de la sesión muestra cuatro datasets con la misma media, varianza y correlación. ¿Cuál es la lección principal?",
  "La correlación r ≈ 0.816 es un umbral universal de relación fuerte.",
  "Las regresiones lineales son siempre el mejor modelo para datos bivariados.",
  "Antes de modelar siempre hay que graficar los datos, porque las estadísticas descriptivas pueden ocultar patrones muy distintos.",
  "Los outliers deben removerse antes de calcular cualquier estadística descriptiva.",
  "C",
  "Anscombe muestra cuatro datasets idénticos en estadísticas descriptivas y recta de regresión, pero visualmente muy distintos (lineal, curvo, con outlier, etc.). La lección es: 'trata de graficar tus datos antes de modelar'.",

  12, "Sesión 4: ggplot2",
  "Dentro de aes() de ggplot2, ¿qué diferencia hay entre escribir color = \"blue\" y color = variable_x?",
  "Ninguna: ambas pintan los puntos de azul.",
  "color = \"blue\" sólo funciona en geom_line(); color = variable_x sólo en geom_point().",
  "Ambas mapean a una variable, pero \"blue\" es interpretado como un factor con un solo nivel.",
  "color = \"blue\" pinta todos los puntos de azul; color = variable_x mapea el color a los valores de variable_x y genera leyenda.",
  "D",
  "Dentro de aes(), los valores se interpretan como mapeos a variables. Para asignar un color FIJO se debe escribir fuera de aes(), por ejemplo geom_point(color = \"blue\"). Si se pone \"blue\" dentro de aes() ggplot lo trata como una constante categórica y genera una leyenda innecesaria.",

  # ----- Sesión 5: Mapas e información geográfica (3) -----
  13, "Sesión 5: Mapas e información geográfica",
  "En la cartografía digital, ¿qué archivos componen un shapefile completo?",
  ".shp (geometría), .dbf (atributos), .shx (índice) y .prj (proyección), entre otros.",
  "Sólo el archivo .shp con la geometría.",
  "Un único archivo .geojson que incluye geometría y atributos.",
  ".kml comprimido junto con .csv de atributos.",
  "A",
  "Un shapefile NO es un solo archivo: requiere mínimo .shp (geometría), .dbf (base de atributos), .shx (índice) y .prj (proyección cartográfica). Si se borra alguno, el shapefile puede dejar de cargar correctamente.",

  14, "Sesión 5: Mapas e información geográfica",
  "Las claves geoestadísticas del INEGI (CVEGEO, CVE_ENT, CVE_MUN) son fundamentales en el análisis geográfico porque:",
  "Determinan la proyección cartográfica que debe usarse para cada estado.",
  "Indican el código postal de cada AGEB para envíos de la encuesta INEGI.",
  "Codifican el partido político gobernante en cada municipio.",
  "Funcionan como ID de polígono y permiten unir bases atributivas con bases geográficas vía joins.",
  "D",
  "Las claves geoestadísticas funcionan como el ID único de cada polígono (estado, municipio, AGEB, manzana). Su uso principal es como variable 'llave' para hacer left_join entre tablas con datos atributivos y tablas con geometrías.",

  15, "Sesión 5: Mapas e información geográfica",
  "¿Cuál sistema de coordenadas de referencia (CRS) se usó como default en la clase y es el más común en librerías como leaflet y Google Maps?",
  "EPSG:6372 (proyección INEGI)",
  "EPSG:2163 (US National Atlas)",
  "EPSG:4326 (WGS84, lat/long)",
  "EPSG:6362 (UTM zona 14N)",
  "C",
  "EPSG:4326 (WGS84 con proyección lat/long) es el CRS más común y el que usan por default leaflet y Google Maps. Los otros son útiles en contextos específicos: 6372 para datos INEGI, 2163 para EE.UU., 6362 para metros en CDMX.",

  # ----- Sesión 6: ENIGH (3) -----
  16, "Sesión 6: ENIGH",
  "¿Qué significan las siglas ENIGH y cuál es su unidad de análisis principal?",
  "Encuesta Nacional de Ingresos y Gastos de los Hogares; el hogar.",
  "Encuesta Nacional de Indicadores Globales del Hogar; persona individual.",
  "Estudio Nacional de Información Geográfica Hospitalaria; vivienda.",
  "Encuesta Nacional Integral de Gobierno y Hacienda; municipio.",
  "A",
  "ENIGH = Encuesta Nacional de Ingresos y Gastos de los Hogares. La levanta INEGI cada dos años y su unidad de análisis es el HOGAR (no la persona ni la vivienda), entendido como el conjunto de personas que comparten una vivienda y destinan recursos a sus necesidades.",

  17, "Sesión 6: ENIGH",
  "Si a un hogar de la ENIGH se le asigna un factor de expansión de 350, ¿qué significa?",
  "El hogar respondió 350 preguntas del cuestionario.",
  "El hogar pertenece al estrato muestral número 350.",
  "El ingreso mensual del hogar debe multiplicarse por 350 para obtener su valor anual.",
  "Las respuestas de ese hogar representan a 350 hogares similares en la población total.",
  "D",
  "El factor de expansión indica a cuántos hogares de la población equivale cada hogar encuestado. Como no se entrevista a los 35 millones de hogares de México, cada hogar de la muestra representa a cientos de hogares reales con características similares.",

  18, "Sesión 6: ENIGH",
  "En R, para calcular medias y totales de la ENIGH respetando el diseño muestral, ¿qué librería y patrón se usa?",
  "dplyr con summarise(mean(variable)) directamente.",
  "srvyr con as_survey_design(ids = upm, strata = est_dis, weights = factor) seguido de survey_mean().",
  "ggplot2 con stat_summary(fun = \"mean\").",
  "data.table con .SD[, mean(variable)].",
  "B",
  "srvyr es la librería tidyverse para encuestas con diseño muestral. Se declara el diseño con as_survey_design() pasando UPM (cluster), estrato y pesos, y luego se calculan estadísticos ponderados con survey_mean(), survey_total(), survey_quantile(), etc.",

  # ----- Sesión 7: ENOE (2) -----
  19, "Sesión 7: ENOE",
  "¿Cuál es la diferencia clave entre ENOE y ENIGH en términos de su diseño temporal?",
  "Ambas son corte transversal levantado una vez al año.",
  "ENOE es trimestral con panel rotativo (5 visitas a cada vivienda); ENIGH es bienal y de corte transversal.",
  "ENIGH es trimestral; ENOE se levanta cada 5 años junto al censo.",
  "Ambas usan panel rotativo pero ENOE rota cada año y ENIGH cada mes.",
  "B",
  "La ENOE se levanta cada trimestre y usa un panel rotativo donde cada vivienda es visitada hasta 5 trimestres consecutivos (rotando el 20% cada vez). La ENIGH se levanta cada 2 años en corte transversal (una sola visita por hogar).",

  20, "Sesión 7: ENOE",
  "En la clasificación de la ENOE basada en recomendaciones de la OIT, ¿en qué categoría cae una persona de 30 años que NO tiene empleo pero que SÍ está buscando trabajo activamente?",
  "Población No Económicamente Activa, disponible.",
  "Población Ocupada en condiciones críticas.",
  "Población Económicamente Activa, desocupada.",
  "Población No Económicamente Activa, no disponible.",
  "C",
  "La PEA se compone de ocupados (con empleo) y desocupados (sin empleo pero buscándolo activamente). Una persona que no tiene empleo pero lo busca activamente es Desocupada dentro de la PEA. Si no buscara, sería PNEA.",

  # ----- Sesión 8: Ingesta de datos (3) -----
  21, "Sesión 8: Ingesta de datos",
  "Según la Open Knowledge Foundation, ¿cuál de las siguientes NO es una condición necesaria para que un dataset se considere de 'datos abiertos'?",
  "Disponibles y de fácil acceso (preferentemente desde internet).",
  "Reutilizables y redistribuibles bajo licencia que lo permita.",
  "Facilitan la participación universal sin discriminación.",
  "Verificados y validados por una autoridad gubernamental certificada.",
  "D",
  "Las tres condiciones de la Open Knowledge Foundation son: (1) disponibles y de fácil acceso, (2) reutilizables y redistribuibles, (3) facilitan la participación universal. La validación por autoridad gubernamental NO es requisito para que sean abiertos.",

  22, "Sesión 8: Ingesta de datos",
  "Para descargar programáticamente un archivo .xlsx desde una URL en R, ¿qué función es la más adecuada según la clase?",
  "rvest::read_html()",
  "curl::curl_download(url, destfile)",
  "openxlsx::write.xlsx()",
  "httr::POST()",
  "B",
  "curl::curl_download() es la función para bajar archivos de internet (.zip, .xlsx, etc.), recibiendo la URL y el destfile. read_html es para HTML, write.xlsx es para escribir Excel locales, y POST se usa para enviar datos a un servidor.",

  23, "Sesión 8: Ingesta de datos",
  "En la receta del profesor para construir un loop con for, ¿cuál es el segundo paso recomendado después de definir qué se quiere hacer?",
  "Construir el for con la sintaxis completa antes de probarlo.",
  "Hacerlo para un caso individual (n=1) primero, sin el loop.",
  "Crear una función auxiliar para encapsular el proceso.",
  "Definir el vector de salida con length() exacto desde el inicio.",
  "B",
  "La receta es: (1) define qué quieres hacer y qué resultado esperar, (2) hazlo para UN caso individual (n=1), (3) identifica las partes variables, (4) cámbialas por objetos de R, (5) construye el for. Probar primero con un caso ahorra mucho debugging.",

  # ----- Sesión 9: APIs y LLMs (2) -----
  24, "Sesión 9: APIs y LLMs",
  "En la conexión directa con una API REST usando httr y jsonlite, ¿cuál es el orden CORRECTO de los pasos?",
  "fromJSON() → GET() → content() → construir URL.",
  "Construir URL → GET() → content(., \"text\") → fromJSON().",
  "POST() → fromJSON() → content() → GET().",
  "library(ellmer) → chat_openai() → $chat() → save.",
  "B",
  "El flujo en cuatro pasos es: (1) construir la URL de la petición según la documentación, (2) httr::GET() para hacer la solicitud, (3) httr::content(., \"text\") para extraer el JSON crudo, (4) jsonlite::fromJSON() para convertirlo en lista de R navegable.",

  25, "Sesión 9: APIs y LLMs",
  "¿Cuál es la práctica RECOMENDADA en la clase para manejar tokens y API keys en proyectos de R?",
  "Pegarlos directamente en el script y subirlos al repositorio para que el equipo pueda colaborar.",
  "Guardarlos en un archivo .Renviron (editable con usethis::edit_r_environ()) y leerlos con Sys.getenv().",
  "Compartirlos por chat con los compañeros para evitar duplicar registros.",
  "Reutilizar tokens de servicios públicos encontrados en otros repositorios de GitHub.",
  "B",
  "Las API keys nunca deben subirse al repositorio. La práctica correcta es guardarlas en .Renviron (con usethis::edit_r_environ()), agregar el archivo al .gitignore, y leerlas en el código con Sys.getenv(\"NOMBRE_DEL_TOKEN\")."
)

# Validación
stopifnot(nrow(banco) == 25)
stopifnot(all(banco$opcion_correcta %in% c("A", "B", "C", "D")))

# Verificación de balance — ninguna letra debe sumar más del 35% (8 preguntas)
balance <- table(banco$opcion_correcta)
if (max(balance) > 8) {
  warning("Distribución de respuestas correctas desbalanceada: ", paste(names(balance), balance, sep="=", collapse=", "))
}

# Guardar Excel (legible para humanos)
openxlsx::write.xlsx(banco, "examen_25_preguntas.xlsx")

# Guardar RDS (consumido por la app Shiny)
saveRDS(banco, "examen_25_preguntas.rds")

cat("Banco generado: 25 preguntas\n\n")
cat("Distribución de respuestas correctas (A/B/C/D):\n")
print(balance)
cat("\nDistribución por sesión:\n")
print(table(banco$tema))
