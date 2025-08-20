utils::globalVariables(".")

#' All projects from FORMAS
#'
#' This requests all available projects data from FORMAS.
#' @return table with results
#' @importFrom httr GET status_code stop_for_status content
#' @export
formas_projects <- function() {
  message("All projects requested... patience during a few minutes, please...")
  route <- "https://data.formas.se/api/projekt/GetAll" %>% httr::GET()
  httr::stop_for_status(httr::status_code(route))
  projects <- route %>% httr::content(encoding = "UTF-8")
  purrr::map_df(projects, to_tbl) %>% adjust_datatypes()
}

#' Project details given one specific identifier
#' @param id a identifier for the project, usually the value of the "diarienummer" field
#' @return a table with results
#' @importFrom httr GET status_code stop_for_status content
#' @export
formas_project <- function(id) {
  stopifnot(length(id) == 1)
  route <- "https://data.formas.se/api/projekt/Get/%s" %>% sprintf(id) %>% httr::GET()
  httr::stop_for_status(httr::status_code(route))
  project <- route %>% httr::content(encoding = "UTF-8")
  project %>% to_tbl()
}

#' Description of fields included in responses
#' @return a table with fields described
#' @importFrom utils download.file
#' @importFrom readxl read_xlsx
#' @export
formas_fields <- function() {

  tf <- tempfile(fileext = "xlsx")

  "https://formas.se/download/18.18ce98f41763837064ac7bc/1607519074765/Variabler%20tabell.xlsx" %>%
    download.file(destfile = tf, quiet = TRUE)

  on.exit(unlink(tf))

  readxl::read_xlsx(tf, skip = 2)
}

simple_rapply <- function(x, fn) {
  if (is.list(x))
    lapply(x, simple_rapply, fn)
  else
    fn(x)
}

replace_nulls <- function(l)
  simple_rapply(l, function(x) if (is.null(x)) NA else x)

#' @importFrom dplyr as_tibble
to_tbl <- function(x)
  x %>% replace_nulls() %>% dplyr::as_tibble()

#' Projects with changes since a specific date (inclusive)
#' @param from_date a date, by default one week before the current date
#' @return a table with results
#' @importFrom lubridate ymd
#' @importFrom httr GET status_code stop_for_status content
#' @importFrom purrr map_df
#' @export
formas_projects_since <- function(from_date = Sys.Date() - 7) {
  d <- lubridate::ymd(from_date)
  route <- "https://data.formas.se/api/Projekt/getbychangeddate/%s" |> sprintf(d) |> httr::GET()
  httr::stop_for_status(httr::status_code(route))
  changes <- route |> httr::content(encoding = "UTF-8")
  if (length(changes) > 0) {
    changes |> purrr::map_df(to_tbl) |> adjust_datatypes()
  } else {
    tibble::tibble()
  }
}
