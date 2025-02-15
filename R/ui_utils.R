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
