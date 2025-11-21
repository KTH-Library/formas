# Utility function to expand collapsed fields into tables

Utility function to expand collapsed fields into tables

## Usage

``` r
expand_with_id(x, id, id_col = "diarienummer", value_col = "values")
```

## Arguments

- x:

  the string vector to flatten

- id:

  the string vector of corresponding identifiers

- id_col:

  string with title for identifier column, Default: 'diarienummer'

- value_col:

  string with the title for the values column, Default: 'values'

## Value

table with flattened results
