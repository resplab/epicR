# Returns results of Case Detection strategies

Returns results of Case Detection strategies

## Usage

``` r
test_case_detection(
  n_sim = 10000,
  p_of_CD = 0.1,
  min_age = 40,
  min_pack_years = 0,
  only_smokers = 0,
  CD_method = "CDQ195"
)
```

## Arguments

- n_sim:

  number of agents

- p_of_CD:

  probability of recieving case detection given that an agent meets the
  selection criteria

- min_age:

  minimum age that can recieve case detection

- min_pack_years:

  minimum pack years that can recieve case detection

- only_smokers:

  set to 1 if only smokers should recieve case detection

- CD_method:

  Choose one case detection method: CDQ195", "CDQ165", "FlowMeter",
  "FlowMeter_CDQ"

## Value

results of case detection strategy compared to no case detection
