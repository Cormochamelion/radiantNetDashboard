import::here("DT", "DTOutput", "renderDT")
import::here(
  "shiny",
  "dateInput",
  "fluidPage",
  "shinyApp"
)

import::here(
  "database.R", "get_raw_data_df_date",
  .character_only = TRUE, .directory = "R"
)

dashboard_ui <- fluidPage(
  dateInput("raw_data_date", "Daily output"),
  DTOutput("daily_raw_df")
)

dashboard_server <- function(input, output) {
  output$daily_raw_df <- renderDT(get_raw_data_df_date(input$raw_data_date))
}

#' @export
radiantNetDashboard <- function(...) {
  shinyApp(dashboard_ui, dashboard_server, ...)
}
