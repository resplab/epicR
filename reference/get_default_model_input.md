# Get the default model input (lazy initialization)

This function provides access to the default model_input object. The
model_input is lazily initialized on first access to avoid embedding
paths during package installation.

## Usage

``` r
get_default_model_input()
```

## Value

The default model input list
