
library(tidyverse)

# Datos
datos <- tribble(
  ~profesion,               ~pct,  ~pct_low, ~pct_upp,
  "Periodistas",            42.3,  38.1,     46.5,
  "Economistas",            67.8,  63.2,     72.4,
  "Diseñadores",            58.1,  53.5,     62.7,
  "Abogados",               23.6,  19.8,     27.4,
  "Ingenieros de software", 81.2,  77.4,     85.0,
  "Contadores",             35.9,  31.7,     40.1,
  "Médicos",                29.4,  25.3,     33.5,
  "Profesores",             44.7,  40.2,     49.2
) %>%
  mutate(es_max = pct == max(pct))

# --- Etapa 1: Esqueleto ---
p1 <- ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col() +
  coord_flip()

p1

# --- Etapa 2: Color y error bars ---
p2 <- ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col(fill = "#6950d8", width = 0.7) +
  geom_errorbar(
    aes(ymin = pct_low, ymax = pct_upp),
    width = 0.2,
    linewidth = 0.4
  ) +
  coord_flip()
p2

# --- Etapa 3: Etiquetas de texto ---
p3 <- ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col(fill = "#6950d8", width = 0.7) +
  geom_errorbar(
    aes(ymin = pct_low, ymax = pct_upp),
    width = 0.2,
    linewidth = 0.4
  ) +
  geom_text(
    aes(y = pct_upp, label = paste0(pct, "%")),
    hjust = -0.15,
    size = 3.5
  ) +
  coord_flip()
p3

# --- Etapa 4: Títulos y espacio ---
p4 <- ggplot(datos, 
             aes(x = reorder(profesion, pct), 
                 y = pct)) +
  geom_col(fill = "#6950d8",
           width = 0.7) +
  geom_errorbar(
    aes(ymin = pct_low,
        ymax = pct_upp),
    width = 0.2,
    linewidth = 0.4
  ) +
  geom_text(
    aes(y = pct_upp, 
        label = paste0(pct, "%")),
    hjust = -0.15,
    size = 3.5
  ) +
  coord_flip() +
  scale_y_continuous(expand =
                       expansion(mult = c(0, 0.12))) +
  labs(
    title = "Adopción de herramientas de IA por profesión",
    subtitle = "Porcentaje de profesionistas que usan IA en su trabajo diario, 2025",
    x = NULL,
    y = "Porcentaje (%)",
    caption = "Datos ficticios | Barras de error: IC al 95%"
  )
p4

# --- Etapa 5: Tipografía ---
p5 <- ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col(fill = "#6950d8", width = 0.7) +
  geom_errorbar(
    aes(ymin = pct_low, ymax = pct_upp),
    width = 0.2,
    linewidth = 0.4
  ) +
  geom_text(
    aes(y = pct_upp, label = paste0(pct, "%")),
    hjust = -0.15,
    size = 3.5,
    family = "Ubuntu"
  ) +
  coord_flip() +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(
    title = "Adopción de herramientas de IA por profesión",
    subtitle = "Porcentaje de profesionistas que usan IA en su trabajo diario, 2025",
    x = NULL,
    y = "Porcentaje (%)",
    caption = "Datos ficticios | Barras de error: IC al 95%"
  ) +
  theme_minimal(base_family = "Ubuntu")
p5

# --- Etapa 6: Pulir el theme ---
p6 <- ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col(fill = "#6950d8", width = 0.7, alpha = 0.9) +
  geom_errorbar(
    aes(ymin = pct_low, ymax = pct_upp),
    width = 0.2,
    linewidth = 0.4,
    color = "gray30"
  ) +
  geom_text(
    aes(y = pct_upp, label = paste0(pct, "%")),
    hjust = -0.15,
    size = 3.5,
    family = "Ubuntu",
    color = "gray20"
  ) +
  coord_flip(clip = "off") +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(
    title = "Adopción de herramientas de IA por profesión",
    subtitle = "Porcentaje de profesionistas que usan IA en su trabajo diario, 2025",
    x = NULL,
    y = NULL,
    caption = "Datos ficticios | Barras de error: IC al 95%"
  ) +
  theme_minimal(base_family = "Ubuntu") +
  theme(
    plot.title    = element_text(face = "bold", size = 16, color = "gray10"),
    plot.subtitle = element_text(size = 11, color = "gray40", margin = margin(b = 15)),
    plot.caption  = element_text(size = 8, color = "gray50", margin = margin(t = 15)),
    axis.text.y   = element_text(size = 11, color = "gray20"),
    axis.text.x   = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "gray90", linewidth = 0.3),
    panel.grid.minor    = element_blank(),
    plot.margin = margin(20, 20, 20, 20)
  )
p6

# --- Etapa 7: Highlight de la barra más alta ---
p7 <- ggplot(datos, aes(x = reorder(profesion, pct), y = pct)) +
  geom_col(aes(fill = es_max), width = 0.7, alpha = 0.9, show.legend = FALSE) +
  geom_errorbar(
    aes(ymin = pct_low, ymax = pct_upp),
    width = 0.2,
    linewidth = 0.4,
    color = "gray30"
  ) +
  geom_text(
    aes(y = pct_upp, label = paste0(pct, "%")),
    hjust = -0.15,
    size = 3.5,
    family = "Ubuntu",
    color = "gray20"
  ) +
  coord_flip(clip = "off") +
  scale_fill_manual(values = c("FALSE" = "#6950d8", "TRUE" = "#00b783")) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.12))) +
  labs(
    title = "Adopción de herramientas de IA por profesión",
    subtitle = "Porcentaje de profesionistas que usan IA en su trabajo diario, 2025",
    x = NULL,
    y = NULL,
    caption = "Datos ficticios | Barras de error: IC al 95%"
  ) +
  theme_minimal(base_family = "Ubuntu") +
  theme(
    plot.title    = element_text(face = "bold", size = 16, color = "gray10"),
    plot.subtitle = element_text(size = 11, color = "gray40", margin = margin(b = 15)),
    plot.caption  = element_text(size = 8, color = "gray50", margin = margin(t = 15)),
    axis.text.y   = element_text(size = 11, color = "gray20"),
    axis.text.x   = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.major.x = element_line(color = "gray90", linewidth = 0.3),
    panel.grid.minor    = element_blank(),
    plot.margin = margin(20, 20, 20, 20)
  )
p7

# --- Ver todas las etapas ---
p1
p2
p3
p4
p5
p6
p7
