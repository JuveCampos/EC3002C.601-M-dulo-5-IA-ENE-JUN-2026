# Sesión 02 — Vibe Coding e Introducción a R / RStudio

## Programa de la clase
- Vibe Coding y sus peligros.
- Configuración de Claude Code.
- Glosario de IA.
- Introducción a R y RStudio.
- Mapa de funcionalidades de RStudio.
- ¿Por qué R?
- Funciones más comunes.
- Proyectos y directorio de trabajo.

## Vibe Coding

### Definición
**Vibe Coding** es una **técnica de programación dependiente de IA** en la que una persona describe un problema en pocas oraciones como instrucciones para un LLM. El LLM genera el software, cambiando el rol del programador de la **codificación manual** a la **guía, prueba y refinamiento** del código generado por IA.

> El nombre captura la esencia: estás "vibrando" con la máquina, comunicándole tu visión general y dejándola manejar la programación. Es como ser director de una película: tú defines la visión y el equipo (la IA) ejecuta los detalles técnicos.

### Origen del término
Acuñado por **Andrej Karpathy** (cofundador de OpenAI y ex-líder de IA en Tesla) en **febrero de 2025**:
> "There's a new kind of coding I call 'vibe coding', where you fully give in to the vibes, embrace exponentials, and forget that the code even exists."

### ¿Por qué es relevante para un estudiante de economía?
Aunque probablemente no planeas ser programador, sí necesitarás:
- **Crear** visualizaciones de datos para presentaciones.
- **Automatizar** tareas repetitivas de análisis.
- **Construir** herramientas simples para tu trabajo.
- **Prototipar** ideas rápidamente.

El vibe-coding te permite hacer esto **sin años de formación en programación**.

> Aún así, es muy importante saber los **fundamentos** de lo que estás haciendo. La programación a partir de 2025 toma en cuenta el uso de muchas herramientas de IA y la habilidad de usarlas estará demandada.

### Programación tradicional vs. Vibe Coding

| Programación Tradicional | Vibe Coding con IA |
|--------------------------|---------------------|
| Aprender un lenguaje | Describe lo que quieres |
| Aprender frameworks | La IA elige el mejor enfoque |
| Escribir código línea a línea | Código generado automáticamente |
| Depurar errores manualmente | IA diagnostica y corrige errores |
| Buscar en StackOverflow | Iteras con lenguaje natural |
| Semanas → meses | Minutos → horas |

> **Nota:** El vibe-coding NO elimina la necesidad de pensamiento crítico. Sigue siendo tu responsabilidad verificar que el código sea correcto.

### Flujo de trabajo del Vibe Coding (6 pasos)
1. **Describe tu idea** — explica en lenguaje natural qué quieres construir.
2. **La IA genera código** — el LLM escribe el código completo (HTML, Python, R, JavaScript, etc.).
3. **Revisa y ejecuta** — el usuario revisa el resultado, lo prueba y da retroalimentación.
4. **Itera y mejora** — el usuario pide cambios ("hazlo más bonito", "añade un filtro").
5. **Depura con IA** — si hay errores, la IA los diagnostica y corrige automáticamente.
6. **Resultado final** — aplicación funcional creada sin escribir una línea de código.

> El ciclo completo pasa a tomar **minutos en lugar de horas o días**. Bajo este enfoque, lo más importante es saber **comunicar claramente al modelo lo que quieres**.

### Ejemplo de uso
1. **Describe tu proyecto:** "Crea una página web que muestre una gráfica interactiva del PIB de México por trimestre desde 2010."
2. **Claude Code (o lo que uses) genera los archivos:** HTML, CSS, JavaScript automáticamente.
3. **Revisa el resultado:** abre los archivos en tu navegador o editor.
4. **Itera:** "Añade un selector de años", "Cambia los colores a tonos azules", "Añade una tabla con los datos debajo de la gráfica."

