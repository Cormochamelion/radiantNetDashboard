import::here("dplyr", "all_of", "case_match", "mutate", "select")
import::here("ggplot2", .all = TRUE)
import::here("lubridate", "make_datetime")
import::here("magrittr", "%>%")
import::here("rlang", "new_formula")
import::here("tidyr", "drop_na", "pivot_longer")

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
    labs(x = "Date") +
    theme_minimal()
}

wattage_plot <- function(data) {
  wattage_cols <- c(
    "To Battery" = "FromGenToBatt",
    "To Consumer" = "FromGenToConsumer",
    "To Grid" = "FromGenToGrid",
    "Total consumed" = "ToConsumer"
  )

  area_cols <- c("To Battery", "To Consumer", "To Grid")
  line_cols <- c("Total consumed")

  col_rename <- purrr::imap(
    wattage_cols,
    \(old_col, new_col) new_formula(old_col, new_col)
  )

  plot_data <- data %>%
    transmute_date_column() %>%
    pivot_longer(
      cols = all_of(as.vector(wattage_cols)),
      names_to = "wattage_type",
      values_to = "wattage"
    ) %>%
    mutate(wattage_type = case_match(wattage_type, !!!col_rename))

  area_data <- plot_data %>%
    filter(wattage_type %in% area_cols) %>%
    mutate(wattage_type = factor(wattage_type))

  line_data <- plot_data %>%
    filter(wattage_type %in% line_cols) %>%
    mutate(wattage_type = factor(wattage_type))

  ggplot(
    mapping = aes(date, wattage)
  ) +
    geom_area(data = area_data, aes(fill = wattage_type)) +
    geom_line(data = line_data, aes(color = wattage_type)) +
    labs(x = "Date", y = "Power [W]", color = NULL, fill = NULL) +
    theme_minimal() +
    theme(legend.position = "bottom")
}
