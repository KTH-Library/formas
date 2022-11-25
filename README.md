
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
#> 
#> Attaching package: 'dplyr'
#> The following objects are masked from 'package:stats':
#> 
#>     filter, lag
#> The following objects are masked from 'package:base':
#> 
#>     intersect, setdiff, setequal, union

all_projects <- formas_projects()
#> All projects requested... patience during a few minutes, please...

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
formas_project("2022-00327") %>% purrr::transpose()
#> [[1]]
#> [[1]]$diarienummer
#> [1] "2022-00327"
#> 
#> [[1]]$ärenderubrik
#> [1] "Moderna vetenskapliga metoder kan besvara en 100-årig gåta som stått i vägen för alternativa skogskötselmetoder"
#> 
#> [[1]]$ärenderubrikEngelska
#> [1] "Applying modern scientific methods to a century-old problem for alternative forest management"
#> 
#> [[1]]$projektbeskrivning
#> [1] "För att svenskt skogsbruk ska utvecklas emot mer hållbara metoder (enligt EUs New Forest Strategy 2030), så kan skötselmodellen med stora slutavverkningar, följt av markberedning of plantering, komma att förändras kraftigt. Det är väl dokumenterat att föryngringen intill hyggeskanter och kvarlämnade träd är avsevärt sämre än ute på hyggen, vilket också är ett av grundskälen till att man avverkar större ytor skog.Om policyförändringar eller nya certifieringskrav gynnar små hyggen eller alterativa skogsbruksformer, tex hyggesfritt skogsbruk, så blir kantzonspronlemet allt viktigare. Men den bakomliggande biologiska orsaken till kantzonseffekten är tyvärr inte känd, vilket hindrar utveklingen av praktiska lösningar som skulle förbättra föryngringen i alternativa skogbruksformer. I denna annsökan föreslår jag en ny hypotes för att förklara kantzonseffekten. Baserat på min egen forskning hypotetiserar jag att konkurrens om näring och undrjordiska nätverk av mykorrhizasvamp leder till den svaga föryngringen hos plantor intill stora träd. Det har visats att sammankoppling via svampmycel kan leda till att små värdväxter hålls små, medan större växtindivider premieras. I föryngringssammanhang innebär detta en svår situation för plantor i närheten av stora träd. Jag planerar en serie försök som testar hypotesen och, om den bekräftas, påbörjar arbetet att utvekla praktiska lösningar som kan förbättra föryngringen i skogskötselsystem med mindre sammanhängande kalavverkningsytor."
#> 
#> [[1]]$abstract
#> [1] "The New EU Forest Strategy 2030, part of the European Green Deal, states that clear-cutting of forests “should be approached with caution” and “avoided as much as possible”. This would greatly impact Swedish forestry, where clear-cut harvest is the norm, for instance by reduced maximum clear-cut size.Forest regeneration after harvest is an important phase in rotation forestry that could face considerable challenges in this context. It is well-documented that regeneration is poor around the edge of clear-cuts and near the base of retained old trees. This is an old silvicultural problem that has been minimized by clear-felling and site preparation methods that are becoming problematic due to their negative environmental effects.The current proposal is not advocating large clear-cuts. Instead, I propose to test a new hypothesis explaining the poor seedling performance near larger trees. Based on my own scientific work, the hypothesis states that mycorrhizal fungi hold the key to belowground competition dynamics that place seedlings at a disadvantage in the proximity to large trees. It has been shown that fungal connections can lead to small plants staying small, while larger individuals benefit. I propose a project to test this hypothesis and, if confirmed, to initiate the development of silvicultural methods to improve forest regeneration in smaller clear-cuts, gap thinning or under nearby trees."
#> 
#> [[1]]$nyckelord
#> [1] "Alternative forestry methods; Mycorrhizal fungi; Forest regeneration"
#> 
#> [[1]]$scbForskningsämneKod
#> [1] "40104; 10611"
#> 
#> [[1]]$scbForskningsämneNamn
#> [1] " Skogsvetenskap;  Ekologi"
#> 
#> [[1]]$formasÄmnesområde
#> [1] "Skogsbruk; Skogsforskning, övrigt; Ekologi"
#> 
#> [[1]]$hållbarhetsmål
#> [1] "15 Ekosystem och biologisk mångfald"
#> 
#> [[1]]$diarienummerUtlysning
#> [1] "2022-00049"
#> 
#> [[1]]$utlysningTitel
#> [1] "Årliga öppna utlysningen 2022"
#> 
#> [[1]]$beviljatDatum
#> [1] "2022-11-23T00:00:00"
#> 
#> [[1]]$projektStart
#> [1] "2023-01-01T00:00:00"
#> 
#> [[1]]$projektSlut
#> [1] "2027-12-31T00:00:00"
#> 
#> [[1]]$beviljatBidrag
#> [1] 3996000
#> 
#> [[1]]$medelsförvaltareNamn
#> [1] "Sveriges lantbruksuniversitet"
#> 
#> [[1]]$medelsförvaltareOrgnr
#> [1] "202100-2817"
#> 
#> [[1]]$status
#> [1] "Öppen"
#> 
#> [[1]]$ansökansId
#> [1] 10716608
#> 
#> [[1]]$senastÄndrad
#> [1] "2022-11-23T00:00:00"

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
