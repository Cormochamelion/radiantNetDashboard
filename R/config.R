#' Extract package information from the citation.
#'
#' @param pkg_name A string giving the name of the package for which the info
#'   should be retrieved.
#' @importFrom utils citation
get_pkg_info <- function(pkg_name = "radiantNetDashboard") {
  pkg_info <- suppressWarnings(citation(pkg_name))
  pkg_author <- paste(c(
    pkg_info[[1]]$author$given, pkg_info[[1]]$author$family
  ))

  list(
    "author" = pkg_author,
    "title" = pkg_name
  )
}

#' Choose where to look for the generation and usage db.
#'
#' @param location One of
#'   * "default": The internal example DB.
#'   * "path": Whatever is specified in the `path` param.
#'   * "user": The users platform specific data dir, see
#'     [rappdirs::user_data_dir()].
#'   * "site": The machine-wide platform specific data dir, see
#'     [rappdirs::site_data_dir()].
#' @param path The path to be used when `location` == "path".
#' @param filename The filename of the DB to be used for
#'   `location %in% c("site", "user")`.
#'
#' @returns A path in string form to the chosen DB.
#'
#' @importFrom rappdirs user_data_dir site_data_dir
choose_db_path <- function(location = "default",
                           path = system.file(
                             "extdata/generation_and_usage.sqlite3",
                             package = "radiantNetDashboard"
                           ),
                           filename = "generation_and_usage.sqlite3") {
  # FIXME Distinguish between scraper and dashboard dirs.
  scraper_pkg_name <- "radiant-net-scraper"
  scraper_author_name <- "Cormochamelion"

  switch(location,
    "default" = system.file(
      paste0("extdata/", filename),
      package = "radiantNetDashboard"
    ),
    "path" = path,
    "user" = {
      dir <- user_data_dir(
        appauthor = scraper_author_name, appname = scraper_pkg_name
      )
      paste0(dir, "/", filename)
    },
    "site" = {
      dir <- site_data_dir(
        appauthor = scraper_author_name, appname = scraper_pkg_name
      )
      paste0(dir, "/", filename)
    },
    stop(paste("Unknown location type:", location))
  )
}

#' Get the configured path to the generation and usage DB, as determined by
#' `choose_db_path`.
get_config_db_path <- function() {
  default_config_path <- system.file(
    "extdata/config.yml",
    package = "radiantNetDashboard"
  )
  choose_db_path(
    location = config::get("gen_usage_db_loc", file = default_config_path),
    path = config::get("gen_usage_db_path", file = default_config_path)
  )
}
