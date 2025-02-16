#' Display a navigation panel containing reports of daily, monthly, yearly,
#' and total consumption/production data.
#'
#' @param title Title of the entire navigation panel.
#' @param db_pool Pool of connections to the generation & usage database.
#' @param id_list Named list of ids connecting the UIs of each timeframe (daily,
#'  monthly, etc.) to their respective servers.
#'
#' @importFrom bslib nav_panel navset_pill_list
#' @importFrom shiny fluidPage
report_panel <- function(title, db_pool, id_list) {
  stopifnot(!is.null(names(id_list)))

  nav_panel(
    title,
    navset_pill_list(
      nav_panel(
        "Daily", fluidPage(dailyProductionUI(id_list$daily, db_pool))
      ),
      nav_panel(
        "Monthly",
        fluidPage(aggregatedProductionUI(id_list$monthly, db_pool, "month"))
      ),
      nav_panel(
        "Yearly",
        fluidPage(aggregatedProductionUI(id_list$yearly, db_pool, "year"))
      ),
      nav_panel(
        "Total",
        fluidPage(aggregatedProductionUI(id_list$total, db_pool, "total"))
      ),
      widths = c(2, 10)
    )
  )
}

#' Generate a list containing server and UI components for the dashboard bundled
#' with a connection pool to the app's database.
#'
#' @importFrom bslib page_navbar
#' @importFrom pool dbPool poolClose
#' @importFrom shiny onStop
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
      aggregatedProductionServer("monthly_production", db_pool, "month")
      aggregatedProductionServer("yearly_production", db_pool, "year")
      aggregatedProductionServer("total_production", db_pool, "total")
      dailyProductionServer("daily_production", db_pool)
    },
    ui = page_navbar(
      title = "RadiantNetDashboard",
      bg = "#4d4d4d",
      inverse = TRUE,
      report_panel(
        "Production/Consumption",
        db_pool,
        list(
          "daily" = "daily_production",
          "monthly" = "monthly_production",
          "yearly" = "yearly_production",
          "total" = "total_production"
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
