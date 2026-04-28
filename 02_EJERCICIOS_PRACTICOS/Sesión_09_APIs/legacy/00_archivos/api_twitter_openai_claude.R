
# ============================================================
# API de Twitter/X + API de OpenAI (ChatGPT) y Anthropic (Claude)
# ------------------------------------------------------------
# Objetivo: Descargar tweets recientes sobre un tema de interés
# y clasificar su polaridad (a FAVOR / en CONTRA / NEUTRAL) con
# dos LLMs distintos: ChatGPT (OpenAI) y Claude (Anthropic).
# Al final comparamos qué tanto coinciden los dos modelos.
# ============================================================

# ---- Paquetes ----
library(tidyverse)
library(httr)        # Llamadas al API de X/Twitter "a mano"
library(jsonlite)    # Parsear la respuesta JSON
library(ellmer)      # Wrapper uniforme para OpenAI y Claude
library(glue)        # Pegado de strings
library(janitor)     # Limpieza de nombres
library(openxlsx)    # Exportar a Excel

# ============================================================
# 1) Autenticación con el API de X (antes Twitter)
# ------------------------------------------------------------
# Desde 2023, el API de X ya no es gratuita como antes.
# Para obtener credenciales hay que:
#   1. Ir a https://developer.x.com/
#   2. Crear una cuenta de desarrollador (tier Free o Basic).
#   3. Crear una App dentro de un Proyecto.
#   4. Generar un "Bearer Token" (lo más fácil para lectura).
#
# El tier Free permite MUY pocas llamadas al mes (aprox. 100
# tweets de lectura al mes al momento de escribir esto), por
# lo que conviene probar el código con pocos tweets a la vez.
#
# NUNCA escribas tu Bearer Token directamente en el script.
# Guárdalo en tu .Renviron con:
#   usethis::edit_r_environ()
# y agrega una línea como:
#   X_BEARER_TOKEN=AAAAAAAAAAAAAAAAAAAAA....
# Reinicia R y recupéralo con Sys.getenv("X_BEARER_TOKEN").
# ============================================================

# usethis::edit_r_environ()  # <- descomenta la primera vez
# usethis::edit_r_environ()

bearer_token <- Sys.getenv("X_BEARER_TOKEN")

# Validación básica de que la credencial fue cargada
stopifnot(nchar(bearer_token) > 0)

# ============================================================
# 2) Función para buscar tweets recientes
# ------------------------------------------------------------
# Endpoint: GET /2/tweets/search/recent
# Documentación: https://developer.x.com/en/docs/x-api/tweets/search/api-reference/get-tweets-search-recent
# Este endpoint regresa tweets de los últimos 7 días.
# ============================================================

# Primero lo hacemos "a mano" una sola vez para entender la estructura
# (como hicimos con la PokeAPI en la sesión pasada).

consulta  <- "infonavit"  # Texto a buscar
url_base  <- "https://api.x.com/2/tweets/search/recent"

respuesta <- GET(
  url   = url_base,
  query = list(
    query         = consulta,
    max_results   = 20,                          # entre 10 y 100
    `tweet.fields`= "created_at,lang,public_metrics,author_id"
  ),
  add_headers(Authorization = glue("Bearer {bearer_token}"))
)

# Revisamos el status
respuesta$status_code   # 200 significa que todo salió bien

# Extraemos el contenido como texto y lo convertimos a lista
contenido <- content(respuesta, as = "text", encoding = "UTF-8")
json      <- fromJSON(contenido, flatten = TRUE)

# Estructura del JSON:
#   json$data      -> tabla con los tweets
#   json$meta      -> metadata de la consulta (newest_id, result_count, etc.)
str(json, max.level = 2)

# Lo convertimos a un tibble listo para trabajar
tweets <- as_tibble(json$data) %>%
  clean_names() %>%
  mutate(created_at = as_datetime(created_at))

tweets

# ============================================================
# 3) Empaquetamos la descarga en una función reutilizable
# ------------------------------------------------------------
# Así podemos cambiar fácil la consulta y la cantidad de
# tweets sin repetir código.
# ============================================================

