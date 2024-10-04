import::here("dplyr", "mutate", "select")
import::here("ggplot2", .all = TRUE)
import::here("lubridate", "make_datetime")
import::here("magrittr", "%>%")

transmute_date_column <- function(data) {
  data %>%
    mutate(
      date = make_datetime(year, month, day, hour, minute),
      .keep = "unused"
    ) %>%
    select(-time)
}

variable_plot <- function(data, variable) {
  data %>%
    transmute_date_column() %>%
    ggplot(
      aes(date, {{ variable }})
    ) +
    geom_line() +
    theme_minimal()
}