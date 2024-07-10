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
  sim_events_0 <- round(sapply(1:n, function(x){
    rpert(1, 
          min0e,
          mode0e,
          max0e)
  }))
  sim_events_1 <- round(sapply(1:n, function(x){
    rpert(1, 
          min1e,
          mode1e,
          max1e)
  }))
  
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
  }
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
# 

