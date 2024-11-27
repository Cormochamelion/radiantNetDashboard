#' Get date matching a statistic with data from the raw_data table.
#'
#' @param db_conn Connection to the generation & usage database.
#' @param stat_fun Function taking a vector and returning an atomic value. Used
#'   to select a matching date by applying the function to the `time`
#'   (timestamp) column of the `raw_data` table in the DB.
#' @param fun_args Arguments to `stat_fun` besides the `raw_data` column.
#'
#' @returns A Date object as returned by [lubridate::make_date()].
#'
#' @import dbplyr
#' @importFrom dplyr collect filter tbl select
#' @importFrom lubridate make_date
#' @importFrom magrittr extract
#' @importFrom rlang enexpr expr
get_raw_data_stat_date <- function(db_conn,
                                   stat_fun = min,
                                   fun_args = list(na.rm = TRUE)) {
  # Since dbplyr::filter.tbl_lazy converts functions to SQL, I can't
  # smply go `filter(time == stat_fun(time))`, as it tries to convert
  # stat_fun literally. I need to construct my own call to filter with
  # stat_fun injected.
  enq_stat_fun <- enexpr(stat_fun)
  filter_expr <- expr(filter(., time == (!!enq_stat_fun)(time, !!!fun_args)))

  db_conn %>%
    tbl("raw_data") %>%
    {
      eval(filter_expr)
    } %>%
    # Should be only one row.
    collect() %>%
    select(year, month, day) %>%
    extract(1, ) %>%
    with(
      make_date(year, month, day)
    )
}

#' Get all dates with data available.
#'
#' @param db_conn Connection to the generation & usage database.
#'
#' @returns A vector of Date objects representing all dates with aggregated data
#'   in the DB.
#'
#' @import dbplyr
#' @importFrom dplyr arrange collect tbl select
#' @importFrom lubridate make_date
#' @importFrom purrr map_vec pmap
#' @importFrom rlang list2
get_data_dates <- function(db_conn) {
  db_conn %>%
    tbl("daily_aggregated") %>%
    select(year, month, day) %>%
    arrange(year, month, day) %>%
    collect() %>%
    # Convert to list of rows.
    pmap(list2) %>%
    map_vec(\(row) with(row, make_date(year, month, day)))
}

#' Load `table_name` into memory as a tibble.
#'
#' @param table_name Name of the table in the DB which should be retrieved.
#' @param db_conn Connection to the generation & usage database.
#'
#' @returns A [tibble::tibble()] of the table with `table_name`.
#'
#' @import dbplyr
#' @importFrom dplyr collect tbl
get_table_df <- function(table_name, db_conn) {
  db_conn %>%
    tbl(table_name) %>%
    collect()
}

#' Load the `daily_aggregated` table into memory as a tibble.
#'
#' @param db_conn Connection to the generation & usage database.
#'
#' @returns A [tibble::tibble()] of the `daily_aggregated` table.
get_daily_agg_df <- function(db_conn) get_table_df("daily_aggregated", db_conn)

#' Load the `raw_data` table into memory as a tibble.
#'
#' @param db_conn Connection to the generation & usage database.
#'
#' @returns A [tibble::tibble()] of the `raw_data` table.
get_raw_data_df <- function(db_conn) get_table_df("raw_data", db_conn)

#' Load the raw data df filtered for a given date into memory as a tibble.
#'
#' @param db_conn Connection to the generation & usage database.
#' @param date String describing the date for which data should be retrieved.
#'   parsed into a date object internally.
#' @param format Format of the `date` string, for parsing it to a date object.
#'   Parsing is done via [base::strptime()].
#'
#' @returns A [tibble::tibble()] of the `raw_data` table with only the data for
#'   the specified date.
#'
#' @import dbplyr
#' @importFrom dplyr collect filter tbl
#' @importFrom lubridate day month year
get_raw_data_df_date <- function(db_conn, date, format = "%Y-%m-%d") {
  parsed_date <- strptime(date, format)

  date_components <- list(
    day = day(parsed_date),
    month = month(parsed_date),
    year = year(parsed_date)
  )

  db_conn %>%
    tbl("raw_data") %>%
    filter(
      day == date_components$day,
      month == date_components$month,
      year == date_components$year
    ) %>%
    collect()
}
