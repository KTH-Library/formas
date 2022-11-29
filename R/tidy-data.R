#' Utility function to expand collapsed fields into tables
#' @param x the string vector to flatten
#' @param id the string vector of corresponding identifiers
#' @param id_col string with title for identifier column, Default: 'diarienummer'
#' @param value_col string with the title for the values column, Default: 'values'
#' @return table with flattened results
#' @importFrom dplyr as_tibble mutate bind_cols bind_rows rename select everything filter
#' @importFrom stats setNames
#' @importFrom utils stack
#' @importFrom purrr map_dfr
#' @importFrom rlang `:=` `.data`
#' @export
expand_with_id <- function(x, id, id_col = "diarienummer", value_col = "values") {
  values <- ind <- NULL
  x %>% strsplit(split = ";\\s+") %>% setNames(., id) %>%
  utils::stack() %>% dplyr::filter(!is.na(values)) %>% dplyr::as_tibble() %>%
  dplyr::mutate(ind = as.character(ind), value = as.character(values)) %>%
  dplyr::rename({{ id_col }} := ind, {{ value_col }} := values) %>%
  dplyr::select(2:1)
}

#' @importFrom readr parse_datetime parse_integer
#' @importFrom dplyr mutate across all_of
adjust_datatypes <- function(x) {

  parse_dt <- function(x)
    readr::parse_datetime(as.character(x),
      format = "%Y-%m-%dT%H:%M:%S", trim_ws = TRUE)

  parse_d <- function(x)
    readr::parse_datetime(as.character(x),
      format = "%Y-%m-%dT%H:%M:%S", trim_ws = TRUE) %>%
    as.Date()

  parse_i <- function(x)
    readr::parse_integer(as.character(x))

  cols_dt <- c("beviljatDatum", "senast\u00c4ndrad")
  cols_d <- c("projektStart", "projektSlut")
  cols_int <- c("beviljatBidrag")

  x %>%
    mutate(across(all_of(cols_dt), .fns = parse_dt)) %>%
    mutate(across(all_of(cols_d), .fns = parse_d)) %>%
    mutate(across(all_of(cols_int), .fns = parse_i))

}

#' @importFrom rlang .data
lookup_tbls <- function(x) {

  scbs <-
    bind_cols(
      expand_with_id(x[["scbForsknings\u00e4mneKod"]], x$diarienummer,
          value_col = "scb_code"),
      expand_with_id(x[["scbForsknings\u00e4mneNamn"]], x$diarienummer,
          value_col = "scb_desc") %>%
        mutate(scb_desc = trimws(.data$scb_desc)) %>%
        select("scb_desc")
    )

  keyw <-
    with(x, expand_with_id(nyckelord, diarienummer,
        value_col = "keywords"))

  subj <-
    expand_with_id(x[["formas\u00c4mnesomr\u00e5de"]], x$diarienummer,
        value_col = "formas_subject")

  sdgs <-
    expand_with_id(x[["h\u00e5llbarhetsm\u00e5l"]], x$diarienummer,
        value_col = "sdg")

  list(
    scbs = scbs,
    keyw = keyw,
    subj = subj,
    sdgs = sdgs
  )

}

#' Lookup tables for fields with composite values
#'
#' Some fields contain values separated by "; ". This function creates
#' separate lookup tables for these fields.
#'
#' @param x the formas projects data frame to "normalize", by default the output from formas_projects fcn.
#' @return a list of data frames for fields with composite values
#' @export
formas_lookup_tables <- function(x = formas_projects()) {
  x %>% lookup_tbls()
}

str_lower_first <- function(x)
  gsub("(^[\\w|\u00c5\u00c4\u00d6])(.*?)", "\\L\\1\\E\\2", x, perl = TRUE)

str_strip_last <- function(x, chr = "*")
  gsub(sprintf("(.*?)[%s]$", chr), "\\1", x)

clean_field <- function(x)
  x %>% str_lower_first() %>% str_strip_last() %>% gsub("sCB", "scb", .)

# stringi::stri_escape_unicode(lookup) %>% gsub("\\\\n", "\n", .) %>% cat()
formas_field_lookup <- function() readr::read_csv(show_col_types = F,
"colname_to,colname_from
Id,diarienummer
TitleSv,\u00e4renderubrik
TitleEn,\u00e4renderubrikEngelska
Description,projektbeskrivning
Abstract,abstract
Keywords,nyckelord
ScbIds,scbForsknings\u00e4mneKod
Scbs,scbForsknings\u00e4mneNamn
FormasSubjects,formas\u00c4mnesomr\u00e5de
SDGs,h\u00e5llbarhetsm\u00e5l
AnnouncementDate,diarienummerUtlysning
AnnouncementTitle,utlysningTitel
AwardDate,beviljatDatum
FundingsStartDate,projektStart
FundingsEndDate,projektSlut
FundingsSek,beviljatBidrag
CoordinatingOrganisationName,medelsf\u00f6rvaltareNamn
CoordinatingOrganisationId,medelsf\u00f6rvaltareOrgnr
ApplicationId,ans\u00f6kansId
LastModified,senast\u00c4ndrad
Status,status
")

#' Rename fields to use English field names
#'
#' These field names match closer to field names used in SweCRIS
#'
#' @param x the data frame, usually resulting from a call to fcn formas_projects()
#' @importFrom stats na.omit
#' @export
rename_fields <- function(x) {

  map <- formas_field_lookup()

  lookup <- function(y) {
    m <- match(map$colname_from, y)
    y[!is.na(m)] <- map$colname_to[m[!is.na(m)]]
    as.character(na.omit(y))
  }

  colnames(x) <- lookup(colnames(x))
  x
}
