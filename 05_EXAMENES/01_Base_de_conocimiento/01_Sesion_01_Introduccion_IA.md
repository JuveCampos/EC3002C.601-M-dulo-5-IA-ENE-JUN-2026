# Sesión 01 — Presentación y uso de la IA

## Propósito del curso

Dotar al estudiante de herramientas para el manejo de datos y desarrollo de simulaciones, reforzar conocimientos de programación y profundizar competencias mediante experimentación práctica. Lo que el profesor busca: (1) que los alumnos se sientan más seguros al programar, (2) que estén preparados para los efectos de la IA en los próximos años, (3) que puedan resolver problemas prácticos de su ámbito profesional.

## Programa global del módulo (4 bloques)

1. **Introducción a la IA y LLMs**: peligros, beneficios, fundamentos de LLMs, prompt-engineering, herramientas de generación de texto, vibe coding, otras herramientas, casos de uso.
2. **Programación en R**: instalación, proyectos, objetos y funciones, estructuras de datos, carga de archivos, tidyverse, manipulación básica (filter, select, group_by, summarise, encadenamiento), estadística descriptiva, bucles y lapply, SQL.
3. **Visualización de datos**: ggplot, interactiva.
4. **Datos de México**: encuestas e incertidumbre, INEGI, ENIGH, ENOE, indicadores.
5. **Aplicaciones**: datos abiertos, web scraping, APIs, mapas.
6. **Machine Learning**: regresión lineal, modelos de regresión, modelos de clasificación, pruebas de modelos.

Contextos conceptuales presentados: tráfico vehicular, transmisión de un rumor, análisis del crimen y terrorismo, cambio climático, competencia económica.

## Uso de la IA en el Tec — Principios éticos institucionales

Se permite usar IA siguiendo los **principios éticos** del Tec de Monterrey:
- **Respeto a la dignidad humana**: no manipular ni influir indebidamente en personas.
- **No maleficencia**: evitar daños físicos, psicológicos, reputacionales o a la privacidad.
- **Promoción de la autonomía**: fomentar decisiones informadas.
- **Equidad**: acceso inclusivo y beneficios compartidos.
- **Seguridad**: proteger datos y usar entornos seguros.
- **Veracidad**: contrastar y validar la información generada.
- **Explicabilidad y transparencia**: entender y declarar el uso de IA.
- **Responsabilidad**: evaluar consecuencias y actuar con reflexión.
- **Bienestar social y medioambiental**: uso para el bien común y la sostenibilidad.

### Sugerencias prácticas
1. **Declarar siempre** el uso de IA en trabajos individuales y colaborativos.
2. Emplear IA para **potenciar el aprendizaje**, resolver dudas y organizar ideas.
3. **Citar y referenciar** cuando sea necesario (formato APA para Chatbots).

### Regla clave: "La IA no es excusa"
- Los errores de la IA que uses **son tus errores**.
- Los errores de la IA que use alguien de tu equipo **son tus errores**.
- La deshonestidad cometida con IA tiene consecuencias para ti y tu equipo.

## Fundamentos de LLMs (Large Language Models)

### Definición
Un **LLM** es un sistema de IA que **procesa y genera texto** en lenguaje natural, aprendiendo patrones a partir de **grandes** cantidades de datos. Ejemplo de tarea: predecir la palabra que sigue en una frase.

Flujo: `Texto (prompt) → Modelo LLM → Texto (output)`.

### ¿Cómo funciona un LLM?
1. **Texto de entrada → Tokenización** (palabras a números).
2. **Procesamiento** con redes neuronales (capas de **atención**).
3. **Predicción de la siguiente palabra** según el contexto.
4. Respuesta generada en texto natural.

### Usos comunes de los LLMs
- Redacción y edición de textos.
- Explicaciones y tutorías.
- Resumen de documentos.
- Simulación de diálogos o roles.
- Resolución de dudas.
- Generación de código.

> Nota: las imágenes no se generan estrictamente con LLMs sino con otro tipo de modelos (modelos de difusión, etc.).

## Fundamentos de Ingeniería de Prompts (Prompt Engineering)

La **ingeniería de prompts** busca incidir en las instrucciones que se le brindan a un LLM para:
1. Transmitir al modelo de manera **inequívoca** lo que se espera de él.
2. Lograr respuestas **consistentes y predecibles** ante inputs similares.
3. Obtener mejores resultados con la **menor cantidad de tokens**, optimizando costo y tiempo.

> La calidad de la respuesta depende directamente de la **claridad, contexto y estructura** de la instrucción.

### Ingredientes mínimos de un buen prompt (TaCoLiRo)
- **Tarea**: la actividad que queremos que realice el modelo.
- **Contexto**: información previa que el modelo debe tomar en cuenta.
- **Límites**: lo que el modelo debe o no debe incluir en su respuesta.
- **Rol**: el rol que debe asumir el modelo.

### Sintaxis XML para prompts elaborados
Se recomienda envolver cada elemento del prompt en etiquetas tipo XML para estructurar y reducir ambigüedad:
```
<rol>...</rol>
<enfoque>...</enfoque>
<contexto>...</contexto>
<tareas_especificas>...</tareas_especificas>
<limites>...</limites>
<formato_salida>...</formato_salida>
<fuentes_prioritarias>...</fuentes_prioritarias>
```

### Prompts para otros casos de uso

**Para videos:** Tarea, Historia, Target audience, Length, Tono, Formato (vertical, horizontal, 16:9), Visuales, B-Roll, Closing, Text and graphics.

**Para imágenes:** Sujeto, Acción, Ambiente, Estilo (anime, pintura antigua, hiperrealista), Iluminación, Detalles clave.

