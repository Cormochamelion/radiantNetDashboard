#' Get date matching a statistic with data from the raw_data table.
#'
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
#' @importFrom dplyr collect tbl
get_table_df <- function(table_name, db_conn) {
  db_conn %>%
    tbl(table_name) %>%
    collect()
}

get_daily_agg_df <- function(db_conn) get_table_df("daily_aggregated", db_conn)
get_raw_data_df <- function(db_conn) get_table_df("raw_data", db_conn)

#' Load the raw data df filtered for a given date into memory as a tibble.
#'
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
