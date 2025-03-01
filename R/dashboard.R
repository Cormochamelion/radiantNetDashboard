#' Ensure a date is valid, else return the latest date with data.
#'
#' @param date A vector of Date objects of length either 1 or 0.
#' @param db_conn Connection to the generation & usage database.
#'
#' @returns An atomic Date vector of length 1.
ensure_safe_date <- function(date, db_conn) {
  if (length(date) != 1) {
    date <- get_raw_data_stat_date(db_conn, stat_fun = max)
  }
  date
}

#' @importFrom DT DTOutput renderDT
#' @importFrom pool dbPool poolClose
#' @importFrom shiny dateInput fluidPage onStop plotOutput reactive renderPlot
#' @importFrom RSQLite SQLite
get_app_with_pool <- function() {
  db_pool <- dbPool(
    SQLite(),
    dbname = get_config_db_path()
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
#' @importFrom shiny shinyApp
#' @export
radiant_net_dashboard <- function(...) {
  components <- get_app_with_pool()
  shinyApp(components$ui, components$server, ...)
}
