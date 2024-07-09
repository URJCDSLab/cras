# Base image https://hub.docker.com/u/rocker/
FROM rocker/shiny:4.4.0

# system libraries of general use
## install debian packages
RUN apt-get update -qq && apt-get -y --no-install-recommends install \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libpq-dev \
    libssh2-1-dev \
    unixodbc-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libudunits2-dev \
    libgdal-dev \
    libglpk-dev \
    libmagick++-dev \
    pandoc \
    pandoc-citeproc \
    curl \
    gdebi-core \
    cmake

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# Install quarto
ARG QUARTO_VERSION="1.4.553"
RUN curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
# RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb

# copy necessary files
## app folder
##COPY /st-app ./st-app
## renv.lock file
COPY /renv.lock ./renv.lock
## .Renviron file
##COPY /.Renviron ./.Renviron

# install renv & restore packages
RUN Rscript -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_github("URJCDSLab/cras", dependencies = FALSE)'
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'renv::restore()'

## Preparation scripts and docs
#COPY /R ./R
#COPY /_doc ./_doc
# Run doc build scripts
#RUN Rscript '/R/render_manuals.R'

# run app on container start
CMD ["R", "-e", "cras::app_run(port = 3804)"]

# expose port
EXPOSE 3804


