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

state_of_charge_plot <- function(data) {
  data %>%
    transmute_date_column() %>%
    ggplot(
      aes(date, StateOfCharge)
    ) +
    geom_line() +
    theme_minimal()
}