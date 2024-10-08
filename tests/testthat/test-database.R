test_that(
  "daily_agg_df is loaded",
  {
    db_conn <- local_gen_db_conn()

    daily_agg_df <- get_daily_agg_df(db_conn)

    expect_in("data.frame", class(daily_agg_df))
  }
)

test_that(
  "daily_agg_df contains data",
  {
    db_conn <- local_gen_db_conn()

    daily_agg_df <- get_daily_agg_df(db_conn)

    expect_gt(nrow(daily_agg_df), 0)
  }
)

test_that(
  "raw_data_df is loaded",
  {
    db_conn <- local_gen_db_conn()

    daily_agg_df <- get_raw_data_df(db_conn)

    expect_in("data.frame", class(daily_agg_df))
  }
)

test_that(
  "raw_data_df contains data",
  {
    db_conn <- local_gen_db_conn()

    daily_agg_df <- get_raw_data_df(db_conn)

    expect_gt(nrow(daily_agg_df), 0)
  }
)

test_that(
  "get_raw_data_stat_date gives a date",
  {
    db_conn <- local_gen_db_conn()

    min_Date <- get_raw_data_stat_date(db_conn)

    expect_in("Date", class(min_Date))
  }
)

test_that(
  "get_raw_data_stat_date gives exactly one value",
  {
    db_conn <- local_gen_db_conn()

    min_Date <- get_raw_data_stat_date(db_conn)

    expect_length(min_Date, 1)
  }
)

test_that(
  "get_data_dates returns dates",
  {
    db_conn <- local_gen_db_conn()

    dates <- get_data_dates(db_conn)

    expect_in("Date", class(dates))
  }
)

test_that(
  "get_data_dates returns at least one value",
  {
    db_conn <- local_gen_db_conn()

    dates <- get_data_dates(db_conn)

    expect_gte(length(dates), 1)
  }
)

test_that(
  "get_raw_data_df_date returns a dataframe",
  {
    db_conn <- local_gen_db_conn()

    min_Date <- get_raw_data_stat_date(db_conn)
    date_df <- get_raw_data_df_date(db_conn, min_Date)

    expect_in("data.frame", class(date_df))
  }
)

test_that(
  "get_raw_data_df_date returns a dataframe with values",
  {
    db_conn <- local_gen_db_conn()

    min_Date <- get_raw_data_stat_date(db_conn)
    date_df <- get_raw_data_df_date(db_conn, min_Date)

    expect_gte(nrow(date_df), 1)
  }
)
