% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aggregatedProduction.R
\name{aggregatedProductionServer}
\alias{aggregatedProductionServer}
\title{Server for the Shiny module displaying the data for production aggregated
on some time level.}
\usage{
aggregatedProductionServer(id, db_pool, level)
}
\arguments{
\item{id}{See same argument in \code{\link[shiny:moduleServer]{shiny::moduleServer()}}.}

\item{db_pool}{Pool of connections to the generation & usage database.}

\item{level}{What level of time the displayed data should be aggregated over.
One of "month", "year", or "total".}
}
\description{
Server for the Shiny module displaying the data for production aggregated
on some time level.
}
