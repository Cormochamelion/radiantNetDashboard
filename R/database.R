import::here("dplyr", "collect", "filter", "tbl", "select")
import::here("lubridate", "as_date", "day", "make_date", "month", "year")
import::here("magrittr", "%>%", "extract")
import::here("rlang", "enexpr", "expr")

get_raw_data_stat_date <- function(db_conn,
                                   stat_fun = min,
                                   fun_args = list(na.rm = TRUE)) {
  # Get date matching a statistic with data from the raw_data table.

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

get_table_df <- function(table_name, db_conn) {
  # Load `table_name` into memory as a tibble.
  db_conn %>%
    tbl(table_name) %>%
    collect()
}

get_daily_agg_df <- function(db_conn) get_table_df("daily_aggregated", db_conn)
get_raw_data_df <- function(db_conn) get_table_df("raw_data", db_conn)

get_raw_data_df_date <- function(db_conn, date, format = "%Y-%m-%d") {
  # Load `table_name` into memory as a tibble.
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
