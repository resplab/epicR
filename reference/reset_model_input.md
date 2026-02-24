# Reset the cached model input

Forces the default model_input to be reloaded on next access. Useful
after modifying config files.

## Usage

``` r
reset_model_input()
```

## Value

No return value, called for side effects (clears the model input cache).
