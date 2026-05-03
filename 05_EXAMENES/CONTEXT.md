# Contexto de Sesión — Generación de Banco de Preguntas Módulo 5

**Fecha:** 2026-05-02  
**Proyecto:** EC3002C.601 — Módulo 5: Inteligencia Artificial (Tec de Monterrey)  
**Ubicación:** `05_EXAMENES/`

---

## 1. Archivos Creados

### Bancos de preguntas
| Archivo | Descripción | Filas |
|---|---|---|
| `03_examen_modulo5/examen_81_preguntas.xlsx` | Banco intermedio: 25 originales + 56 nuevas | 81 |
| `03_examen_modulo5/examen_81_preguntas.rds` | Versión RDS del banco intermedio | 81 |
| `03_examen_modulo5/examen_banco_completo.xlsx` | **Banco único consolidado** (duplicados eliminados, ordenado por sesión) | **81** |

### Scripts
| Archivo | Descripción |
|---|---|
| `generar_banco_80.R` | Script que generó las 56 preguntas nuevas a partir de la base de conocimiento. Contiene la lógica de barajeo de opciones y verificación de distribución equitativa. |

---

## 2. Archivos Modificados

### `03_examen_modulo5/app_examen_25.R`
**Cambios clave:**
- **Antes:** Cargaba un solo archivo RDS fijo (`examen_25_preguntas.rds`) con 25 preguntas en orden fijo.
- **Después:** Carga el Excel consolidado (`examen_banco_completo.xlsx`), selecciona 25 preguntas al azar con `slice_sample()`, las ordena por número de sesión (ascendente), y asigna IDs secuenciales.
- Al presionar **"Volver al inicio"** se borra `estado$examen <- NULL`, forzando un nuevo sorteo en el siguiente intento.
- Se agregaron librerías `readxl` y `stringr`.

---

## 3. Metodología de Generación de Preguntas

### Fuentes
Se leyeron los 9 archivos Markdown de `01_Base_de_conocimiento/`:
- `01_Sesion_01_Introduccion_IA.md`
- `02_Sesion_02_VibeCoding_RStudio.md`
- `03_Sesion_03_Tidyverse.md`
- `04_Sesion_04_Ggplot2.md`
- `05_Sesion_05_Mapas_Geografica.md`
- `06_Sesion_06_ENIGH.md`
- `07_Sesion_07_ENOE.md`
- `08_Sesion_08_Ingesta_Datos.md`
- `09_Sesion_09_APIs_LLMs.md`

### Diseño de preguntas
- **56 preguntas nuevas** generadas, una por cada concepto/procedimiento clave.
- **Dificultad elevada**: distractores plausibles que confunden conceptos similares (ej. `survey_mean` vs `survey_total`, `desviación estándar` vs `error estándar`, `pivot_longer` vs `pivot_wider`).
- **Distribución equitativa de respuestas correctas**: exactamente 14 A, 14 B, 14 C, 14 D en las 56 nuevas.
- **Opciones barajadas**: las 3 opciones incorrectas se reordenan aleatoriamente dentro de cada pregunta para evitar patrones posicionales.

### Distribución por sesión (81 preguntas totales)
| Sesión | Temas | Preguntas |
|---|---|---|
| 1 | Introducción a la IA | 10 |
| 2 | Vibe Coding / RStudio | 9 |
| 3 | Tidyverse | 10 |
| 4 | ggplot2 | 9 |
| 5 | Mapas e información geográfica | 9 |
| 6 | ENIGH | 10 |
| 7 | ENOE | 8 |
| 8 | Ingesta de datos / Web Scraping | 9 |
| 9 | APIs y LLMs | 7 |

### Distribución total de respuestas correctas
- A: 20
- B: 20
- C: 20
- D: 21

---

## 4. Estructura de Columnas (todos los Excels)

```
num | tema | pregunta | opcion_a | opcion_b | opcion_c | opcion_d | opcion_correcta | explicacion
```

---

## 5. Decisiones de Diseño Tomadas

1. **Formato Excel sobre RDS:** La app final usa `read_excel()` en lugar de `readRDS()` para facilitar la edición manual del banco por parte del profesor.
2. **Dedup por texto de pregunta:** Al consolidar se usó `distinct(pregunta, .keep_all = TRUE)` para evitar duplicados exactos.
3. **Ordenamiento por sesión:** Aunque la selección es aleatoria, el examen presenta las preguntas ordenadas de la Sesión 1 a la 9 para no desorientar al estudiante.
4. **Semilla aleatoria:** Se usa `set.seed(NULL)` para que cada sesión de R genere un examen diferente.

---

## 6. Cómo Usar la App

```r
# Desde la carpeta 05_EXAMENES/
shiny::runApp("03_examen_modulo5/app_examen_25.R")
```

El estudiante:
1. Presiona **"Comenzar examen"**.
2. Responde 25 preguntas aleatorias ordenadas por sesión.
3. Presiona **"Calificar examen"**.
4. Ve su calificación y puede aceptar para revisar errores.
5. Al volver al inicio, se genera un **nuevo examen aleatorio**.

---

## 7. Archivos Legado (no eliminados, por seguridad)

- `examen_25_preguntas.xlsx`
- `examen_25_preguntas.rds`
- `examen_81_preguntas.xlsx`
- `examen_81_preguntas.rds`

---

*Generado automáticamente al cierre de sesión.*
