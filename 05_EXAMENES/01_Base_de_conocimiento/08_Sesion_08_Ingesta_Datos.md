# Sesión 08 — Ingesta de datos (descarga programática y web scraping)

## Programa de la clase
Cómo obtener datos para análisis: datos abiertos, descarga automatizada de archivos desde internet (`curl::curl_download`, `zip::unzip`), y web scraping con `rvest` para extraer información de páginas web.

## Fuentes de datos

Los datos pueden provenir de varias fuentes:

1. **Datos abiertos** (portales gubernamentales, organizaciones internacionales).
2. **Información de la web** (páginas no estructuradas → web scraping).
3. **APIs** (interfaces programáticas — ver Sesión 09).

## Datos estructurados vs no estructurados

| Tipo | Definición | Ejemplos |
|---|---|---|
| **Estructurados** | Presentados en una **forma predefinida**. Típicamente tabular: columnas = variables, filas = observaciones. Empaquetados y listos para usar. | `.csv`, `.txt`, `.docx`, `.xlsx`, `.shp`, `.geojson` |
| **No estructurados** | No tienen modelo predefinido o no están ordenados de forma sistemática. La información está ahí pero hay que **extraerla y empaquetarla**. | PDFs (algunos), imágenes, páginas web (catálogos, textos) |

## Datos abiertos

> **Filosofía y práctica que persigue que determinados tipos de datos estén disponibles de forma libre para todo el mundo, sin restricciones de derechos de autor, patentes u otros mecanismos de control.**
> — *Open Knowledge Foundation*

### Condiciones para que los datos sean abiertos
1. **Disponibles y de fácil acceso** (descargables desde internet a un costo razonable).
2. **Reutilizables y redistribuibles** (la licencia debe permitir usarlos, redistribuirlos e integrarlos con otros datasets).
3. **Facilitan la participación universal** (sin discriminación en términos de personas, grupos o áreas de uso).

### Detalle de la licencia (Open Definition)
- Disponibles integralmente a costo razonable, preferiblemente gratis vía internet, en forma modificable.
- La licencia no debe restringir vender o redistribuir los datos solos o como parte de un paquete.
- Debe permitir modificaciones y obras derivadas, distribuibles bajo las mismas condiciones.
- Sin obstáculos tecnológicos: **formato abierto** (sin restricciones monetarias ni de SO).
- Puede exigir reconocimiento (atribución) pero no de manera onerosa.
- No debe discriminar a personas/grupos ni restringir un ámbito de uso (ej. "no uso militar").

## Descarga de datos a través de R

### Ventajas de la descarga programática
- Más **rápido** que el trabajo manual (especialmente para muchos archivos).
- Más **desafiante** intelectualmente.
- Permite a los lectores **reproducir** tu trabajo.
- Permite **compartir solo el código**, dejando la descarga al lector (no necesitas subir archivos pesados).

### Funciones a repasar
| Función | Uso |
|---|---|
| `str_c()` | Concatenar texto (útil para construir URLs dinámicamente) |
| `curl::curl_download()` | Descargar archivos de internet (`.zip`, `.xlsx`, etc.) |
| `zip::unzip()` | Descomprimir archivos `.zip` |
| `for() {}` | Bucles para automatizar descargas repetitivas |

## `curl::curl_download()`

Función para bajar archivos de internet.

```r
curl::curl_download(url, destfile, quiet = TRUE, mode = "wb",
                    handle = new_handle())
```

- `url`: dirección del archivo a descargar.
- `destfile`: nombre y ruta donde guardar localmente.

### Ejemplo
```r
curl::curl_download(
  url = "https://www.inegi.org.mx/contenidos/programas/intercensal/2015/tabulados/14_vivienda_mor.xls",
  destfile = "01_Datos/Datos Censo/HogaresMorelos.xls"
)
```

> **¿Qué es curl?** *Client URL* es un programa de línea de comandos que **transfiere datos desde o hacia un servidor**. A diferencia del navegador (que renderiza HTML+CSS+imágenes), curl visitando una URL recibe el **código fuente crudo** (texto, JSON, archivo).

## `zip::unzip()`

Descomprime un archivo `.zip`.

```r
zip::unzip(zipfile = "01_Datos/Datos INE/01.zip",
           exdir   = "01_Datos/Datos INE")
```

- `zipfile`: nombre y ubicación del `.zip`.
- `exdir`: directorio donde colocar los archivos descomprimidos.

## Bucles `for` (repaso)

Sirven para crear bucles o ciclos:

```r
for (elemento in secuencia) {
  Haz_paso_1
  Haz_paso_2
  ...
}
```

