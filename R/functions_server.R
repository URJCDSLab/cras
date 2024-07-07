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