## Include functions for:
## - Generate reactives from inputs
## - Generate outputs from inputs
## - Generate inputs, e.g., from config


mytheme <- function(){
  bs_theme(
    bg = "#FFF",
    fg = "#001F66",
    # "navbar-fg" = "#FFF",
    # "navbar-bg" = "#001F66",
    primary = "#fab117",
    secondary = "#e1ebee",
    success = "#5cae6e",
    danger = "#d96363",
    base_font = font_google("Inter"),
    code_font = font_google("JetBrains Mono")
  )
}

mymenu <- function(){
  
}

myvbs <- function(values = 1:3, 
                  icons = c("graph-up", "thermometer-sun", "handbag"),
                  pos = "top right",
                  .fill = FALSE,
                  .size = "0.5em"){
  list(value_box(
    title = "Correlation",
    value = values[1],
    theme = "warning",
    showcase = bsicons::bs_icon(icons[1],
                                size = .size),
    showcase_layout = pos,
    fill = .fill
  ),
  value_box(
    title = "KPI_2",
    value = values[2],
    theme = "danger",
    showcase = bsicons::bs_icon(icons[2],
                                size = .size),
    showcase_layout = pos,
    fill = .fill
  ),
  value_box(
    title = "KPI_3",
    value = values[3],
    theme = "success",
    showcase = bsicons::bs_icon(icons[3],
                                size = .size),
    showcase_layout = pos,
    fill = .fill
  ))
}