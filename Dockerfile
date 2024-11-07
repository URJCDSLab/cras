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
    libharfbuzz-dev \
    libfribidi-dev \
    pandoc \
    pandoc-citeproc \
    curl \
    gdebi-core \
    cmake

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# Create app folder
RUN mkdir -p /app
WORKDIR /app

# Install quarto
ARG QUARTO_VERSION="1.6.33"
RUN curl -o quarto-linux-amd64.deb -L https://github.com/quarto-dev/quarto-cli/releases/download/v${QUARTO_VERSION}/quarto-${QUARTO_VERSION}-linux-amd64.deb
# RUN curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
RUN gdebi --non-interactive quarto-linux-amd64.deb
RUN quarto install tinytex

# copy necessary files
## app folder
##COPY /st-app ./st-app
## .Renviron file
##COPY /.Renviron ./.Renviron

# install devtools & renv packages
RUN Rscript -e 'install.packages("devtools")'
RUN Rscript -e 'install.packages("renv")'

# Copy renv.lock & restore
COPY /renv.lock ./renv.lock
RUN Rscript -e 'renv::restore()'

# Copy package necessary files
COPY DESCRIPTION NAMESPACE ./
COPY R/ R/
COPY data/ data/
COPY inst inst/
RUN Rscript -e 'library(devtools); install_local(".", build = TRUE, upgrade="never")'

## Preparation scripts and docs
#COPY /R ./R
#COPY /_doc ./_doc
# Run doc build scripts
#RUN Rscript '/R/render_manuals.R'

# run app on container start
CMD ["R", "-e", "cras::app_run(.port = 3804, .host = '0.0.0.0')"]

# expose port
EXPOSE 3804/tcp
