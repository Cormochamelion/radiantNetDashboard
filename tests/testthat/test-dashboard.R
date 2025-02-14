import::here("shinytest2", "AppDriver")

skip_if_not(
  "radiantNetDashboard" %in% installed.packages(),
  "radiantNetDashboard needs to be properly installed for shinytest2."
)

test_that(
  "the dashboard can be started without issue",
  {
    expect_no_error(AppDriver$new(radiantNetDashboard()))
  }
)
