get_pi_distribution <- function(losstype) {
  if (losstype == "Magnitude") {
    .choices <- c("PERT",
                  "LogNormal",
                  "Triangular")
  } else if (losstype == "Events") {
    .choices <- c("PERT",
                  "Beta",
                  "Triangular")
  } else {
    stop("losstype must be one of 'Magnitude' or 'Events'")
  }
  shinyWidgets::pickerInput("pi_distriburion",
                            label = "Probability distribution",
                            choices = .choices)
}

sim_risk <- function(n, min0e, mode0e, max0e, min1e, mode1e, max1e,
                     min0m, mode0m, max0m, min1m, mode1m, max1m, seed = NULL) {
  if (!is.null(seed)) {
    set.seed(seed)
  }
  withProgress(
    message = "Simulating...",
    value = 0, min = 0, max = n * 4,
    {
      sim_events_0 <- round(sapply(1:n, function(x) {
        rpert(1,
              min0e,
              mode0e,
              max0e)
      }))
      incProgress(n, detail = paste("Current loss event"))
      sim_events_1 <- round(sapply(1:n, function(x) {
        rpert(1,
              min1e,
              mode1e,
              max1e)
      }))
      incProgress(n, detail = paste("Proposed loss event"))
      sim_mag_0 <- numeric()
      for (i in seq_along(sim_events_0)) {
        sim_mag_0[i] <- round(sum(sapply(sim_events_0[i],
          function(x) {
            if (x == 0) {
              0
            } else {
              rpert(x,
                    min0m,
                    mode0m,
                    max0m)
            }
          }
        )), 3)
        incProgress(n, detail = paste("Current loss magnitude", i))
      }

      sim_mag_1 <- numeric()
      for (i in seq_along(sim_events_1)) {
        sim_mag_1[i] <- round(sum(sapply(sim_events_1[i],
          function(x) {
            if (x == 0) {
              0
            } else {
              rpert(x,
                    min1m,
                    mode1m,
                    max1m)
            }
          }
        )), 3)
        incProgress(n, detail = paste("Proposed loss magnitude", i))
      }
    }
  )
  showNotification("Simulation finished. See the results in the next pages",
                   duration = 6, closeButton = FALSE)
  return(data.frame(situation = rep(c("current", "proposed"), each = n),
                    year = rep(1:n, 2),
                    events = c(sim_events_0, sim_events_1),
                    magnitude = c(sim_mag_0, sim_mag_1)))
}

# set.seed(1)
# sim_risk(1000L,
#          0L,
#          5L, 10,
#          0, 3, 7,
#          0, 50, 100,
#          0, 20, 60,
#          NULL)


#' @export
plot_densities <- function(.data,
                           loss_type = c("events", "magnitude"),
                           show_title = TRUE) {
  p <- .data |>
    mutate(events = factor(.data$events)) |>
    ggplot()

  if (loss_type[1] == "magnitude") {
    p <- p +
      aes(x = .data$magnitude,
          col = .data$situation,
          fill = .data$situation) +
      geom_density(alpha = 0.5) +
      scale_x_continuous(labels = scales::dollar_format())

    ltitle <- "Magnitude density plot"
    xlabel <- "Loss exposure"
    ylabel <- "Density"
  } else if (loss_type[1] == "events") {
    p <- p +
      aes(x = .data$events,
          col = .data$situation,
          fill = .data$situation) +
      geom_bar(position = position_dodge()) +
      scale_color_discrete(drop = FALSE)

    ltitle <- "Amount of years per number of annual events"
    xlabel <- "Events"
    ylabel <- "Count"
  }

  if (show_title) {
    p <- p + labs(title = ltitle)
  }
  p +
    theme_bw() +
    labs(x = xlabel,
         y = ylabel,
         color = "Situation",
         fill = "Situation")
}


