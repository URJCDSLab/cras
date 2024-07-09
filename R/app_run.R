#' Run shiny application
#'
#' @param description port port number
#'
#' @return the shiny app
#'
#' @import shiny
#' @import bslib
#' @import bsicons
#' @import shinyWidgets
#' @import mc2d
#' 
#' @export
#'
#' @examples
#' app_run()
app_run <- function(port = 3838){
  app_global()
  shiny::shinyApp(app_ui(), 
                  app_server, 
                  options = list(port = port))
}