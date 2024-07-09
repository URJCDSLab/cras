app_ui <- function(request){
  
  shiny::fluidPage(
    theme = mytheme(),
    
    page_navbar(
      header = tags$head(
        tags$link(rel = "stylesheet", type = "text/css", href = "www/styles.css")
      ),
      window_title = "cras",
      title = span(img(src = "www/img/cras2.jpeg",
                       id = "img-brand"), 
                   "Cybersecurity Risk Analysis and Simulation"),
      theme = mytheme(),
      inverse = TRUE,
      sidebar = sidebar(position = "left",
                        shinyWidgets::pickerInput("pi_mag_distribution",
                                                  label = "Magnitude dist.",
                                                  choices = c("PERT",
                                                              "LogNormal",
                                                              "Triangular")),
                        shinyWidgets::pickerInput("pi_event_distribution",
                                                  label = "Event dist.",
                                                  choices = c("PERT",
                                                              "Beta",
                                                              "Triangular")),
                        uiOutput("ui_pi_distribution"),
                        shinyWidgets::textInputIcon("ti_nsim",
                                                    label = "Simulation runs",
                                                    value = 1000,
                                                    icon = icon("hashtag")),
                        shinyWidgets::textInputIcon("ti_nseed",
                                                    label = "Seed",
                                                    placeholder = "e.g., 123",
                                                    icon = icon("seedling")) |> 
                          tooltip("Fix a value for reproducibility if needed")
                        
      ),
      nav_panel(title = "Overview",
                includeMarkdown("inst/app/www/text/overview.md")
      ),
      nav_panel(title = "Parameters",
                shinyWidgets::actionBttn(
                  inputId = "ab_run",
                  label = "Run",
                  style = "pill", 
                  color = "success"
                ),
                layout_column_wrap(
                  card(
                    card_header("Loss Magnitude",
                                class = "bg-dark"),
                    layout_columns(
                      col_widths = c(5, 7),
                      card(
                        numericInputIcon("ni_mag_min",
                                         value = 0,
                                         label = "Min", 
                                         icon = icon("money-bill-trend-up"),
                                         width = "150px"),
                        numericInputIcon("ni_mag_mode",
                                         value = 50,
                                         label = "Most Likely", 
                                         icon = icon("scale-balanced"),
                                         width = "150px"),
                        numericInputIcon("ni_mag_max",
                                         value = 100,
                                         label = "Max", 
                                         icon = icon("sack-xmark"),
                                         width = "150px")
                      ),
                      card(
                        card_header("Proposed",
                                    class = "bg-secondary"),
                        uiOutput("ui_si_mag_new")
                      )
                    )
                  ),
                  card(
                    card_header("Loss Event Frequency",
                                class = "bg-dark"),
                    layout_columns(
                      col_widths = c(5, 7),
                      card(numericInputIcon("ni_event_min",
                                            value = 0,
                                            label = "Min", 
                                            icon = icon("money-bill-trend-up"),
                                            width = "150px"),
                           numericInputIcon("ni_event_mode",
                                            value = 5,
                                            label = "Most Likely", 
                                            icon = icon("scale-balanced"),
                                            width = "150px"),
                           numericInputIcon("ni_event_max",
                                            value =10,
                                            label = "Max", 
                                            icon = icon("sack-xmark"),
                                            width = "150px")),
                      card(card_header("Proposed",
                                       class = "bg-secondary"),
                           uiOutput("ui_si_event_new")
                           
                      )
                    )
                  )
                )
      ),
      nav_panel(title = "Results",
                layout_sidebar(sidebar = sidebar(position = "right",
                                                 myvbs()[1],
                                                 myvbs()[2],
                                                 myvbs()[3]),
                               shinyWidgets::radioGroupButtons(
                                 inputId = "rgb_losstype",
                                 label = "",
                                 choices = c("Loss Magnitude", 
                                             "Loss Event Frequency"),
                                 status = "primary",
                                 
                               ),
                               card(card_header("Distribution",
                                                popover(
                                                  bsicons::bs_icon("gear"),
                                                  textInput("txt", NULL, "Enter input"),
                                                  title = "Input controls"
                                                ))
                               ),
                               card("Chance of exceeding")
                )                              
      ))
    
  )
}
