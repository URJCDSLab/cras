
app_server <- function(input, output) {
  
  output$ui_si_mag_new <- renderUI({
    noUiSliderInput(
      inputId = "si_mag_new",
      label = "New values:",
      min = input$ni_mag_min, 
      max = input$ni_mag_max,
      value = c(input$ni_mag_min, input$ni_mag_mode, input$ni_mag_max),
      tooltips = TRUE,
      step = 1
    )
  })
  output$ui_si_event_new <- renderUI({
    noUiSliderInput(
      inputId = "si_event_new",
      label = "New values:",
      min = input$ni_event_min, 
      max = input$ni_event_max,
      value = c(input$ni_event_min, input$ni_event_mode, input$ni_event_max),
      tooltips = TRUE,
      step = 1
    )
  })
  
  sim <- reactiveValues()
  observeEvent(input$ab_run,
               {
                 for (i in 1:input$ti_nsim){
                   
                 }
                 sim$event <- rnorm(100)
                 print(sim$event)
               })
}