buscar_tweets <- function(consulta, n = 50, token = bearer_token) {

  # El API limita max_results a 100 por llamada
  r <- GET(
    url   = "https://api.x.com/2/tweets/search/recent",
    query = list(
      query          = consulta,
      max_results    = min(n, 100),
      `tweet.fields` = "created_at,lang,public_metrics,author_id"
    ),
    add_headers(Authorization = glue("Bearer {token}"))
  )

  # Validamos que la llamada haya sido exitosa
  if (r$status_code != 200) {
    stop(glue("Error {r$status_code}: {content(r, 'text', encoding='UTF-8')}"))
  }

  json <- fromJSON(content(r, "text", encoding = "UTF-8"), flatten = TRUE)

  as_tibble(json$data) %>%
    clean_names() %>%
    mutate(created_at = as_datetime(created_at))
}

# Descargamos 50 tweets sobre el mismo tema del ejercicio de YouTube
tweets <- buscar_tweets('"chicharito" -is:retweet lang:es', n = 50)
tweets

# Guardamos por si acaso (las llamadas cuestan cuota mensual)
saveRDS(tweets, "tweets_chicharito.rds")
# tweets <- readRDS("tweets_chicharito.rds")  # para retomar sin volver a pagar cuota

# ============================================================
# 4) Clasificación con los LLMs usando ellmer
# ------------------------------------------------------------
# ellmer da una interfaz uniforme para varios proveedores.
# Vamos a crear dos "chats" (uno de OpenAI y uno de Claude)
# y clasificar los mismos tweets con ambos para comparar.
# ============================================================

# Guarda tus llaves en el .Renviron (NO las escribas en el script):
#   OPENAI_API_KEY=sk-proj-....
#   ANTHROPIC_API_KEY=sk-ant-....
# Reinicia R después de editarlo.

chat_gpt <- chat_openai(
  model      = "gpt-4o-mini",                        # más barato que gpt-4o
  api_key    = Sys.getenv("OPENAI_API_KEY"),
  system_prompt = "Eres un clasificador estricto de texto en español."
)

chat_claude <- chat_anthropic(
  model      = "claude-haiku-4-5",                   # rápido y económico
  api_key    = Sys.getenv("ANTHROPIC_API_KEY"),
  system_prompt = "Eres un clasificador estricto de texto en español."
)

# Prueba rápida de que ambos responden
chat_gpt$chat("Responde SOLO con la palabra 'ok'.")
chat_claude$chat("Responde SOLO con la palabra 'ok'.")

# ============================================================
# 5) Prompt de clasificación
# ------------------------------------------------------------
# Igual que en el ejercicio de YouTube, probamos primero con
# UN tweet (el "caso n = 1") antes de armar el loop.
# ============================================================

prompt_clasificador <- function(texto_tweet) {
  glue(
    "Clasifica el siguiente tweet sobre el futbolista 'Chicharito' Hernández ",
    "en una de estas tres categorías, devolviendo SOLO la etiqueta, sin explicación:\n",
    " - FAVOR     (defiende o apoya a Chicharito)\n",
    " - CONTRA    (critica o se burla de Chicharito)\n",
    " - NEUTRAL   (no se puede determinar, es informativo o no trata del tema)\n\n",
    "Tweet: <<{texto_tweet}>>"
  )
}

# Probamos con el primer tweet (caso n = 1)
i <- tweets$text[1]
prompt_clasificador(i)
chat_gpt$chat(prompt_clasificador(i))
chat_claude$chat(prompt_clasificador(i))

# ============================================================
# 6) Clasificamos todos los tweets con ambos modelos
# ------------------------------------------------------------
# Usamos lapply porque necesitamos mantener el orden original.
# Recuerda de la sesión 11: lapply recorre el vector y nos
# devuelve una lista con el resultado por elemento.
# ============================================================

# ChatGPT
respuestas_gpt <- lapply(tweets$text, function(t) {
  chat_gpt$chat(prompt_clasificador(t))
})

# Claude
respuestas_claude <- lapply(tweets$text, function(t) {
  chat_claude$chat(prompt_clasificador(t))
})

# Aproximadamente, 50 tweets con gpt-4o-mini y claude-haiku-4-5
# cuestan centavos de dolar. Para lotes grandes (>1000) conviene
# revisar antes la calculadora de precios de cada proveedor.

