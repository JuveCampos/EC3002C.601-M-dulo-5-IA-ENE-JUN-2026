
# Ejercicio 01 ----

library(tidyverse)
library(curl)
library(rvest)
library(xml2)

# datos <- 

"https://www.inegi.org.mx/contenidos/programas/ccpv/2010/tabulados/Basico/07_14B_ESTATAL.xls"

"https://www.inegi.org.mx/contenidos/programas/ccpv/2010/tabulados/Basico/07_14B_MUNICIPAL_01.xls"
"https://www.inegi.org.mx/contenidos/programas/ccpv/2010/tabulados/Basico/07_14B_MUNICIPAL_02.xls"
# ...
"https://www.inegi.org.mx/contenidos/programas/ccpv/2010/tabulados/Basico/07_14B_MUNICIPAL_20.xls"
"https://www.inegi.org.mx/contenidos/programas/ccpv/2010/tabulados/Basico/07_14B_MUNICIPAL_32.xls"


 # Caso n = 1
curl::curl_download(url = "https://www.inegi.org.mx/contenidos/programas/ccpv/2010/tabulados/Basico/07_14B_MUNICIPAL_01.xls", 
                    destfile = "descarga_datos_censo/Datos_educacion_01.xlsx")

# Caso n = 2
curl::curl_download(url = "https://www.inegi.org.mx/contenidos/programas/ccpv/2010/tabulados/Basico/07_14B_MUNICIPAL_02.xls", 
                    destfile = "descarga_datos_censo/Datos_educacion_02.xlsx")

# Caso n = i
i = "04"
curl::curl_download(url = str_c("https://www.inegi.org.mx/contenidos/programas/ccpv/2010/tabulados/Basico/07_14B_MUNICIPAL_", i, ".xls"), 
                    destfile = str_c("descarga_datos_censo/Datos_educacion_", i, ".xlsx"))

vector_valores_estados <- c("01", "02", "03", "04", "05", "06", "07", "08", "09", 10:32)

for(i in vector_valores_estados){
  curl::curl_download(url = str_c("https://www.inegi.org.mx/contenidos/programas/ccpv/2010/tabulados/Basico/07_14B_MUNICIPAL_", i, ".xls"), 
                      destfile = str_c("descarga_datos_censo/Datos_educacion_", i, ".xls"))
  print(str_c("Ya se descargó el estado: ", i))
}


tabla_vacia <- tibble()

i = "09"
for(i in vector_valores_estados){

  bd <- readxl::read_xls(str_c("descarga_datos_censo/Datos_educacion_", i, ".xls"), 
                         skip = 5) %>% 
    filter(!is.na(`Entidad federativa`)) %>% 
    filter(Sexo == "Total") %>% 
    filter(`Grupos quinquenales de edad` == "Total") %>% 
    select(1, 2, ncol(.))
  
  names(bd) <- c("nom_ent", "mpio", "grado_promedio_escolaridad")
  
  tabla_vacia <- rbind(tabla_vacia, bd)
  print(i)

}

tabla_vacia


# Ejercicio 02 ----

"https://en.wikipedia.org/wiki/Legality_of_cannabis"

url <- "https://en.wikipedia.org/wiki/Legality_of_cannabis"

legalidad_cannabis <- url %>% 
  read_html() %>% 
  html_table() %>% 
  pluck(3) %>% 
  mutate(is.legal = str_detect(string = Recreational, pattern = "Illegal|illegal"))

prop.table(table(legalidad_cannabis$is.legal))


# web scraoping de mi sitio de publicaciones 

# Caso n = 2

"https://atiempo.tv/author/juvenal-campos/page/2/"

url_juve <- "https://atiempo.tv/author/juvenal-campos/page/2/"

html <- read_html(url_juve)

# Obtenemos los títulos de los artículos en la página 2. 

titulos_articulos <- html %>% 
  html_nodes(".entry-title") %>% 
  html_text()

# Obtenemos las urls 
urls <- html %>% 
  html_nodes(".entry-title") %>% 
  html_nodes("a") %>% 
  html_attr("href")

# Obtenemos las fechas ---
fechas <- html %>% 
  html_nodes(".entry-date") %>% 
  html_text() %>% 
  unique()

# Juntamos todo esto en una tabla .----
tibble(titulos_articulos, urls,fechas)

# Ahora lo hacemos un bucle ----
subpaginas <- 1:10

