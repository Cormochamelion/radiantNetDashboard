
<!-- README.md is generated from README.Rmd. Please edit that file -->

# radiantNetDashboard

<!-- badges: start -->
<!-- badges: end -->

Shiny app for displaying solar generation and usage data.

## Installation

You can install the development version of radiantNetDashboard from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("Cormochamelion/radiantNetDashboard")
```

## Local development

Run the app via

``` r
devtools::load_all()
shiny::runApp(radiantNetDashboard())
```

### Guix

Enter a development environment by running

``` sh
guix time-machine -C .guix/channels -- shell -m .guix/manifest.scm
```