### Limitaciones y precauciones
- **No reemplaza la verificación humana**: siempre revisa el código generado, especialmente si procesa datos sensibles o toma decisiones.
- **Puede generar código con errores**: los LLMs pueden producir código que parece correcto pero tiene **bugs sutiles**.
- **No es ideal para sistemas críticos**: no uses vibe-coding para software médico, financiero o de seguridad sin revisión exhaustiva.
- **Privacidad**: cuidado con qué datos compartes. **No incluyas datos confidenciales ni credenciales de APIs**.

### Consideraciones éticas y de contexto
- **¿A quién pertenece el código generado por IA?** Es un debate legal activo. En la mayoría de jurisdicciones, el código generado por IA no tiene un autor humano claro. Si lo usas para un proyecto profesional, es tu responsabilidad revisar que no infrinja licencias.
- **La responsabilidad sigue siendo tuya**: que la IA escriba el código no te libera de la responsabilidad sobre lo que ese código hace.
- El vibe-coding democratiza la creación de software, pero plantea el **riesgo de que se genere mucho código de baja calidad**. El desafío es usar estas herramientas como **trampolines para aprender más**, no como excusa para nunca entender los fundamentos.

## Terminal (línea de comandos)

La **terminal** es una herramienta para **interactuar directamente con el sistema operativo** mediante texto, sin usar ventanas o íconos. Permite navegar por carpetas, ejecutar programas y administrar archivos con comandos.

### Comandos básicos

| Comando | Mac / Linux | Windows (PowerShell / CMD) | Descripción |
|---------|-------------|----------------------------|-------------|
| `cd` | `cd nombre_carpeta` | `cd nombre_carpeta` | Cambia de directorio (moverse entre carpetas). |
| `ls` | `ls` o `ls -l` | `dir` | Lista archivos y carpetas del directorio actual. |
| `pwd` | `pwd` | `cd` (sin parámetros) | Muestra la ruta completa de la carpeta actual. |
| `clear` | `clear` | `cls` | Limpia la pantalla de la terminal. |
| `mkdir` | `mkdir nombre_carpeta` | `mkdir nombre_carpeta` | Crea una nueva carpeta. |
| `rm` | `rm archivo.txt` | `del archivo.txt` | Elimina un archivo. |

## Instalación de herramientas de IA en consola

1. Instalar **Node.js**.
2. Instalar **brew** (Mac).
3. Instalar la herramienta requerida (Claude Code, Gemini CLI, Codex, Copilot, etc.).

> Si presenta error de instalación, revisar StackOverflow o preguntarle a la IA del servicio que se desea instalar.

## Introducción a R y RStudio

### ¿Qué es RStudio?
RStudio es un programa que provee un **entorno de desarrollo (IDE)** que da las herramientas necesarias para programar en R.

### Tareas comunes que se hacen con R
1. **Manejo y manipulación de datos** — `library(tidyverse)` (select, filter, group_by, summarise).
2. **Análisis estadístico y econometría** — `library(base)`, `library(MASS)`.
3. **Machine Learning y Deep Learning** — `library(e1071)`, `library(tensorflow)`, `library(caret)`, `library(rpart)`.
4. **Análisis de texto** — `library(tm)`, `library(stringr)` (nubes de palabras, etc.).
5. **Análisis de redes** — `library(igraph)`.
6. **Visualización de datos** — `library(ggplot2)`, `library(plotly)`, `library(leaflet)`, `library(htmlwidgets)`.
7. **Recolección automática de información (Web Scraping, Data Crawling)** — `library(rvest)`, `library(xml)`.
8. **Análisis Geoespacial** — `library(sf)` (abrir información geográfica, modificarla, visualizarla).
9. **Páginas web y reportes** (PDF, doc, diapositivas, tableros estáticos) — `library(markdown)`.
10. **Web Apps** — `library(shiny)`.

### Ventanas de RStudio (4 paneles)

