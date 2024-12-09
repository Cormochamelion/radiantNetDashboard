% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/database.R
\name{get_daily_agg_df}
\alias{get_daily_agg_df}
\title{Load the \code{daily_aggregated} table into memory as a tibble.}
\usage{
get_daily_agg_df(db_conn)
}
\arguments{
\item{db_conn}{Connection to the generation & usage database.}
}
\value{
A \code{\link[tibble:tibble]{tibble::tibble()}} of the \code{daily_aggregated} table.
}
\description{
Load the \code{daily_aggregated} table into memory as a tibble.
}
