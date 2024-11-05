
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

  sim <- reactiveVal()

  observeEvent(input$ab_run, {
    if (input$ti_nseed != "") {
      this_seed <- as.numeric(input$ti_nseed)
    } else {
      this_seed <- NULL
    }
    sim(sim_risk(input$ni_nsim,
                 input$ni_event_min,
                 input$ni_event_mode,
                 input$ni_event_max,
                 input$si_event_new[1],
                 input$si_event_new[2],
                 input$si_event_new[3],
                 input$ni_mag_min,
                 input$ni_mag_mode,
                 input$ni_mag_max,
                 input$si_mag_new[1],
                 input$si_mag_new[2],
                 input$si_mag_new[3],
                 this_seed))
  })

  output$dt_sim <- renderDT({
    validate(
      need(sim(), "Please run a simulation before browsing results.")
    )
    sim() |>
      datatable(rownames = TRUE)
  })
  output$downloadData <- downloadHandler(
    filename = function() {
      # Use the selected dataset as the suggested file name
      paste0("simulation.csv")
    },
    content = function(file) {
      # Write the dataset to the `file` that will be downloaded
      write.csv(sim(), file, row.names = FALSE)
    }
  )
  output$pdist <- renderPlotly({
    validate(
      need(sim(), "Please run a simulation before browsing results.")
    )
    p <- plot_densities(sim(),
                        loss_type = input$rgb_losstype)
    ggplotly(p)
  })
  output$pchance <- renderPlotly({
    validate(
      need(sim(), "Please run a simulation before browsing results.")
    )
    p <- plot_chance(sim(),
                     loss_type = input$rgb_losstype)
    ggplotly(p)
  })
  output$vbs <- renderUI({
    validate(
      need(sim(), "Please run a simulation before browsing results.")
    )
    .title1 <- ifelse(input$rgb_losstype == "magnitude", "Average loss",
                      "Average events")
    .values <- sim() |>
      group_by(.data$situation) |>
      summarise(events = round(mean(.data$events)),
                magnitude = round(mean(.data$magnitude))) |>
      pull(input$rgb_losstype)
    myvbs(values = c(.values, 0),
          icons = c("arrow-up", "arrow-down", "handbag"),
          titles = c(.title1, "Avg. Proposed", "kk"))[1:2]
  })
  output$down_word <- downloadHandler(
    filename = function() {
      paste0("simulation_", format(Sys.time(), "%Y-%m-%d_%H%M%S"), ".docx")
    },
    content = function(file) {
      generate_report("docx", file, sim(), input)
    }
  )
  output$down_pdf <- downloadHandler(
    filename = function() {
      paste0("simulation_", format(Sys.time(), "%Y-%m-%d_%H%M%S"), ".pdf")
    },
    content = function(file) {
      generate_report("pdf", file, sim(), input)
    }
  )
  output$down_html <- downloadHandler(
    filename = function() {
      paste0("simulation_", format(Sys.time(), "%Y-%m-%d_%H%M%S"), ".html")
    },
    content = function(file) {
      generate_report("html", file, sim(), input)
    }
  )
}