## Stacks de IA recomendados

**Para empezar:**
- Una herramienta de chat general.
- Un buscador con fuentes.
- Una herramienta de creación.
- Una herramienta de automatización.

**Más experto:**
- Un copiloto de código.
- APIs de modelos.
- Agentes y orquestación.
- Automatización avanzada.

## LLMs para generar código

Los LLMs pueden escribir, corregir y optimizar código porque fueron entrenados con **repositorios de código y documentación técnica**.

### Aplicaciones
- Autocompletar y escribir funciones enteras.
- Detectar y corregir errores (debugging).
- Explicar código existente.
- Convertir descripciones en código (prompt → script).
- Traducir entre lenguajes de programación.

### Herramientas
- **Generales**: ChatGPT, Claude, Gemini, Grok.
- **Especializadas**: Cursor (editor con IA), CLIs como **Claude Code** y **Gemini CLI**.

> Las herramientas especializadas en código facilitan el trabajo: pueden ejecutar y probar el código sin que tengas que copiar y pegar.

> Herramienta favorita del profesor (agosto 2025): **Claude Code**, un CLI que permite acceder a carpetas de trabajo, leer y escribir archivos, y generar código. Tiene buen desempeño con R, particularmente en aplicaciones Shiny básicas. Requiere **Node.js 18+**.

## Glosario de términos de IA

| Término | Definición | Ejemplo |
|---------|-----------|---------|
| **LLMs (Large Language Models)** | Modelos grandes de lenguaje que entienden y generan texto. | GPT-5, Claude Opus, Gemini 2.5 Pro |
| **Tokens** | Palabras, sílabas o letras que el modelo procesa. Afectan costo, límite y velocidad. | "Hola mundo" ≈ 2 tokens |
| **Context Window (Ventana de contexto)** | Cantidad de texto (tokens) que el modelo procesa en una sola interacción. Si tu documento es más grande, no podrá leerlo completo. | GPT-4 Turbo: 128K tokens (~300 páginas) |
| **Prompt Engineering** | Diseñar la instrucción para obtener el mejor resultado. | "Actúa como un experto en marketing y redacta un copy para..." |
| **System Prompt** | Instrucción base que define el comportamiento del modelo antes de la interacción del usuario. Determina personalidad, límites y enfoque. | "Eres un asistente legal que responde solo sobre leyes mexicanas." |
| **Alucinaciones (Hallucinations)** | Cuando el modelo genera información falsa con total confianza, como si fuera un hecho. | Inventar una cita textual de un autor o un artículo que no existe. |
| **Temperature (Temperatura)** | Parámetro que controla qué tan creativa o predecible es la respuesta. Baja (0.0) = precisa; Alta (1.0) = creativa. | 0.0 para datos financieros, 1.0 para escritura creativa. |
| **Multimodal** | Modelos que procesan no solo texto, sino imágenes, audio, video y documentos. | Subir foto de un recibo y pedir que extraiga los datos. |
| **RAG (Retrieval Augmented Generation)** | Técnica que conecta LLMs a fuentes de datos actualizadas para respuestas más precisas y reducir alucinaciones. | Chatbot de soporte que consulta la base de conocimiento antes de responder. |
| **Agentes de IA (AI Agents)** | Sistemas de IA que planifican, deciden y ejecutan secuencias de tareas de forma autónoma usando herramientas externas. | Agente que investiga un tema, redacta un informe y lo envía por correo. |
| **MCP (Model Context Protocol)** | Protocolo abierto que conecta modelos de IA con herramientas y fuentes externas de manera estandarizada. Es el "USB universal" de la IA. | Conectar Claude con Google Drive, Slack, Notion. |
| **Skills (Habilidades)** | Capacidades específicas que se le dan al modelo para tareas concretas (crear documentos, generar imágenes, analizar hojas de cálculo). | Skill de PowerPoint para que Claude genere presentaciones profesionales. |
| **API (Application Programming Interface)** | Forma en que aplicaciones se conectan con modelos de IA de manera programática. | App de atención al cliente que usa la API de Claude. |
| **Embeddings** | Representaciones matemáticas de palabras en un espacio vectorial para encontrar relaciones semánticas. Base de búsquedas semánticas y sistemas de recomendación. | "gato" y "perro" están cerca en el espacio vectorial; "coche" más lejos. |
| **Fine-Tuning (Ajuste Fino)** | Ajustar un modelo con datos específicos para una tarea concreta. | Entrenar un modelo con datos médicos para responder preguntas de salud. |
| **XML (Extensible Markup Language)** | Formato con etiquetas para estructurar prompts. Reduce ambigüedad. | `<instruccion>Responde en español</instruccion>` |
| **MVP (Minimum Viable Product)** | Versión mínima de un producto para validar una idea rápido. | Crear un chatbot básico con una API antes de invertir en una plataforma completa. |
| **Latencia vs. Throughput** | Latencia = tiempo que tarda en empezar a responder; Throughput = cuántas solicitudes procesa simultáneamente. | Baja latencia para chatbots en vivo; alto throughput para procesamiento masivo. |

## Diagnóstico inicial del curso

Cuestionario inicial para conocer:
- ¿Qué tanto saben de Ciencia de Datos?
- ¿Qué herramientas saben usar? (R, Python, QGIS, ChatGPT, Excel, etc.)
- ¿Qué esperan del curso?

## Reglas de clase

- Mantener el **respeto** hacia compañeros y profesores.
- **Participar** de forma ordenada y respetuosa.
- Usar dispositivos electrónicos **solo cuando el profesor lo indique**.
- **Realizar actividades** correspondientes al curso en desarrollo.
