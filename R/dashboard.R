import::here("config", "config_get" = "get")
import::here("DBI", "dbConnect")
import::here("DT", "DTOutput", "renderDT")
import::here("pool", "dbPool", "poolClose")
import::here(
  "shiny",
  "dateInput",
  "fluidPage",
  "onStop",
  "reactive",
  "shinyApp"
)
import::here("RSQLite", "SQLite")

import::here(
  "database.R", "get_raw_data_df_date",
  .character_only = TRUE, .directory = "R"
)

ensure_safe_date <- function(date, db_conn) {
  # Ensure a date is valid, else return the latest date with data.
  if (length(date) != 1) {
    date <- get_raw_data_stat_date(db_conn, stat_fun = max)
  }
  date
}

get_app_with_pool <- function() {
  db_pool <- dbPool(
    SQLite(),
    dbname = config_get("gen_usage_db_path")
  )

  onStop(function() poolClose(db_pool))

  list(
    server = function(input, output) {
      output$daily_raw_df <- renderDT(
        get_raw_data_df_date(
          db_pool,
          reactive(ensure_safe_date(input$raw_data_date, db_pool))()
        )
      )
    },
    ui = fluidPage(
      {
        all_dates <- get_data_dates(db_pool)
        start_date <- all_dates[1]
        stop_date <- all_dates[length(all_dates)]

        dateInput(
          "raw_data_date",
          "Daily output",
          value = stop_date,
          min = start_date,
          max = stop_date
        )
      },
      DTOutput("daily_raw_df")
    )
  )
}

#' @export
radiantNetDashboard <- function(...) {
  components <- get_app_with_pool()
  shinyApp(components$ui, components$server, ...)
}
