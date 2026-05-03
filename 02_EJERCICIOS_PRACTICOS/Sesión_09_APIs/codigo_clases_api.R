
# Librerias 

library(httr)
library(jsonlite)
library(tidyverse)

"https://pokeapi.co/api/v2/pokemon/{id or name}/"
  
llamada <- GET("https://pokeapi.co/api/v2/pokemon/pikachu/")
class(llamada)

get_data <- content(llamada, "text")
class(get_data)

get_data_from_JSON <- fromJSON(get_data, flatten = TRUE)
class(get_data_from_JSON)


get_data_from_JSON$height
get_data_from_JSON$weight

get_data_from_JSON$sprites$front_shiny_female

get_data_from_JSON$name

tabla_vacia <- tibble()

# i = 1
for(i in 1:151){

  llamada <- GET(str_c("https://pokeapi.co/api/v2/pokemon/", i,"/"))
  get_data <- content(llamada, "text")
  get_data_from_JSON <- fromJSON(get_data, flatten = TRUE)
  Sys.sleep(0.1)
  
  altura <- get_data_from_JSON$height
  peso <- get_data_from_JSON$weight
  nombre <- get_data_from_JSON$name
  
  resultado <- tibble(numero = i, nombre, altura, peso)
  tabla_vacia <- rbind(tabla_vacia, resultado)
  
  print(str_c("Listo el pokemon ", i))
  
}


clima_tec <- GET("https://api.open-meteo.com/v1/forecast?latitude=19.35&longitude=-99.25&hourly=temperature_2m&past_days=0&forecast_days=7")

# 19.35955424039645, -99.25724911505854

json_clima <- content(clima_tec, "text")
lista_clima <- fromJSON(json_clima, flatten = TRUE)

tiempo <- lista_clima$hourly$time
temperatura <- lista_clima$hourly$temperature_2m

tabla_clima <- cbind.data.frame(tiempo, temperatura) %>% 
  mutate(datos = "temperatura")

tabla_clima %>% 
  ggplot(aes(x = tiempo, y = temperatura, group = datos)) + 
  geom_line() + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5))



library(inegiR)

pib_estatal <- inegi_series(series_id = 746097, 
             token = Sys.getenv("INEGI_TOKEN_2"), 
             geography = "02", 
             database = "BIE-BISE", 
             as_tt = F)

claves_edos <- c(str_c("0", 1:9), 10:32)


datos_pib_estado <- lapply(claves_edos, function(i){
  
  dato <- inegi_series(series_id = 746097, 
               token = Sys.getenv("INEGI_TOKEN_2"), 
               geography = i, 
               database = "BIE-BISE", 
               as_tt = F) %>% 
    mutate(cve_edo = i)
  
  print(str_c("Ya está el estado: ", i))
  return(dato)
  
})

datos_pib_estado <- datos_pib_estado %>% do.call(rbind, .)

datos_pib_estado %>% 
  filter(date == max(date)) %>% 
  arrange(-values)


# usethis::edit_r_environ()


# ---- 1) Autenticación (OAuth) ----
# Crea credenciales OAuth 2.0 en Google Cloud (Desktop app)
# Credenciales cambiadas para que pongan las suyas
# if (file.exists(".httr-oauth")) unlink(".httr-oauth")
# Guarda tus credenciales en .Renviron (usethis::edit_r_environ()):
#   YT_OAUTH_APP_ID=xxxxxxxxxxxx.apps.googleusercontent.com
#   YT_OAUTH_APP_SECRET=xxxxxxxxxxxx
# Reinicia R después de editarlo.
library(tuber)
yt_oauth(app_id     = Sys.getenv("YOUTUBE_APP_ID"),
         app_secret = Sys.getenv("YOUTUBE_APP_SECRET"))

comentarios <- get_all_comments(video_id = "7iJJYG7MrpQ")
comentarios %>% as_tibble()


# Ejercicio 
library(ellmer)

chat_gpt <- ellmer::chat_openai(api_key = Sys.getenv("OPENAI_API_KEY"))

chat_gpt$chat("Hola, como estás?")




library(ellmer)

chat_local <- chat_ollama(
  system_prompt = "
    Eres un clasificador de discurso de odio y discurso violento.
    Respondes solo TRUE o FALSE si el texto es un texto de odio o violento.
  ",
  model = "qwen3.5:4b"
)

chat_local$chat("Me encantó el partido de ayer.")
# [1] "FALSE"

chat_local$chat("Ojalá se muera ese jugador.")
# [1] "TRUE"



