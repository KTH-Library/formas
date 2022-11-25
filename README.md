
<!-- README.md is generated from README.Rmd. Please edit that file -->

# formas

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
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

This is a basic example which shows you how to solve a common problem:

``` r
library(formas)
## basic example code
```
