
app_server <- function(input, output) {
  # Uncomment to include a theme selector
  # bs_themer() 
  output$p <- renderPlot({
    ggplot(penguins) +
      geom_histogram(aes(!!input$var), bins = input$bins) +
      theme_bw(base_size = 20)
  })
}