Sys.setlocale("LC_TIME", "es_ES")

# Librerias: 
library(tidyquant)
library(plotly)
library(tidyverse)

# Función para conseguir las listas de acciones de algun índice: 
get_stock_list <- function(stock_index = "SP500") {
    tq_index(stock_index) %>%
        select(symbol, company) %>%
        arrange(symbol) %>%
        mutate(label = str_c(symbol, company, sep = ", ")) %>%
        select(label) %>% 
        slice(-1)
}

# get_stock_list("DOW")

# Funcion para recortar el TICKER de la selección
get_symbol_from_user_input <- function(user_input) {
    user_input %>% str_split(pattern = ", ") %>% pluck(1, 1)
}


# Conseguir información de acciones en formato TBL
get_stock_data <- function(stock_symbol, 
                           from = today() - days(180), 
                           to   = today(), 
                           mavg_short = 20,
                           mavg_long = 50) {
  
  stock_symbol %>% 
    tq_get(get = "stock.prices", from = from, to = to) %>%
    select(date, adjusted) %>%
    mutate(mavg_short = rollmean(adjusted, k = mavg_short, na.pad = TRUE, align = "right")) %>%
    mutate(mavg_long  = rollmean(adjusted, k = mavg_long, na.pad = TRUE, align = "right"))
  
}

get_stock_data(stock_symbol = "AAPL", from = "2026-04-10")

# Obtener una gráfica de velas: 
get_stock_candles <- function(stock_symbol = "AAPL", 
                              from = today() - days(180), 
                              to   = today()){
  
  data = stock_symbol %>% 
    tq_get(get = "stock.prices", from = from, to = to)
  return(data)
}

data_velas <- get_stock_candles(stock_symbol = "AMZN")

# Función para obtener una serie de tiempo: 
plot_stock_data <- function(data) {
    g <- data %>%
        gather(key = "legend", value = "value", adjusted:mavg_long, factor_key = TRUE) %>%
        ggplot(aes(date, value, color = legend, group = legend)) +
        geom_line(aes(linetype = legend)) +
        theme_tq() +
        scale_y_continuous(labels = scales::dollar_format(largest_with_cents = 10)) +
        scale_color_tq() +
        labs(y = "Adjusted Share Price", x = "", 
             color = "Leyenda: ", linetype = "Leyenda: ")
    
    ggplotly(g)
}

generate_commentary <- function(data) {
    
  warning_signal <- data %>%
        tail(1) %>%
        mutate(mavg_warning_flag = mavg_short < mavg_long) %>%
        pull(mavg_warning_flag)
    
    n_short <- data %>% pull(mavg_short) %>% is.na() %>% sum() + 1
    n_long  <- data %>% pull(mavg_long) %>% is.na() %>% sum() + 1
    
    if (warning_signal) {
      msg <- str_glue("La media móvil de {n_short} días está por debajo de la media móvil de {n_long} días, lo que indica tendencias negativas")
    } else {
      msg <- str_glue("La media móvil de {n_short} días está por encima de la media móvil de {n_long} días, lo que indica tendencias positivas")
    }
    
    return(msg)
}

# Funcion para generar gráfico de velas: ----
gen_candle_plot <- function(data){
  data %>%
    plot_ly(x = ~date,
            type="candlestick",
            open = ~open,
            close = ~close,
            high = ~high,
            low = ~low)
}

gen_candle_plot(data = data_velas)