1. **Editor de texto** (amarillo): sección donde se registran las instrucciones que se van a correr en R. Las instrucciones se guardan en **scripts** para reutilización. Aquí se pueden escribir códigos de R, HTML, Python, CSS, Markdown, etc.
2. **Consola** (verde): sección donde se ejecuta el código del editor. También se puede correr código de R que no se requiera guardar.
3. **Ambiente** (rosa): muestra los objetos y funciones cargados en la sesión.
4. **Visualizador** (rojo): para ver:
   - Archivos del directorio de trabajo.
   - Gráficas estáticas generadas con ggplot2 o RBase.
   - Librerías instaladas en RStudio.
   - Visualizaciones web generadas con R.

### Personalización
Para personalizar RStudio: `Tools > Global Options`. Se puede configurar: visualización del código, colores, tamaño y fuente, espacio del código, cuentas para publicar resultados.

## Archivos nativos de R

Al trabajar con R y RStudio se generan cuatro tipos de archivos nativos:
- `*.Rproj` — archivo de proyecto.
- `*.RData` — datos guardados de la sesión.
- `*.R` — scripts de código.
- `*.rds` — un objeto serializado.

> Los **scripts** son los archivos que terminan en `*.R`.

## Objetos y funciones — los dos pilares de R

> Frase clave del curso:
> - **En R, todo lo que existe es un objeto.**
> - **En R, todo lo que ocurre es una función.**

### Objetos
- Los **objetos** son el lugar de la memoria donde guardamos información.
- Podemos crear nuestros objetos o tomar objetos hechos por alguna librería.
- Los objetos son sujetos de ser afectados por las funciones.
- Las funciones son acciones que se aplican a un objeto para obtener un resultado, el cual va a ser un objeto.
- Los objetos (y las funciones) se guardan en el **ambiente**.

### Sintaxis para guardar un objeto
Para guardar un objeto, utilizamos el **operador flechita (`<-`)** o el **operador igual (`=`)**.

```r
nombre_objeto <- contenido_del_objeto
```

> Si no utilizamos estos operadores, no estamos guardando nada en memoria y no lo podremos usar más adelante.

### Reglas para nombrar objetos
- **No usar palabras reservadas** (como `TRUE` o `FALSE`).
- **No empezar con símbolos** (`._/!`, etc.).
- **No empezar con números** (1-9).
- De preferencia, no usar símbolos especiales (ñ, caracteres no-ASCII, etc.).

### Ejemplo
```r
nombres <- c("Joaquín", "María")
sabe.r <- c(TRUE, FALSE)
edad <- c(29, 30)
numero_al_azar <- runif(n = 2, min = 0, max = 10)
datos <- tibble(nombres, sabe.r, edad, numero_al_azar)
```

## Funciones

Las **funciones** son las acciones que vamos a realizar sobre los objetos. Pueden estar precargadas en las librerías base o provenir de librerías externas.

### Sintaxis de una función
```r
nombre_funcion(argumento_1 = "valor_1",
               argumento_2 = "valor_2",
               ...,
               argumento_n = "valor_n")
```

> Los **argumentos** son como palanquitas a las que hay que moverle para que las funciones funcionen de manera adecuada.

### Notación con doble dos puntos (`paquete::funcion`)
Las funciones tienen "nombre y apellido". Se encuentran en la literatura como:
```r
dplyr::filter()
sf::read_sf()
base::sum()
leaflet::leaflet()
```

- Lo que va a la **izquierda de los dos-dos puntos** es la **librería o paquetería** (apellido) de la cual provienen.
- Lo que va al **lado derecho** es el nombre de la función.
- Si llamas a la librería con `library()`, ya no es necesario escribir el apellido.
- Si no se le pone apellido, es que proviene de **base**.

## Librerías

### Definición
Las **librerías** son un conjunto de objetos y funciones programados por terceros, que podemos instalar en nuestra sesión de R para potenciar las funciones que podemos realizar.

### Diferencia clave: instalar vs. llamar
- **Instalar librerías**: se hace UNA SOLA VEZ por computadora (analogía: ir a Home Depot a comprar la herramienta).
- **Llamar librerías**: se hace en cada sesión con `library()` (analogía: sacar la herramienta de la caja para usarla).

### Instalación

