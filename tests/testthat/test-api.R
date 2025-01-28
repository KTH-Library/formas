test_that("Retrieving all projects works", {
  skip_on_ci()
  # get all projects
  pa <- formas_projects()
  is_valid <- nrow(pa) > 7000 & ncol(pa) == 21
  expect_true(is_valid)
})

test_that("Getting FORMAS fields works", {
  # get field map
  ff <- formas_fields()
  is_valid <- nrow(ff) == 19 & ncol(ff) == 4
  expect_true(is_valid)
})

test_that("Getting project details works", {
  # details for a specific project
  ids <- c("2006-00013", "2006-00029", "2006-00039", "2006-00040", "2006-00041")
  fp <- formas_project(ids[1])
  is_valid <- nrow(fp) == 1 & ncol(fp) == 21
  expect_true(is_valid)
})

test_that("Getting changed projects since last two days work", {
  # all projects changed since two days
  ps <- formas_projects_since(from_date = Sys.Date() - 5)
  is_valid <- is.data.frame(ps) & nrow(ps) >= 1 & ncol(ps) == 21
  expect_true(is_valid)
})

