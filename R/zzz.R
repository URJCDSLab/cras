.onLoad <- function(libname, pkgname) {
  resources <- system.file("app/www", package = "template.shiny.app")
  addResourcePath("www", resources)
}