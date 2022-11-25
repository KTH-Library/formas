
<!-- README.md is generated from README.Rmd. Please edit that file -->

# formas

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![R-CMD-check](https://github.com/KTH-Library/formas/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/KTH-Library/formas/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of the R-package `formas` is to provide access to data from
[FORMAS](https://formas.se/en/start-page.html), a Swedish government
research council for sustainable development. This organization funds
research and innovation, develops strategies, performs analyses and
conducts evaluations. Areas of activity include the environment,
agricultural sciences and spatial planning.

FORMAS provides open data through an API about projects funded starting
from 2006. Data in the API is updated daily and may be used freely
without fees or other restrictions. This R package uses this [documented
API](https://formas.se/en/start-page/about-formas/what-we-do/open-data---api-containing-information-on-funded-projects/documentation-for-api-containing-information-on-funded-projects.html)
to make data available for use from R.

## Installation

You can install the development version of formas like so:

``` r
library(devtools)
install_github("formas", dependencies = TRUE)
```

## Example

This is a basic example which shows you how to get data:

``` r
library(formas)
library(dplyr)

all_projects <- formas_projects()

# total number of projects
nrow(all_projects)
#> [1] 7074

# available fields
names(all_projects)
#>  [1] "diarienummer"          "ärenderubrik"          "ärenderubrikEngelska" 
#>  [4] "projektbeskrivning"    "abstract"              "nyckelord"            
#>  [7] "scbForskningsämneKod"  "scbForskningsämneNamn" "formasÄmnesområde"    
#> [10] "hållbarhetsmål"        "diarienummerUtlysning" "utlysningTitel"       
#> [13] "beviljatDatum"         "projektStart"          "projektSlut"          
#> [16] "beviljatBidrag"        "medelsförvaltareNamn"  "medelsförvaltareOrgnr"
#> [19] "status"                "ansökansId"            "senastÄndrad"

# first few rows of latest changed projects
all_projects %>% 
  arrange(desc(`senastÄndrad`)) %>% 
  slice(1:3) %>% select(1:2, `senastÄndrad`, `beviljatBidrag`) %>%
  knitr::kable()
```

| diarienummer | ärenderubrik                                                                                          | senastÄndrad        | beviljatBidrag |
|:-------------|:------------------------------------------------------------------------------------------------------|:--------------------|---------------:|
| 2022-00307   | Inverkan av torka på vallproduktion och markens kolförråd i ett framtida klimat                       | 2022-11-23T00:00:00 |        3979052 |
| 2022-00317   | Mot en fossiloberoende mjölkproduktion i Sverige: teknisk strategi, barriärer och ekonomiska effekter | 2022-11-23T00:00:00 |        3998788 |
| 2022-00323   | Inomhusmiljön som motverkar luftburen smittspridning                                                  | 2022-11-23T00:00:00 |        3999000 |

Details for a specific project or changes from a date can also be
retrieved:

``` r
# details for one specific identifier only
formas_project("2022-00327") %>% glimpse()
#> Rows: 1
#> Columns: 21
#> $ diarienummer          <chr> "2022-00327"
#> $ ärenderubrik          <chr> "Moderna vetenskapliga metoder kan besvara en 10…
#> $ ärenderubrikEngelska  <chr> "Applying modern scientific methods to a century…
#> $ projektbeskrivning    <chr> "För att svenskt skogsbruk ska utvecklas emot me…
#> $ abstract              <chr> "The New EU Forest Strategy 2030, part of the Eu…
#> $ nyckelord             <chr> "Alternative forestry methods; Mycorrhizal fungi…
#> $ scbForskningsämneKod  <chr> "40104; 10611"
#> $ scbForskningsämneNamn <chr> " Skogsvetenskap;  Ekologi"
#> $ formasÄmnesområde     <chr> "Skogsbruk; Skogsforskning, övrigt; Ekologi"
#> $ hållbarhetsmål        <chr> "15 Ekosystem och biologisk mångfald"
#> $ diarienummerUtlysning <chr> "2022-00049"
#> $ utlysningTitel        <chr> "Årliga öppna utlysningen 2022"
#> $ beviljatDatum         <chr> "2022-11-23T00:00:00"
#> $ projektStart          <chr> "2023-01-01T00:00:00"
#> $ projektSlut           <chr> "2027-12-31T00:00:00"
#> $ beviljatBidrag        <int> 3996000
#> $ medelsförvaltareNamn  <chr> "Sveriges lantbruksuniversitet"
#> $ medelsförvaltareOrgnr <chr> "202100-2817"
#> $ status                <chr> "Öppen"
#> $ ansökansId            <int> 10716608
#> $ senastÄndrad          <chr> "2022-11-23T00:00:00"

# all changes since five days back
changes <- formas_projects_since(Sys.Date() - 5)

changes %>% select(1:2, `senastÄndrad`) %>% slice(1:5) %>% knitr::kable()
```

| diarienummer | ärenderubrik                                                                                                           | senastÄndrad        |
|:-------------|:-----------------------------------------------------------------------------------------------------------------------|:--------------------|
| 2019-01627   | Föreställningar om framtiden för att nedmontera det nutida: Styrning av en rättvis övergång i fossilintensiva regioner | 2022-11-21T00:00:00 |
| 2022-00307   | Inverkan av torka på vallproduktion och markens kolförråd i ett framtida klimat                                        | 2022-11-23T00:00:00 |
| 2022-00317   | Mot en fossiloberoende mjölkproduktion i Sverige: teknisk strategi, barriärer och ekonomiska effekter                  | 2022-11-23T00:00:00 |
| 2022-00323   | Inomhusmiljön som motverkar luftburen smittspridning                                                                   | 2022-11-23T00:00:00 |
| 2022-00327   | Moderna vetenskapliga metoder kan besvara en 100-årig gåta som stått i vägen för alternativa skogskötselmetoder        | 2022-11-23T00:00:00 |
