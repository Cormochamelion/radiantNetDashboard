import::here("config", "config_get" = "get")
import::here("DBI", "dbConnect")
import::here("DT", "DTOutput", "renderDT")
import::here("pool", "dbPool", "poolClose")
import::here(
  "shiny",
  "dateInput",
  "fluidPage",
  "onStop",
  "plotOutput",
  "reactive",
  "renderPlot",
  "shinyApp"
)
import::here("RSQLite", "SQLite")

import::here(
  "database.R", "get_raw_data_df_date",
  .character_only = TRUE, .directory = "R"
)
import::here(
  "plots.R", "variable_plot", "wattage_plot",
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
      safe_date <- reactive(ensure_safe_date(input$raw_data_date, db_pool))
      daily_agg_df <- reactive(get_raw_data_df_date(db_pool, safe_date()))

      output$daily_state_of_charge <- renderPlot(
        variable_plot(daily_agg_df(), StateOfCharge)
      )

      output$daily_wattage <- renderPlot(wattage_plot(daily_agg_df()))

      output$daily_raw_df <- renderDT(daily_agg_df())
    },
    ui = fluidPage(
      {
        all_dates <- get_data_dates(db_pool)
        start_date <- all_dates[1]
        stop_date <- all_dates[length(all_dates)]

        full_date_range <- seq(start_date, stop_date, by = "day")
        no_data_dates <- setdiff(full_date_range, all_dates)

        dateInput(
          "raw_data_date",
          "Daily output",
          value = stop_date,
          min = start_date,
          max = stop_date,
          datesdisabled = no_data_dates
        )
      },
      plotOutput("daily_wattage"),
      plotOutput("daily_state_of_charge"),
      DTOutput("daily_raw_df")
    )
  )
}

#' Run the dashboard.
#' @param ... Arguments passed to [shiny::shinyApp()].
#' @export
radiantNetDashboard <- function(...) {
  components <- get_app_with_pool()
  shinyApp(components$ui, components$server, ...)
}