# ============================================================
# 7) Armamos la tabla final y limpiamos las respuestas
# ------------------------------------------------------------
# Los LLMs a veces agregan espacios o puntuación. Forzamos a
# mayúsculas y nos quedamos con una de las tres etiquetas.
# ============================================================

limpiar_etiqueta <- function(x) {
  x <- toupper(as.character(x))
  case_when(
    str_detect(x, "FAVOR")   ~ "FAVOR",
    str_detect(x, "CONTRA")  ~ "CONTRA",
    str_detect(x, "NEUTRAL") ~ "NEUTRAL",
    TRUE                     ~ "NO_CLASIFICA"
  )
}

tweets_clasificados <- tweets %>%
  select(id, created_at, text) %>%
  mutate(
    clasif_gpt    = map_chr(respuestas_gpt,    limpiar_etiqueta),
    clasif_claude = map_chr(respuestas_claude, limpiar_etiqueta)
  )

tweets_clasificados

# Guardamos a Excel
write.xlsx(tweets_clasificados, "tweets_chicharito_clasificados.xlsx")

# ============================================================
# 8) Comparación entre modelos
# ------------------------------------------------------------
# ¿Qué tanto coinciden ChatGPT y Claude entre sí?
# Una forma rápida: tabla cruzada + porcentaje de acuerdo.
# ============================================================

# Tabla cruzada
tabla_cruzada <- tweets_clasificados %>%
  count(clasif_gpt, clasif_claude) %>%
  pivot_wider(names_from = clasif_claude, values_from = n, values_fill = 0)

tabla_cruzada

# Porcentaje de acuerdo
porcentaje_acuerdo <- tweets_clasificados %>%
  summarise(acuerdo = mean(clasif_gpt == clasif_claude)) %>%
  pull(acuerdo)

print(glue("GPT y Claude coinciden en el {round(100 * porcentaje_acuerdo, 1)}% de los tweets"))

# ============================================================
# 9) Gráfica comparativa
# ------------------------------------------------------------
# Barras lado a lado con la clasificación de cada modelo.
# ============================================================

tweets_clasificados %>%
  select(clasif_gpt, clasif_claude) %>%
  pivot_longer(everything(), names_to = "modelo", values_to = "clasificacion") %>%
  mutate(
    modelo = recode(modelo,
                    clasif_gpt    = "ChatGPT (gpt-4o-mini)",
                    clasif_claude = "Claude (haiku-4-5)")
  ) %>%
  count(modelo, clasificacion) %>%
  ggplot(aes(x = clasificacion, y = n, fill = clasificacion)) +
  geom_col() +
  geom_text(aes(label = n), vjust = -0.4, fontface = "bold") +
  facet_wrap(~ modelo) +
  scale_fill_manual(
    values = c(FAVOR        = "olivedrab",
               CONTRA       = "brown",
               NEUTRAL      = "gray60",
               NO_CLASIFICA = "navy")
  ) +
  scale_y_continuous(expand = expansion(c(0, 0.2))) +
  labs(
    title    = "Clasificación de tweets sobre 'Chicharito'",
    subtitle = glue("Comparación ChatGPT vs Claude (N = {nrow(tweets_clasificados)})"),
    x        = "Clasificación",
    y        = "Total de tweets",
    fill     = "Clasificación",
    caption  = "Fuente: API de X (búsqueda reciente) + APIs de OpenAI y Anthropic vía ellmer."
  ) +
  theme_minimal() +
  theme(legend.position = "bottom")

# ============================================================
# 10) Actividad propuesta para los alumnos
# ------------------------------------------------------------
# a) Cambien la consulta a un tema de su interés (política,
#    una serie de Netflix, un equipo de futbol, etc.) y
#    descarguen 100 tweets.
# b) Modifiquen el prompt_clasificador para que detecte
#    "emoción principal" (alegría/enojo/tristeza/neutral).
# c) Respondan: ¿cuál de los dos modelos fue más estricto con
#    la etiqueta NEUTRAL? ¿Por qué creen que sucede?
# d) Extra: agreguen un tercer modelo (Gemini) con
#    chat_google_gemini() y hagan un "ensemble" por mayoría.
# ============================================================
