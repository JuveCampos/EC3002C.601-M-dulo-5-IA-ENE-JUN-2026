# =============================================================================
# Costo de oportunidad del doctorado: ingreso acumulado real
# Comparación: profesionista (50k/mes) vs. beca doctoral (20k/mes)
# Tasa de inflación: 4% anual | Periodo: 5 años
# =============================================================================

library(tidyverse)
library(scales)

# --- Parámetros ---
ingreso_profesionista <- 50000   # pesos/mes
beca_doctoral         <- 20000   # pesos/mes
inflacion_anual       <- 0.04
n_meses               <- 60      # 5 años

# --- Construcción de datos ---
datos <- tibble(
  mes = 1:n_meses,
  anio = ceiling(mes / 12),
  # Aumento anual que compensa la inflación (cada 12 meses)
  factor_aumento = (1 + inflacion_anual)^(floor((mes - 1) / 12)),
  # Ingreso nominal mensual (con aumentos anuales)
  nominal_profesionista = ingreso_profesionista * factor_aumento,
  nominal_doctoral      = beca_doctoral * factor_aumento,
  # Factor de descuento por inflación (valor presente)
  factor_real = 1 / (1 + inflacion_anual)^((mes - 1) / 12),
  # Ingreso mensual en términos reales (nominal ajustado × descuento)
  real_profesionista = nominal_profesionista * factor_real,
  real_doctoral      = nominal_doctoral * factor_real,
  # Ingreso acumulado real
  acum_profesionista = cumsum(real_profesionista),
  acum_doctoral      = cumsum(real_doctoral),
  # Brecha acumulada
  brecha = acum_profesionista - acum_doctoral
)

# Valor final de la brecha (para anotación)
brecha_final <- datos |> slice_tail(n = 1) |> pull(brecha)

# --- Paleta de colores ---
col_profesionista <- "#2E86AB"
col_doctoral      <- "#E8513D"
col_brecha        <- "#6C5FAF"

# --- Gráfica ---
p <- ggplot(datos, aes(x = mes)) +
  
  # Área de la brecha
  geom_ribbon(
    aes(ymin = acum_doctoral, ymax = acum_profesionista),
    fill = col_brecha, alpha = 0.15
  ) +
  
  # Líneas de ingreso acumulado
  geom_line(
    aes(y = acum_profesionista, color = "Profesionista (50k/mes)"),
    linewidth = 1.2
  ) +
  geom_line(
    aes(y = acum_doctoral, color = "Beca doctoral (20k/mes)"),
    linewidth = 1.2
  ) +
  
  # Línea punteada de la brecha
  geom_line(
    aes(y = brecha),
    color = col_brecha, linewidth = 0.9, linetype = "dashed"
  ) +
  
  # Anotación de la brecha final
  annotate(
    "text",
    x = 57, y = brecha_final + 60000,
    label = paste0(
      "Brecha acumulada:\n$",
      format(round(brecha_final, 0), big.mark = ","),
      " MXN"
    ),
    color = col_brecha, fontface = "bold", size = 3.8,
    hjust = 1, lineheight = 0.9
  ) +
  
  # Marcas de año en eje X
  scale_x_continuous(
    breaks = seq(0, 60, 12),
    labels = paste0("Año ", 0:5)
  ) +
  
  # Formato de pesos en eje Y
  scale_y_continuous(
    labels = label_dollar(prefix = "$", suffix = "", big.mark = ","),
    expand = expansion(mult = c(0, 0.05))
  ) +
  
  # Colores manuales
  scale_color_manual(
    values = c(
      "Profesionista (50k/mes)" = col_profesionista,
      "Beca doctoral (20k/mes)" = col_doctoral
    )
  ) +
  
  # Etiquetas
  labs(
    title    = "Costo de oportunidad del doctorado",
    subtitle = "Ingreso acumulado real a 5 años (inflación: 4% anual, con aumentos anuales compensatorios)",
    x        = NULL,
    y        = "Ingreso acumulado real (pesos de hoy)",
    color    = NULL,
    caption  = "Nota: Se asumen aumentos nominales anuales del 4% que compensan la inflación.\nLa línea punteada muestra la brecha acumulada entre ambos escenarios."
  ) +
  
  # Tema limpio
  theme_minimal(base_size = 13, base_family = "sans") +
  theme(
    plot.title       = element_text(face = "bold", size = 16, margin = margin(b = 4)),
    plot.subtitle    = element_text(color = "gray40", size = 11, margin = margin(b = 12)),
    plot.caption     = element_text(color = "gray50", size = 9, hjust = 0,
                                    lineheight = 1.2, margin = margin(t = 10)),
    legend.position  = "top",
    legend.justification = "left",
    panel.grid.minor = element_blank(),
    panel.grid.major.x = element_blank(),
    axis.text        = element_text(color = "gray30"),
    plot.margin      = margin(20, 20, 15, 15)
  )

# --- Guardar ---
ggsave(
  "costo_oportunidad_doctorado.png",
  plot = p, width = 9, height = 5.5, dpi = 300, bg = "white"
)

# --- Tabla resumen por año ---
resumen <- datos |>
  mutate(
    acum_nom_prof = cumsum(nominal_profesionista),
    acum_nom_doct = cumsum(nominal_doctoral)
  ) |>
  filter(mes %% 12 == 0) |>
  select(anio, acum_nom_prof, acum_nom_doct,
         acum_profesionista, acum_doctoral, brecha) |>
  mutate(across(where(is.numeric) & !anio, ~ round(.x, 0)))

cat("\n=== Resumen por año ===\n")
cat("(acum_nom = nominal acumulado | acum_real = real acumulado)\n\n")
print(resumen, n = Inf)

cat("\n=== Resumen por año (pesos reales) ===\n\n")
print(resumen, n = Inf)
cat(
  "\nBrecha total a 5 años: $",
  format(round(brecha_final, 0), big.mark = ","),
  " MXN (pesos de hoy)\n"
)