**Opción 1 (visual):** En el Visualizador → `Packages > Install`, escribir el nombre de la librería.

**Opción 2 (código):**
```r
install.packages(c("tidyverse", "plotly", "sf", "scales"))
```

### Uso
```r
library(tidyverse)
```

## Estructuras de datos en R

Los datos suelen agruparse en estructuras básicas:

| Estructura | Descripción |
|------------|-------------|
| **Escalares** | Vectores de 1×1. |
| **Vectores** | Arreglos de n×1 (n renglones, 1 columna). |
| **Matrices** | Arreglos cuadrados de n×n. **Un único tipo de dato.** |
| **Arrays** | Matrices de matrices multidimensionales (n×n×…×n). |
| **DataFrames** | Arreglos cuadrados de n×n. **Múltiples tipos de dato.** |
| **Listas** | Contenedores de cualquier cosa. |

### Cómo construirlas

**Vectores:** función combine `c()`.
```r
vector_1 <- c(1, 2, 3, 4, 5)
```

**Matrices:** función `matrix()`. Argumentos como `ncol` o `nrow` definen las dimensiones.
```r
vector_1 <- c(1, 2, 3, 4, 5)
vector_2 <- 10:14
mtx <- matrix(c(vector_1, vector_2), ncol = 2)
```

**DataFrames:** funciones `data.frame()` o `tibble::tibble()`. Se le pasan vectores del mismo tamaño que servirán como columnas.
```r
df <- data.frame(vector_1,
                 vector_2,
                 letras = c("a", "b", "c", "d", "e"))
```
> Este es el tipo de estructura más usado; cuando leemos datos de Excel, por ejemplo, R nos construye automáticamente un DF.

**Listas:** función `list()`. Le metemos como ingredientes lo que sea.
```r
lista <- list(df,        # un df
              mtx,       # una matriz
              vector_2,  # un vector
              vector_1,  # otro vector
              mtcars,    # otro df pre-construido
              list(df, vector_2),  # podemos meter listas
              sum())     # podemos meter funciones
```

## Tipos de datos (vectores atómicos)

### Básicos
- **Character** — para almacenar texto.
- **Numeric** — para almacenar números.
- **Logical** — para almacenar valores lógicos (`TRUE`/`FALSE` o `T`/`F`).

### Compuestos
- **Factor** — para almacenar datos categóricos.
- **Date** — para almacenar fechas.

### Ejemplos de Character
```r
character <- c("Hola", "Adios", "Buenas tardes", "Buenas Noches")
character_2 <- c("1", "2", "tres", "cuatro", "5")
macondo <- c("Muchos años después, frente al pelotón de fusilamiento, ...")
```

## Ejercicio práctico de la sesión

**En parejas:**
1. Asegurarse de que al menos una persona tenga instalada una herramienta de vibe coding.
2. En la carpeta de ejercicios de la sesión está una base de datos con la **proyección de población de CONAPO a 2070**. Revísela.
3. Vibecodee un código de R que permita obtener la **serie de tiempo de la población para cada uno de los estados** de la república. Use el diseño de prompts visto.
4. Complemente con un código que permita hacer un **mapa con la población de México al 2030**.
5. Haga un nuevo código que permita crear un **dashboard con shiny** que permita analizar la población por estado para todos los años, y por año para todos los estados. Itere hasta lograr que la aplicación tenga todas las funcionalidades suficientes.

### Ejercicio guiado #2
1. En el GitHub se encuentra el archivo `02_EJERCICIOS_PRACTICOS/Sesión_01/ejercicio_guiado_2.zip`. Descargarlo.
2. Descomprimir el zip — la carpeta tiene los datos de las proyecciones CONAPO al 2070.
3. Usando el agente de código y prompts, generar una **aplicación shiny** que permita saber:
   - ¿Qué estado tiene más población en un año determinado?
   - ¿En qué año alcanza cada estado su población máxima?

### Tarea
En equipo, elaborar usando LLMs y a partir de lo visto en clase, una **guía de estudio para todo el contenido del temario**.
