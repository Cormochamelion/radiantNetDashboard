import::here("config", "config_get" = "get")
import::here("DBI", "dbConnect")
import::here("DT", "DTOutput", "renderDT")
import::here("pool", "dbPool")
import::here(
  "shiny",
  "dateInput",
  "fluidPage",
  "shinyApp"
)
import::here("RSQLite", "SQLite")

import::here(
  "database.R", "get_raw_data_df_date",
  .character_only = TRUE, .directory = "R"
)

dashboard_ui <- fluidPage(
  dateInput("raw_data_date", "Daily output"),
  DTOutput("daily_raw_df")
)

dashboard_server <- function(input, output) {
  db_conn <- dbPool(
    SQLite(),
    dbname = config_get("gen_usage_db_path")
  )
  output$daily_raw_df <- renderDT(
    get_raw_data_df_date(db_conn, input$raw_data_date)
  )
}

#' @export
radiantNetDashboard <- function(...) {
  shinyApp(dashboard_ui, dashboard_server, ...)
}
