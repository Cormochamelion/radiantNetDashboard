#' Summarize aggregated daily data over a level of time.
#'
#' @param data Dataframe to summarize. Expected to contain a column of the time
#'  level *across* (i.e. one level below what is passed to `level`) which should
#'  be summarized and some columns starting with "kwh_" which will be
#'  summarized.
#' @param level The time level *on* which we want to summarize. Either "month",
#'  "year", or "total".
#'
#' @importFrom dplyr across all_of any_of group_by mutate rename starts_with
#'   summarize ungroup
#' @importFrom lubridate make_date
#' @importFrom stringr str_replace
#' @importFrom tidyr pivot_longer
#' @importFrom rlang :=
summarize_agg_data <- function(data, level) {
  date_levels <- c("day", "month", "year")

  group_levels <- switch(level,
    "month" = date_levels,
    "year" = date_levels %>%
      extract(seq(2, length(.))),
    "total" = date_levels %>%
      extract(seq(3, length(.)))
  )

  level_format <- switch(level,
    "month" = "%d. %b %Y",
    "year" = "%B %Y",
    "total" = "%Y",
    stop(
      paste0(
        "Unknown time level: ", level, ". Must be one of day, month, or year."
      )
    )
  )

  data %>%
    mutate(
      date = make_date(year = year, month = month, day = day)
    ) %>%
    group_by(across(all_of(group_levels))) %>%
    summarize(
      across(starts_with("kwh_"), \(x) mean(x, na.rm = TRUE)),
      date = min(date)
    ) %>%
    ungroup() %>%
    select(-any_of(date_levels)) %>%
    pivot_longer(
      -date,
      names_to = "wattage_type", values_to = "kwh"
    ) %>%
    mutate(
      wattage_type = str_replace(wattage_type, "^kwh_", ""),
      date = factor(format(date, level_format))
    )
}

#' Server for the Shiny module displaying the data for production aggregated
#' on some time level.
#'
#' @param id See same argument in [shiny::moduleServer()].
#' @param db_pool Pool of connections to the generation & usage database.
#' @param level What level of time the displayed data should be aggregated over.
#'  One of "month", "year", or "total".
#'
#' @importFrom DT renderDT
#' @importFrom shiny moduleServer renderPlot reactive
aggregatedProductionServer <- function(id, db_pool, level) {
  moduleServer(
    id,
    function(input, output, ...) {
      agg_df <- reactive(
        get_agg_df_date(db_pool, input$agg_date, level = level) %>%
          summarize_agg_data(level)
      )

      output$wattage <- renderPlot(wattage_col_plot(agg_df()))

      output$raw_df <- renderDT(agg_df())
    }
  )
}


#' Create a selectInput with only those members of a level of time for which
#' there is data in a DB.
#'
#' @param inputId See same argument in [shiny::dateInput()].
#' @param db_pool Pool of connections to the generation & usage database.
#' @param level The level of time for which unique dates should be retrieved.
#'    One of "year" or "month"
#'
#' @importFrom shiny selectInput
#' @importFrom rlang set_names
safeTimeLevelInput <- function(inputId, db_pool, level = "month") {
  # For total data we don't need a selection.
  if (level == "total") {
    return(NULL)
  }

  level_format <- switch(level,
    "month" = "%B %Y",
    "year" = "%Y",
    stop(
      paste0(
        "Unknown time level: ", level, ". Must be one of month or year."
      )
    )
  )

  level_members <- get_data_dates(db_pool, level = level) %>%
    set_names(format(., level_format))

  input_label <- switch(level,
    "month" = "Select month",
    "year" = "Select year",
    stop(
      paste0(
        "Unknown time level: ", level, ". Must be one of month or year."
      )
    )
  )

  selectInput(
    inputId,
    input_label,
    level_members
  )
}

#' UI elements for the Shiny module displaying the aggregated production data
#' over a level of time.
#'
#' @param id See same argument in [shiny::moduleServer()].
#' @param db_pool Pool of connections to the generation & usage database.
#' @param level What level of time the displayed data should be aggregated over.
#'  One of "month", "year", or "total".
#'
#' @importFrom bslib card card_header nav_panel navset_card_tab
#' @importFrom DT DTOutput
#' @importFrom shiny NS plotOutput tagList
aggregatedProductionUI <- function(id, db_pool, level) {
  ns <- NS(id)
  tagList(
    safeTimeLevelInput(ns("agg_date"), db_pool, level),
    navset_card_tab(
      nav_panel(
        "Power & charge",
        plotOutput(ns("wattage"))
      ),
      nav_panel(
        "Complete table",
        DTOutput(ns("raw_df"))
      ),
      full_screen = TRUE
    )
  )
}
