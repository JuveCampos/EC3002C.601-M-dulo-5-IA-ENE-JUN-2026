# Sesión 09 — APIs y uso de LLMs vía API

## Programa de la clase
APIs como tercera fuente de datos: definición, etiqueta de uso, dos formas de consumirlas en R (clientes vs `httr` directo), formato JSON, y uso de LLMs (OpenAI, Ollama local) vía la librería `ellmer`.

## Librerías a descargar

```r
library(httr)
library(jsonlite)
library(inegiR)
library(tidyquant)
library(tuber)
library(ellmer)   # cliente para LLMs
```

> Adicionalmente: descargar **Ollama** y los modelos **Qwen** y **Llama** para correr LLMs localmente.

## ¿Qué es una API?

**API** = *Application Programming Interface* (Interfaz de Programación de Aplicaciones).

Las APIs son **componentes del servidor** que **hacen fácil que nuestro código interactúe con un servicio y obtenga datos de él**.

> Las APIs son como **páginas web, pero para máquinas**: en vez de devolver HTML renderizado, devuelven datos estructurados (JSON o XML).

### Arquitectura típica (REST API)

```
Cliente  ──GET / POST / PUT / DELETE──>  REST API  ──>  Database
   ^                                        |
   └─────── JSON / XML ─────────────────────┘
```

### Para qué sirven en R
- Importar grandes cantidades de datos de manera **automática**.
- Hacer **búsquedas para pedazos específicos** de datos dentro de un universo grande.

## Dos formas de usar APIs en R

| Forma | Cuándo |
|---|---|
| **Con `{httr}`** (manera tradicional) | Cuando NO existe un cliente específico — hay que armar la petición manualmente |
| **A través de API Clients** (librerías específicas) | **Siempre que sea posible** — más fácil |

### Ejemplos de API clients en R
- `{spotifyr}` (Spotify), `{rtweet}` (Twitter/X), `{tuber}` (YouTube), `{pageviews}` (Wikipedia), `{inegiR}` (INEGI), `{tidyquant}` (datos financieros).

### Ventajas de los clientes
- Son **interfaces nativas** para acceder a las APIs con código y funciones de R (como cualquier librería).
- **Ocultan completamente la API**: nos permite acceder solo a los **resultados estructurados**.
- Nos permiten leer los datos **a través de objetos de R**, en vez de lidiar con archivos JSON crudos.

## Etiqueta al usar APIs

1. **Registro previo**: muchas APIs lo exigen para controlar acceso y uso moderado.
2. **Tokens**: tras el registro nos dan tokens de acceso para controlar consumo. **Estas llaves muchas veces van incluidas en nuestro código**.
   - **Buena práctica**: guardarlas en `.Renviron` con `usethis::edit_r_environ()` y leerlas con `Sys.getenv("MI_TOKEN")` — **nunca** subirlas al repo público.
3. **No sobrecargar**: solicitudes excesivas reducen la calidad del servicio para todos. Usar `Sys.sleep()`.
4. **Rate limits**: muchas APIs regulan el consumo permitiendo un número de consultas por unidad de tiempo.
5. **Costo**: a veces las APIs cuestan (parte del negocio de las empresas).
6. **Documentación**: leer la guía de uso antes de empezar.

## Llamadas HTTP

Una llamada HTTP es una **conversación entre tu máquina y el servidor**. Tipos (métodos):

| Método | Uso |
|---|---|
| **GET** | "get me something" — obtener datos. **El más usado** en consumo de datos. |
| **POST** | "have something of mine" — enviar datos al servidor. |
| HEAD | Solo cabeceras, similar a `head()`. |
| DELETE | Eliminar un recurso. |

## Conexión directa con `httr` + `jsonlite` (4 pasos)

### Paso 0 — Construir la petición según la documentación

Ejemplo con PokeAPI: la URL base es `https://pokeapi.co/api/v2/pokemon/{id|name}/`.

### Paso 1 — Construir la URL (parte constante + parte variable)

```r
call1 <- paste0("https://pokeapi.co/api/v2/", "pokemon/pikachu/")
```

### Paso 2 — Hacer la GET request

```r
llamada <- httr::GET(call1)
llamada                    # Status 200 = todo ok
class(llamada)             # "response"
```

### Paso 3 — Acceder al contenido

```r
get_data <- httr::content(llamada, "text")    # devuelve JSON crudo (texto)
class(get_data)                                # "character"
```

### Paso 4 — Convertir el JSON en lista de R

```r
get_data_from_JSON <- jsonlite::fromJSON(get_data, flatten = TRUE)
class(get_data_from_JSON)   # "list"

get_data_from_JSON$name      # "pikachu"
get_data_from_JSON$height
get_data_from_JSON$weight
```

## Loop sobre múltiples llamadas (151 Pokémon)

```r
tabla_vacia <- tibble()

for (i in 1:151) {
  llamada <- GET(str_c("https://pokeapi.co/api/v2/pokemon/", i, "/"))
  get_data <- content(llamada, "text")
  get_data_from_JSON <- fromJSON(get_data, flatten = TRUE)
  Sys.sleep(0.1)   # ¡etiqueta! pausa entre llamadas

  resultado <- tibble(numero = i,
                      nombre = get_data_from_JSON$name,
                      altura = get_data_from_JSON$height,
                      peso   = get_data_from_JSON$weight)
  tabla_vacia <- rbind(tabla_vacia, resultado)
  print(str_c("Listo el pokemon ", i))
}
```

