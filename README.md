# template_shiny_app

Project template for a shiny app.

## How to use the template

- Change the package name in DESCRIPTION in order to comply with standards.
Not underscores allowed

- You need, at least, the following packages for developing an app with this template (not to run the app):
  + roxygen2
  + testthat
  + pkgdown
  + usethis
  
the template is configured to use {renv}. You can `renv::restore()`, and then 
(optionally) update the packages to the last version, then `renv::snaphot()`.
Or you can `renv::deactivate)`.

Update the LICENCE info: `use_mit_license()`, `use_gpl3_license()`,
use_proprietary_licence("MY COMPANY")` or friends to pick a license

## Customise your app

- In `app.ui`:
  + Change title and window_title
  + Change title of sections and sidebars
  
- In the inst/app/www folder, include your own resources

## Template structure

- Typical R package structure (DESCRIPTION file, R folder)

- R functions

- inst/app/www folder for additional resources (JS, CSS, images, ...)

- Translation folder (if multilanguage)

## My development workflow

- Use functions for rendering outputs and even for producing ui elements.

- Go to the terminal tab and run: `Rscript -e 'devtools::load_all();app_run()'`

- Stop and rerun in the terminal.
