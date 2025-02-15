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

#' Server for the Shiny module displaying the data for daily production.
#'
#' @param id See same argument in [shiny::moduleServer()].
#' @param db_pool Pool of connections to the generation & usage database.
#'
#' @importFrom DT renderDT
#' @importFrom shiny moduleServer renderPlot reactive
dailyProductionServer <- function(id, db_pool) {
  moduleServer(
    id,
    function(input, output, ...) {
      safe_date <- reactive(ensure_safe_date(input$raw_data_date, db_pool))
      daily_agg_df <- reactive(get_raw_data_df_date(db_pool, safe_date()))

      output$daily_state_of_charge <- renderPlot(
        variable_plot(daily_agg_df(), StateOfCharge)
      )

      output$daily_wattage <- renderPlot(wattage_plot(daily_agg_df()))

      output$daily_raw_df <- renderDT(daily_agg_df())
    }
  )
}

#' UI elements for the Shiny module displaying the data for daily production.
#'
#' @param id See same argument in [shiny::moduleServer()].
#' @param db_pool Pool of connections to the generation & usage database.
#'
#' @importFrom bslib card card_header nav_panel navset_card_tab
#' @importFrom DT DTOutput
#' @importFrom shiny dateInput NS plotOutput tagList
dailyProductionUI <- function(id, db_pool) {
  tagList(
    {
      all_dates <- get_data_dates(db_pool)
      start_date <- all_dates[1]
      stop_date <- all_dates[length(all_dates)]

      full_date_range <- seq(start_date, stop_date, by = "day")
      no_data_dates <- setdiff(full_date_range, all_dates)

      dateInput(
        NS(id, "raw_data_date"),
        "Select date",
        value = stop_date,
        min = start_date,
        max = stop_date,
        datesdisabled = no_data_dates
      )
    },
    navset_card_tab(
      nav_panel(
        "Power & charge",
        plotOutput(NS(id, "daily_wattage")),
        plotOutput(NS(id, "daily_state_of_charge"))
      ),
      nav_panel(
        "Complete table",
        DTOutput(NS(id, "daily_raw_df"))
      ),
      full_screen = TRUE
    )
  )
}
