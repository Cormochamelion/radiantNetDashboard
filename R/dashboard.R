#' Generate a list containing server and UI components for the dashboard bundled
#' with a connection pool to the app's database.
#'
#' @importFrom bslib nav_panel navset_pill_list page_navbar
#' @importFrom pool dbPool poolClose
#' @importFrom shiny fluidPage onStop
#' @importFrom RSQLite SQLite
get_app_with_pool <- function() {
  db_pool <- dbPool(
    SQLite(),
    dbname = get_config_db_path()
  )

  onStop(function() poolClose(db_pool))

  list(
    server = function(input, output) {
      dailyProductionServer("daily_production", db_pool)
    },
    ui = page_navbar(
      title = "RadiantNetDashboard",
      bg = "#4d4d4d",
      inverse = TRUE,
      nav_panel(
        "Production/Consumption",
        navset_pill_list(
          nav_panel(
            "Daily", fluidPage(dailyProductionUI("daily_production", db_pool))
          ),
          widths = c(2, 10)
        )
      )
    )
  )
}

#' Run the dashboard.
#' @param ... Arguments passed to [shiny::shinyApp()].
#' @importFrom shiny shinyApp
#' @export
radiantNetDashboard <- function(...) {
  components <- get_app_with_pool()
  shinyApp(components$ui, components$server, ...)
}
