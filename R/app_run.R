#' Run shiny application
#'
#' @param port port number
#' @param host host ip
#'
#' @return the shiny app
#' @export
#'
#' @examples
#' app_run()
app_run <- function(.port = 3838, .host = "0.0.0.0") {
  thematic::thematic_shiny(font = "auto")
  shiny::shinyApp(app_ui(),
                  app_server,
                  options = list(port = .port,
                                 host = .host))
}
