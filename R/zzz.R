.onLoad <- function(libname, pkgname) {
  resources <- system.file("app/www", package = "cras")
  addResourcePath("www", resources)
}