p = 1

tabla_vacia <- tibble()

for(p in subpaginas){
  
  url_juve <- str_c("https://atiempo.tv/author/juvenal-campos/page/", p, "/")
  
  html <- read_html(url_juve)
  
  # Obtenemos los títulos de los artículos en la página 2. 
  titulos_articulos <- html %>% 
    html_nodes(".entry-title") %>% 
    html_text()
  
  # Obtenemos las urls 
  urls <- html %>% 
    html_nodes(".entry-title") %>% 
    html_nodes("a") %>% 
    html_attr("href")
  
  # Obtenemos las fechas ---
  fechas <- html %>% 
    html_nodes(".entry-date") %>% 
    html_text() %>% 
    unique()
  
  # Juntamos todo esto en una tabla .----
  tabla_subpagina <- tibble(titulos_articulos, urls,fechas)
  
  # Pegamos con lo que etapas anteriores ----
  tabla_vacia <- rbind(tabla_vacia, tabla_subpagina)
  
  print(str_c("Cosechados los datos de la página ", p))
  
}

# Ahora vamos a extraer el contenido de los artículos 

datos_articulos <- tabla_vacia
datos_articulos$texto <- NA

for(j in 1:nrow(datos_articulos)){

    url_articulo <- datos_articulos$urls[j]
    
    texto <- url_articulo %>% 
      read_html() %>% 
      html_nodes(".entry-content") %>% 
      # html_nodes("li") %>% 
      html_text()
    
    datos_articulos$texto[j] <- texto
    print(str_c("Listo artículo ", j))

}

openxlsx::write.xlsx(datos_articulos, "datos_articulos_juve.xlsx")


# Entre al sitio de casas de MercadoLibre y descargue los precios y la información de las casas que hay disponibles en el sitio. 


https://inmuebles.mercadolibre.com.mx/casas/venta/#applied_filter_id%3DOPERATION%26applied_filter_name%3DOperación%26applied_filter_order%3D1%26applied_value_id%3D242075%26applied_value_name%3DVenta%26applied_value_order%3D3%26applied_value_results%3D92005%26is_custom%3Dfalse

https://inmuebles.mercadolibre.com.mx/casas/venta/_Desde_49_NoIndex_True
https://inmuebles.mercadolibre.com.mx/casas/venta/_Desde_97_NoIndex_True
https://inmuebles.mercadolibre.com.mx/casas/venta/_Desde_145_NoIndex_True

# 145-97
# 97-49

indices_pagina <- c(2, seq(49, 49+(48*10), by = 48))

tabla_vacia_casas <- tibble()


https://inmuebles.mercadolibre.com.mx/casas/venta/_Desde_2_NoIndex_True

for(k in indices_pagina){
  
  url <- str_c("https://inmuebles.mercadolibre.com.mx/casas/venta/_Desde_", k, "_NoIndex_True")
  
  html_casas <- read_html(url)
  
  html2 <- html_casas %>% 
    html_nodes(".poly-card") %>% 
    html_nodes(".poly-card__content")
  
  
  titulos <- html2 %>% 
    html_nodes(".poly-component__title-wrapper") %>% 
    html_text()
  
  # poly-component__price
  
  precios <- html2 %>% 
    html_nodes(".poly-component__price") %>% 
    html_text()
  
  # poly-component__location
  direccion <- html2 %>% 
    html_nodes(".poly-component__location") %>% 
    html_text()
  
  # Características 
  caracteristicas <- html2 %>% 
    html_nodes(".poly-component__attributes-list") %>% 
    html_text()
  
  no_recamaras <- str_extract(string = caracteristicas, pattern = "\\d recámara?(s)|\\d dormitorio?(s)")
  no_banios <- str_extract(string = caracteristicas, pattern = "\\d baño|1 baño")
  no_m2_construidos <- str_extract(string = caracteristicas, pattern = "\\d+ m² construido?(s)")
  
  headline <- html2 %>% 
    html_nodes(".poly-component__headline") %>% 
    html_text()
  
  
  datos_subpagina <- tibble(headline, titulos, direccion, precios, no_recamaras, no_banios,  no_m2_construidos)

  tabla_vacia_casas <- rbind(tabla_vacia_casas, datos_subpagina)
  
  Sys.sleep(runif(n = 1, min = 0.5, max = 1.5))
  print(k)
  
}



tabla_vacia_casas
