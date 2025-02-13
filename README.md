
<!-- README.md is generated from README.Rmd. Please edit that file -->
<!-- badges: start -->

[![R-CMD-check](https://github.com/Cormochamelion/radiantNetDashboard/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/Cormochamelion/radiantNetDashboard/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

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

There is a quick-start script at `dev/run_app.sh`. If you have an
existing database that you wish to connect to, set the environment
variables `R_CONFIG_ACTIVE` to “path” and `RADIANT_NET_DASHBOARD_PATH`
to where ever your DB is located.

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

## Development

### Tests

Run tests locally via

``` sh
R --vanilla -q -e "devtools::test()"
```

Alternatively run the tests inside a container like so:

``` sh
docker build --target test -t "radiant-net-dashboard" . && \
  docker run -it --rm --network=host \
    --name radiant-net-dashboard radiant-net-dashboard
```

### Building the README.md

The `README.Rmd` file is used to produce the `README.md` file. The
latter can be built from the former by running

``` sh
R --vanilla -q -e "devtools::build_readme()"
```
