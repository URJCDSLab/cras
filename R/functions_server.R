get_pi_distribution <- function(losstype){
  if (losstype == "Magnitude"){
    .choices = c("PERT",
                 "LogNormal",
                 "Triangular")
  } else if (losstype == "Events"){
    .choices = c("PERT",
                 "Beta",
                 "Triangular")
  } else{
    stop("losstype must be one of 'Magnitude' or 'Events'" )
  }
  shinyWidgets::pickerInput("pi_distriburion",
                            label = "Probability distribution",
                            choices = .choices)
}

sim_risk <- function(n, min0e, mode0e, max0e, min1e, mode1e, max1e,
                     min0m, mode0m, max0m, min1m, mode1m, max1m, seed = NULL){
  if(!is.null(seed)){
    set.seed(seed)
  }
  withProgress(message = "Simulating...",
               value = 0, min = 0, max = n*4,
               {
                 
                 sim_events_0 <- round(sapply(1:n, function(x){
                   rpert(1, 
                         min0e,
                         mode0e,
                         max0e)
                 }))
                 incProgress(n, detail = paste("Current loss event"))
                 sim_events_1 <- round(sapply(1:n, function(x){
                   rpert(1, 
                         min1e,
                         mode1e,
                         max1e)
                 }))
                 incProgress(n, detail = paste("Proposed loss event"))
                 sim_mag_0 <- numeric()
                 for(i in seq_along(sim_events_0)){
                   sim_mag_0[i] <- round(sum(sapply(sim_events_0[i],
                                                    function(x) {
                                                      if(x == 0){
                                                        0
                                                      } else{
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
                 for(i in seq_along(sim_events_1)){
                   sim_mag_1[i] <- round(sum(sapply(sim_events_1[i],
                                                    function(x){
                                                      if(x == 0){
                                                        0
                                                      } else{
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
                   duration = 10, closeButton = TRUE)
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

plot_densities <- function(.data, loss_type = c("events", "magnitude")){
  p <- .data |> 
    mutate(events = factor(events)) |> 
    ggplot()
  
  if(loss_type[1] == "magnitude"){
    p <- p +
      aes_string(x = "magnitude", 
                 col = "situation", 
                 fill = "situation") +
      geom_density(alpha = 0.5)
    ltitle <- "Magnitude density plots for current and proposed situations"
  } else if (loss_type[1] == "events"){
    p <- p +
      aes_string(x = "events", 
                 col = "situation", 
                 fill = "situation") +
      geom_bar(position = position_dodge()) 
    scale_color_discrete(drop=FALSE)
    ltitle <- "Number of efents bar plots for current and proposed situations"
  }
  p +
    theme_bw() +
    labs(title = ltitle)
}

plot_chance <-  function(.data, loss_type = c("events", "magnitude")){
  
  
  gdata <- data.frame(loss = round(by(.data[[loss_type]], 
                                      .data[["situation"]], 
                                      quantile, seq(0, 1, by = 0.01)) |> 
                                     unlist(), 3),
                      situation = rep(c("current", "proposed"), each = 101),
                      perc = rep(100 - (0:100), 2) )
  p <- gdata |> 
    ggplot() +
    aes_string(x = "loss", 
               y = "perc",
               col = "situation") +
    geom_line() +
    theme_bw() 
  
  if(loss_type[1] == "magnitude"){
    p <- p +  labs(title = "Loss magnitude chance of exceeding",
                  x = "Loss Magnitude", y = "")
  } else if (loss_type[1] == "events"){
    p <- p + labs(title = "Loss events chance of exceeding",
                  x = "Loss events", y = "")
  }
  
  
  p
  
  
}


# plot_chance(simdata, "magnitude")           

# plot_densities(simdata)
# plot_densities(simdata, loss_type = "magnitude")


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