### Receta del profesor para construir un loop
1. **Define qué quieres hacer** y qué resultado esperar (loops sirven para automatizar tareas repetitivas).
2. **Hazlo para un caso individual** (n=1) — primero el proceso una vez.
3. **Identifica las partes variables** del proceso (¿qué cambia cuando n=2, 3, …?).
4. **Cambia las partes variables por objetos** de R (para irlos cambiando dentro del loop).
5. **Construye el `for`** definiendo secuencia, contador y proceso.
6. **¿Algo tronó?**
   - **Sí**: ver qué excepción surgió y ajustar.
   - **No**: que algo no haya tronado no significa que esté bien — verificar que el resultado obtenido es el deseado.

## Web scraping con `rvest`

Extracción de información de páginas web mediante código.

### Librerías
```r
library(rvest)
library(tidyverse)
library(openxlsx)
```

### Flujo básico
1. **Cargar el HTML** con `read_html(url)`.
2. **Extraer el elemento que interesa** con `html_table()`, `html_nodes()`, `html_text()` o `html_attr()`.
3. **Procesar / limpiar** los datos.

### Ejemplo 1 — Extraer una tabla de Wikipedia

```r
codigo <- read_html("https://en.wikipedia.org/wiki/Legality_of_cannabis")

# Extraer la 3ª tabla de la página
tabla <- codigo %>%
  html_table() %>%
  pluck(3)

# Filtrar países donde el consumo recreacional es ilegal
tabla %>%
  filter(str_detect(Recreational, pattern = "Illegal|illegal"))
```

### Ejemplo 2 — Extraer artículos de un autor (varias páginas)

Patrón típico de paginación:
```
https://atiempo.tv/author/juvenal-campos/page/1/
https://atiempo.tv/author/juvenal-campos/page/2/
...
```

Extracción dirigida con selectores CSS:
```r
url_juve <- "https://atiempo.tv/author/juvenal-campos/page/2/"
html_juve <- read_html(url_juve)

# Títulos
titulos <- html_juve %>%
  html_nodes(".entry-title") %>%
  html_nodes("a") %>%
  html_text()

# Fechas
fechas <- html_juve %>%
  html_nodes(".entry-date") %>%
  html_nodes("time") %>%
  html_text()

# URLs (atributo href)
url <- html_juve %>%
  html_nodes(".entry-title") %>%
  html_nodes("a") %>%
  html_attr("href")
```

### Loop anidado para descargar el texto de cada artículo
```r
vector_texto_vacio <- c()

for (i in 1:length(introduccion)) {
  html_articulo <- read_html(url[i])
  texto <- html_articulo %>%
    html_nodes(".entry-content") %>%
    html_text()
  vector_texto_vacio <- append(vector_texto_vacio, texto)
  print(str_c("Ya se extrajo el artículo ", i))
}
```

### Loop sobre todas las páginas (paginación)
```r
tabla_vacia_articulos <- tibble()

for (k in 1:10) {
  url_juve <- str_c("https://atiempo.tv/author/juvenal-campos/page/", k, "/")
  html_juve <- read_html(url_juve)
  # ... extraer titulos, fechas, urls, textos ...
  tabla_datos <- cbind(titulos, fechas, url, textos = vector_texto_vacio)
  tabla_vacia_articulos <- rbind(tabla_vacia_articulos, tabla_datos)
  print(str_c("Lista la extracción de la página ", k))
}

write.xlsx(tabla_vacia_articulos, "articulos_juve.xlsx")
```

## Funciones clave de `rvest`

| Función | Uso |
|---|---|
| `read_html(url)` | Descarga el HTML de una URL |
| `html_table()` | Extrae tablas de la página como dataframes |
| `html_nodes(selector)` | Selecciona nodos por selector CSS o XPath |
| `html_text()` | Extrae el texto de los nodos |
| `html_attr("href")` | Extrae un atributo (URL, src, etc.) |
| `pluck(n)` | Toma el n-ésimo elemento de una lista |

## Consideraciones éticas y técnicas del scraping

- Revisar `robots.txt` del sitio.
- Respetar términos de servicio.
- No saturar el servidor (incluir pausas entre peticiones — `Sys.sleep()`).
- Identificarse honestamente.

## Ejercicios prácticos (script `ejercicio_scraping.R`)

1. **Wikipedia – Legalidad del cannabis**: extraer tabla 3, filtrar países donde el consumo recreacional es ilegal, calcular porcentaje (163/202 ≈ 80.7%).
2. **atiempo.tv** – extraer todos los artículos del autor Juvenal Campos:
   - Identificar URL paginada.
   - Loop sobre 10 páginas.
   - Loop interno sobre cada artículo para extraer su texto.
   - Guardar todo en `articulos_juve.xlsx`.
   - Filtrar artículos que mencionen "Claude": `filter(str_detect(textos, "Claude"))`.

Otros ejercicios:
- `ejercicio_sesion_11.R` — descarga de tabulados de INEGI con `curl::curl_download` y `zip::unzip`.
- Carpeta `descarga_inegi/` y `ejemplo_escrapeo_casa_materiales/` — casos prácticos de descarga programática y scraping.
