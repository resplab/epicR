# Express matrix.

Takes a named matrix and writes the R code to populate it; useful for
generating input expressions from calibration results.

## Usage

``` r
express_matrix(mtx)
```

## Arguments

- mtx:

  a matrix

## Value

Invisibly returns the generated R code as a character string, also
outputs via message().
