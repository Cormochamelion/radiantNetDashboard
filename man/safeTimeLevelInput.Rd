% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/aggregatedProduction.R
\name{safeTimeLevelInput}
\alias{safeTimeLevelInput}
\title{Create a selectInput with only those members of a level of time for which
there is data in a DB.}
\usage{
safeTimeLevelInput(inputId, db_pool, level = "month")
}
\arguments{
\item{inputId}{See same argument in \code{\link[shiny:dateInput]{shiny::dateInput()}}.}

\item{db_pool}{Pool of connections to the generation & usage database.}

\item{level}{The level of time for which unique dates should be retrieved.
One of "year" or "month"}
}
\description{
Create a selectInput with only those members of a level of time for which
there is data in a DB.
}
