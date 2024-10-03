import::here("config", "config_get" = "get")
import::here("DBI", "dbConnect")
import::here("dplyr", "collect", "filter", "tbl")
import::here("lubridate", "as_date", "day", "month", "year")
import::here("magrittr", "%>%")
import::here("RSQLite", "SQLite")
import::here("withr", "with_db_connection")

DB_PATH <- config_get("gen_usage_db_path")

get_table_df <- function(db_path, table_name) {
  # Connect to the db at `db_path` and load `table_name` into memory as a
  # tibble.
  with_db_connection(
    list(db_conn = dbConnect(SQLite(), dbname = db_path)),
    {
      db_conn %>%
        tbl(table_name) %>%
        collect()
    }
  )
}

get_daily_agg_df <- function(db_path) get_table_df(db_path, "daily_aggregated")
get_raw_data_df <- function(db_path) get_table_df(db_path, "raw_data")

get_raw_data_df_date <- function(date, format = "%Y-%m-%d", db_path = DB_PATH) {
  # Connect to the db at `db_path` and load `table_name` into memory as a
  # tibble.
  with_db_connection(
    list(db_conn = dbConnect(SQLite(), dbname = db_path)),
    {
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
  )
}
