# Lookup tables for fields with composite values

Some fields contain values separated by "; ". This function creates
separate lookup tables for these fields.

## Usage

``` r
formas_lookup_tables(x = formas_projects())
```

## Arguments

- x:

  the formas projects data frame to "normalize", by default the output
  from formas_projects fcn.

## Value

a list of data frames for fields with composite values