## Formato JSON

**JSON** (JavaScript Object Notation): formato de texto basado en **pares clave-valor** y arreglos. Es el formato estándar de respuesta de la mayoría de APIs.

```json
{
  "users": [
    {"userId": 1, "firstName": "Chris", "lastName": "Lee"},
    {"userId": 2, "firstName": "Action", "lastName": "Jackson"}
  ]
}
```

Estructura jerárquica anidada → en R se mapea a una **lista** (donde cada casilla puede contener cualquier tipo: vectores, dataframes, otras listas).

## Otras APIs vistas en clase

### Open-Meteo (clima)
```r
clima_tec <- GET("https://api.open-meteo.com/v1/forecast?latitude=19.35&longitude=-99.25&hourly=temperature_2m&past_days=0&forecast_days=7")
json_clima <- content(clima_tec, "text")
lista_clima <- fromJSON(json_clima, flatten = TRUE)

tabla_clima <- cbind.data.frame(tiempo = lista_clima$hourly$time,
                                temperatura = lista_clima$hourly$temperature_2m)
```

### `inegiR` — Cliente para INEGI BIE-BISE
```r
pib_estatal <- inegi_series(series_id = 746097,
                            token     = Sys.getenv("INEGI_TOKEN"),
                            geography = "02",
                            database  = "BIE-BISE")
```

Loop con `lapply()` para descargar los 32 estados:
```r
claves_edos <- c(str_c("0", 1:9), 10:32)
datos_pib_estado <- lapply(claves_edos, function(i) {
  inegi_series(series_id = 746097, token = Sys.getenv("INEGI_TOKEN"),
               geography = i, database = "BIE-BISE") %>%
    mutate(cve_edo = i)
}) %>%
  do.call(rbind, .)
```

### `tuber` — YouTube (con OAuth 2.0)

Requiere registro de credenciales OAuth en Google Cloud (Desktop app). Se guardan en `.Renviron`:
```
YT_OAUTH_APP_ID=xxx.apps.googleusercontent.com
YT_OAUTH_APP_SECRET=xxx
```

```r
library(tuber)
yt_oauth(app_id = Sys.getenv("YT_OAUTH_APP_ID"),
         app_secret = Sys.getenv("YT_OAUTH_APP_SECRET"))

comentarios <- get_all_comments(video_id = "7iJJYG7MrpQ")
```

## LLMs vía API con `ellmer`

`ellmer` es una librería de R (de tidyverse) que da una **interfaz unificada** para conversar con LLMs (OpenAI, Anthropic, Google, Ollama local, etc.).

### Patrón básico (OpenAI)
```r
library(ellmer)

chat_gpt <- ellmer::chat_openai(api_key = Sys.getenv("OPENAI_API_KEY"))
chat_gpt$chat("Hola, ¿cómo estás?")
```

### LLM local con Ollama
Ollama corre modelos localmente — útil para datos sensibles o sin internet.

```r
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
```

### Por qué usar LLMs locales
- **Privacidad**: los datos no salen de tu máquina.
- **Costo cero** después de la descarga del modelo.
- **Sin rate limits**.
- **Trade-off**: modelos más pequeños (3B-8B params) tienen menor calidad que modelos cloud (GPT-4, Claude Opus).

## Manejo seguro de credenciales

```r
usethis::edit_r_environ()      # abre el archivo ~/.Renviron
```

En el archivo agregar:
```
OPENAI_API_KEY=sk-...
INEGI_TOKEN=e78bb0aa-...
YT_OAUTH_APP_ID=...
YT_OAUTH_APP_SECRET=...
```

Después reiniciar R y leer con:
```r
Sys.getenv("OPENAI_API_KEY")
```

> **Nunca** subir `.Renviron` ni claves al repositorio. Agregar al `.gitignore`.

## Cosas a tomar en cuenta de las APIs (resumen)

- A veces las APIs **cuestan** (parte del negocio).
- El uso de muchas APIs implica **registrarse** para obtener un token.
- Las APIs tienen **guías de uso y documentación** que hay que leer.
- Se recomienda guardar tokens con `usethis::edit_r_environ()`.

## Listas en R (repaso)

Una **lista** es como un vector donde cada casilla puede ser de **cualquier tipo** (otra lista, un vector, una tibble, un dataframe). El resultado de `fromJSON()` típicamente es una lista anidada que se navega con `$` o `[[ ]]`.

## Ejercicios prácticos (script `codigo_clases_api.R`)

1. **PokeAPI** — extraer altura, peso y nombre de los 151 Pokémon originales con un loop sobre la API REST.
2. **Open-Meteo** — descargar pronóstico horario de temperatura para coordenadas del Tec (19.35, -99.25) y graficar la serie con `geom_line()`.
3. **INEGI BIE-BISE con `inegiR`** — descargar el PIB estatal de las 32 entidades con `lapply()`, consolidar con `do.call(rbind, .)` y rankear por valor más reciente.
4. **YouTube con `tuber`** — autenticarse con OAuth, obtener todos los comentarios de un video con `get_all_comments(video_id = ...)`.
5. **OpenAI con `ellmer`** — chatear con GPT vía API.
6. **Ollama local con `ellmer`** — clasificador de discurso de odio con modelo `qwen3.5:4b` corriendo localmente, usando `system_prompt` para definir el comportamiento.
