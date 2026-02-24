# Get list elements

Recursively extracts element names from a nested list structure.

## Usage

``` r
get_list_elements(ls, running_name = "")
```

## Arguments

- ls:

  A list to extract element names from

- running_name:

  Internal parameter for recursion (default: "")

## Value

A character vector of element names, with nested elements separated by
"\$" (e.g., "parent\$child\$grandchild").
