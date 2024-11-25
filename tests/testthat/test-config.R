import::here("magrittr", "%>%", "extract")
import::here("purrr", "map_vec", "map2_vec")

# Testing choose_db_paths results directly is a bit of a hassle since they are
# platform dependent. So for now I'm content just checking that it produces
# different output for different platform dependent params.
test_that(
  paste(
    "`choose_db_path` returns different results for different platform",
    "location params"
  ),
  {
    platform_loc_types <- c("user", "site")

    platform_loc_types %>%
      map_vec(\(loc_type) choose_db_path(loc_type)) %>%
      {
        if (length(.) < 2) stop("I need at least two values for this.")

        lead_indices <- seq_len(length(.) - 1)
        lead <- extract(., lead_indices)
        lag <- extract(., lead_indices + 1)
        map2_vec(lead, lag, `==`)
      } %>%
      any() %>%
      expect_false()
  }
)


test_that(
  "`choose_db_path` errors on unknown location type",
  {
    expect_error(choose_db_path(location = "foo"))
  }
)


test_that(
  "`choose_db_path` manages to return an explicitly specified path",
  {
    path <- "/foo/bar/blah.sqlite3"
    res_path <- choose_db_path(location = "path", path = path)
    expect_equal(path, res_path)
  }
)


test_that(
  "`choose_db_path` returns an existing path by default",
  {
    expect_true(file.exists(choose_db_path()))
  }
)

test_that(
  "`get_config_db_path` returns an existing path",
  {
    expect_true(file.exists(get_config_db_path()))
  }
)
