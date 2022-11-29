
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

This is a basic example which shows you how to get data.

### All data at once

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

| diarienummer | ärenderubrik                                                                                              | senastÄndrad | beviljatBidrag |
|:-------------|:----------------------------------------------------------------------------------------------------------|:-------------|---------------:|
| 2019-02509   | Optimering i såglinjen via djupinlärning och multi-modal avbildning                                       | 2022-11-28   |        2132000 |
| 2017-01006   | Ligninets roll för saprotrof nedbrytning av växtmaterial och genes av organiskt material i boreala jordar | 2022-11-25   |        2992383 |
| 2017-01596   | Modifiering av autofagi för hållbar bredspektrumresisten mot potatissjukdomar                             | 2022-11-25   |        2997999 |

### Project details

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

| diarienummer | ärenderubrik                                                                                                     | senastÄndrad |
|:-------------|:-----------------------------------------------------------------------------------------------------------------|:-------------|
| 2017-01006   | Ligninets roll för saprotrof nedbrytning av växtmaterial och genes av organiskt material i boreala jordar        | 2022-11-25   |
| 2017-01596   | Modifiering av autofagi för hållbar bredspektrumresisten mot potatissjukdomar                                    | 2022-11-25   |
| 2018-00442   | En undersökning av styrelseformer genom ’landgrabbing’ av jordbruksmark                                          | 2022-11-25   |
| 2018-00682   | Ökar inomarts mångfald resiliens av ålgräsängar till klimatförändringar och fluktuationer?                       | 2022-11-25   |
| 2018-00812   | Vattenkvalitet påverkar vattenbrist - inverkan av färskvattnets försaltning på vattenbrist i globala torrområden | 2022-11-25   |

### Renaming fields

If you prefer to convert field names to something that better aligns
with SweCRIS field names, you can try this approach:

``` r

all_projects %>% rename_fields()
#> # A tibble: 7,074 × 21
#>    Id         TitleSv TitleEn Descr…¹ Abstr…² Keywo…³ ScbIds Scbs  Forma…⁴ SDGs 
#>    <chr>      <chr>   <chr>   <chr>   <chr>   <chr>   <chr>  <chr> <chr>   <chr>
#>  1 2006-00013 "Skoga… "Fores… "Dagen… "Today… <NA>    <NA>   <NA>  <NA>    <NA> 
#>  2 2006-00029 "Ansök… "-"     "Fakul…  <NA>   <NA>    <NA>   <NA>  <NA>    <NA> 
#>  3 2006-00039 "Utbyt… "Excha… "I den… "In th… <NA>    <NA>   <NA>  <NA>    <NA> 
#>  4 2006-00040 "2007 … "Trave… "Forsk…  <NA>   <NA>    <NA>   <NA>  <NA>    <NA> 
#>  5 2006-00041 "Lab-b… "Lab-v… "Ansök… "Dear … <NA>    <NA>   <NA>  <NA>    <NA> 
#>  6 2006-00042 "Delta… "Parti… "Inom … "Resul… <NA>    <NA>   <NA>  <NA>    <NA> 
#>  7 2006-00049 "Works… "Works… "För a… "In or… <NA>    <NA>   <NA>  <NA>    <NA> 
#>  8 2006-00053 "Reseb… "Appli… "Reseb… "Bilag… <NA>    <NA>   <NA>  <NA>    <NA> 
#>  9 2006-00060 "Polit… "Polit… "Polit… "Proje… <NA>    <NA>   <NA>  <NA>    <NA> 
#> 10 2006-00062 "Tundr… "Tundr… "Mosso… "Bryop… <NA>    <NA>   <NA>  <NA>    <NA> 
#> # … with 7,064 more rows, 11 more variables: AnnouncementDate <chr>,
#> #   AnnouncementTitle <chr>, AwardDate <dttm>, FundingsStartDate <date>,
#> #   FundingsEndDate <date>, FundingsSek <int>,
#> #   CoordinatingOrganisationName <chr>, CoordinatingOrganisationId <chr>,
#> #   LastModified <chr>, Status <int>, ApplicationId <dttm>, and abbreviated
#> #   variable names ¹​Description, ²​Abstract, ³​Keywords, ⁴​FormasSubjects
```

### Composite fields as tables

Some fields contain multiple `"; "`-separated values and these can be
expanded into separate lookup tables.

``` r
tbls <- all_projects %>% formas_lookup_tables()

# we here also rename the fields
tbls %>% purrr::map(rename_fields)
#> $scbs
#> # A tibble: 9,478 × 3
#>    Id         scb_code scb_desc                    
#>    <chr>      <chr>    <chr>                       
#>  1 2011-01770 40303    Klinisk vetenskap           
#>  2 2011-01771 20102    Byggproduktion              
#>  3 2011-01771 20103    Husbyggnad                  
#>  4 2011-01771 20104    Infrastrukturteknik         
#>  5 2011-01773 40101    Jordbruksvetenskap          
#>  6 2011-01773 40106    Markvetenskap               
#>  7 2011-01774 20199    Annan samhällsbyggnadsteknik
#>  8 2011-01775 10615    Evolutionsbiologi           
#>  9 2011-01776 50201    Nationalekonomi             
#> 10 2011-01777 10611    Ekologi                     
#> # … with 9,468 more rows
#> 
#> $keyw
#> # A tibble: 10,606 × 2
#>    Id         keywords            
#>    <chr>      <chr>               
#>  1 2015-10002 climate change      
#>  2 2015-10002 tropical forests    
#>  3 2015-10009 Flyktingmottaging   
#>  4 2015-10009 Välfärdsstat        
#>  5 2015-10009 Kommuner            
#>  6 2016-00006 Lake Reservoirs     
#>  7 2016-00006 Water Quality       
#>  8 2016-00006 Monitoring Forecasts
#>  9 2016-00007 vattenrening        
#> 10 2016-00007 biogeokemi          
#> # … with 10,596 more rows
#> 
#> $subj
#> # A tibble: 5,829 × 2
#>    Id         formas_subject                
#>    <chr>      <chr>                         
#>  1 2009-00590 Skogsbruk                     
#>  2 2011-00055 Bebyggelse, övrigt            
#>  3 2011-00072 Ekonomi                       
#>  4 2011-00074 Bebyggelse, övrigt            
#>  5 2011-00075 Bygg och produktionsteknik    
#>  6 2011-00117 Faunavård                     
#>  7 2011-00758 Miljövård                     
#>  8 2011-00761 Jordbruksforskning, övrigt    
#>  9 2011-01473 Klimat- och atmosfärsforskning
#> 10 2011-01568 Faunavård                     
#> # … with 5,819 more rows
#> 
#> $sdgs
#> # A tibble: 6,102 × 2
#>    Id         sdg                                                
#>    <chr>      <chr>                                              
#>  1 2017-00306 09 Hållbar industri, innovationer och infrastruktur
#>  2 2017-00306 11 Hållbara städer och samhällen                   
#>  3 2017-00308 09 Hållbar industri, innovationer och infrastruktur
#>  4 2017-00308 11 Hållbara städer och samhällen                   
#>  5 2017-00315 11 Hållbara städer och samhällen                   
#>  6 2017-00317 09 Hållbar industri, innovationer och infrastruktur
#>  7 2017-00317 11 Hållbara städer och samhällen                   
#>  8 2017-00323 08 Anständiga arbetsvillkor och ekonomisk tillväxt 
#>  9 2017-00323 09 Hållbar industri, innovationer och infrastruktur
#> 10 2017-00323 11 Hållbara städer och samhällen                   
#> # … with 6,092 more rows

# at this point all_projects and tbls could be persisted to a database
```
