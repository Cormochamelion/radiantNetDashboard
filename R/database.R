import::here("dplyr", "collect", "filter", "tbl")
import::here("lubridate", "as_date", "day", "month", "year")
import::here("magrittr", "%>%")

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
