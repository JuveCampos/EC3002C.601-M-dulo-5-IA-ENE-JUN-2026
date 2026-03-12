draw_key_line_from_fill <- function(data, params, size) {
  grid::segmentsGrob(
    x0 = 0.1, y0 = 0.5,
    x1 = 0.9, y1 = 0.5,
    gp = grid::gpar(
      col = data$fill %||% "grey20",
      lwd = 2
    )
  )
}

ggplot(datos, aes(x, y, fill = grupo)) +
  geom_col(position = "dodge", 
           key_glyph = draw_key_line_from_fill) +
  theme_minimal()
