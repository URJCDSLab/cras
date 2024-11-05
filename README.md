# CRAS: Cybersecurity Risk analysis and Simulation Shiny app



## Customise your app

- In `app.ui`:
  + Change title of sections and sidebars
  

## Template structure

- Typical R package structure (DESCRIPTION file, R folder)

- R functions

- inst/app/www folder for additional resources (JS, CSS, images, ...)

- Translation folder (if multilanguage)

> [!IMPORTANT]
> In order for the HTML to be generated with the embedded resources, the
> template `template_report_html.qmd` must be in the root of the package.
>
> Read [quarto-dev/quarto-cli/discussions/4041](https://github.com/quarto-dev/quarto-cli/discussions/4041) for details.

## My development workflow

- Use functions for rendering outputs and even for producing ui elements.

- Go to the terminal tab and run: `Rscript -e 'devtools::load_all();app_run()'`

- Stop and rerun in the terminal.
