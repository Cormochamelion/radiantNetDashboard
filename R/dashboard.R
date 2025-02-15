#' Display a box indicating this content is currently under construction.
#'
#' @importFrom bslib value_box
#' @importFrom bsicons bs_icon
wip_box <- function() {
  value_box(
    title = "Work in progress",
    "Move along, nothing to see here.",
    theme = "text-gray",
    showcase = bs_icon("wrench")
  )
}

#' Generate a list containing server and UI components for the dashboard bundled
#' with a connection pool to the app's database.
#'
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
      dailyProductionServer("daily_consumption", db_pool)
    },
    ui = fluidPage(
      dailyProductionUI("daily_consumption", db_pool)
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
