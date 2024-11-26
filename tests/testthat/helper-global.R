import::here("DBI", "dbConnect", "dbDisconnect")
import::here("RSQLite", "SQLite")
import::here("withr", "defer")

local_gen_db_conn <- function(env = parent.frame()) {
  db_path <- test_path("fixtures/generation_and_usage.sqlite3")
  db_conn <- dbConnect(SQLite(), dbname = db_path)

  defer(dbDisconnect(db_conn), env)

  return(db_conn)
}
