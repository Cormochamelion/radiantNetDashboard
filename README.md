
<!-- README.md is generated from README.Rmd. Please edit that file -->

# radiantNetDashboard

Shiny app for displaying solar generation and usage data.

## Installation

You can install the development version of radiantNetDashboard from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("Cormochamelion/radiantNetDashboard")
```

## Local development

There is a quick-start script at `dev/run_app.sh`.

### Within R

Simply run:

``` r
devtools::load_all()
shiny::runApp(radiantNetDashboard())
```

### Docker

There is a docker file available. Build & run an image with:

``` sh
docker build -t "radiant-net-dashboard" . && \
  docker run -it --rm --network=host \
    --name radiant-net-dashboard radiant-net-dashboard
```

### Guix

Enter a development environment by running

``` sh
guix time-machine -C .guix/channels.scm -- shell -m .guix/manifest.scm
```
