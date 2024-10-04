import::here("config", "config_get" = "get")
import::here("DBI", "dbConnect")
import::here("DT", "DTOutput", "renderDT")
import::here("pool", "dbPool", "poolClose")
import::here(
  "shiny",
  "dateInput",
  "fluidPage",
  "onStop",
  "shinyApp"
)
import::here("RSQLite", "SQLite")

import::here(
  "database.R", "get_raw_data_df_date",
  .character_only = TRUE, .directory = "R"
)

get_app_with_pool <- function() {
  db_pool <- dbPool(
    SQLite(),
    dbname = config_get("gen_usage_db_path")
  )

  onStop(function() poolClose(db_pool))

  list(
    server = function(input, output) {
      output$daily_raw_df <- renderDT(
        get_raw_data_df_date(db_pool, input$raw_data_date)
      )
    },
    ui = fluidPage(
      {
        start_date <- get_raw_data_stat_date(db_pool, stat_fun = min)
        stop_date <- get_raw_data_stat_date(db_pool, stat_fun = max)

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