#' @export
plot_chance <- function(.data,
                        loss_type = c("events", "magnitude"),
                        show_title = TRUE) {
  gdata <- data.frame(loss = round(by(.data[[loss_type]],
                                      .data[["situation"]],
                                      quantile, seq(0, 1, by = 0.01)) |>
                                     unlist(), 3),
                      situation = rep(c("current", "proposed"), each = 101),
                      perc = rep(100 - (0:100), 2))

  p <- gdata |>
    ggplot() +
    aes(x = .data$loss,
        y = .data$perc,
        col = .data$situation) +
    geom_line()

  if (loss_type[1] == "magnitude") {
    p <- p +
      scale_x_continuous(labels = scales::dollar_format()) +
      scale_y_continuous(labels = scales::percent_format(scale = 1))

    ltitle <- "Annualized Loss Exceedance Chart (LEC)"
    xlabel <- "Loss exposure"
    ylabel <- "Probability of Loss or Greater"
  } else if (loss_type[1] == "events") {
    p <- p +
      scale_x_continuous(breaks = scales::breaks_pretty()) +
      scale_y_continuous(labels = scales::percent_format(scale = 1))

    ltitle <- "Annualized chance of exceeding loss events"
    xlabel <- "Loss events"
    ylabel <- "Probability of Loss or Greater"
  }

  if (show_title) {
    p <- p + labs(title = ltitle)
  }
  p +
    theme_bw() +
    labs(x = xlabel,
         y = ylabel,
         color = "Situation",
         fill = "Situation")
}


# plot_chance(simdata, "magnitude")

# plot_densities(simdata)
# plot_densities(simdata, loss_type = "magnitude")


#' @export
myvbs <- function(values = 1:2,
                  icons = c("circle-xmark", "circle-check"),
                  titles,
                  pos = "top right",
                  .fill = FALSE,
                  .size = "0.5em") {
  list(value_box(
    title = titles[1],
    value = values[1],
    theme = "warning",
    showcase = bsicons::bs_icon(icons[1],
                                size = .size),
    showcase_layout = pos,
    fill = .fill
  ),
  value_box(
    title = titles[2],
    value = values[2],
    theme = "success",
    showcase = bsicons::bs_icon(icons[2],
                                size = .size),
    showcase_layout = pos,
    fill = .fill
  ))
}
# myvbs(values = 1:2,
#       icons = c("arrow-up", "arrow-down"),
#       titles = letters[1:2])


generate_report <- function(output_format, file, .data, input) {
  ifile <- system.file(paste0("template_report_", output_format, ".qmd"),
                       package = "cras")
  ofile <- paste0("simulation_", format(Sys.time(), "%Y-%m-%d_%H%M%S"),
                  ".", output_format)
  idn <- showNotification("Please wait while the report is being generated.
                          This may take some time.",
                          type = "warning",
                          duration = NULL,
                          closeButton = FALSE)
  tryCatch({
    quarto_render(
      ifile,
      output_format = output_format,
      output_file = ofile,
      execute_params = list(pi_mag_distribution = input$pi_mag_distribution,
                            pi_event_distribution = input$pi_event_distribution,
                            ni_nsim = input$ni_nsim,
                            ni_event_old_min = input$ni_event_min,
                            ni_event_old_mode = input$ni_event_mode,
                            ni_event_old_max = input$ni_event_max,
                            si_event_new_min = input$si_event_new[1],
                            si_event_new_mode = input$si_event_new[2],
                            si_event_new_max = input$si_event_new[3],
                            ni_mag_old_min = input$ni_mag_min,
                            ni_mag_old_mode = input$ni_mag_mode,
                            ni_mag_old_max = input$ni_mag_max,
                            si_mag_new_min = input$si_mag_new[1],
                            si_mag_new_mode = input$si_mag_new[2],
                            si_mag_new_max = input$si_mag_new[3],
                            sim_data = .data,
                            nseed = if (input$ti_nseed != "") {
                              as.numeric(input$ti_nseed)
                            } else {
                              NULL
                            }),
      quiet = TRUE
    )
    removeNotification(idn)
    showNotification("Report generated successfully.",
                     duration = 6,
                     type = "message")
    file.rename(ofile, file)
  }, error = function(e) {
    removeNotification(idn)
    showNotification(paste("Error generating report: ", e$message),
                     duration = 6,
                     type = "error")
  })
}
