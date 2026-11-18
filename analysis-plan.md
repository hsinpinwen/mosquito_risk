
# Brainstorming data analysis plan

## From chicago dataset

- `result` is 'positive' or 'negative' (lowercase)
- One row per trap per week per species pool, so count rows with `result='positive'` for positive pools, not mosquitoes.
- Rows with null `test_id`/`result`/`species` are trap-weeks that caught 0 mosquitoes (nothing to test).
- Trapping runs roughly June to October.
- The source's latitude and longitude columns are swapped (latitude holds -87.x): geo already accounts for this. `test_date` carries a junk time component.
- Time period: 2007 to Present.


## Data prep
 
- Keep gravid traps only (about 96% of rows). It seems like other traps won't be as comparable and make up less of the data anyway (`trap_type == "GRAVID"`)
- Separate zero-collection records (no female Culex collected, nothing tested) from tested pools
  - Seems like we can't treat these as zero infection (consider removing)
- Recode `result` to 0/1. Use `number_of_mosquitoes` as pool size
    - Note to check its distribution and whether it has a cap
- Build week from `test_date` and/or inspect theChicago dataset's `week` column & make sure the weather week boundaries (ISO vs MMWR) match
- Consider restricting `weather` df to be from May-October
- See if variables in the model might have changed over time (i.e. has `trap_type` been in the dataset since the beginning, what variables are new, etc)
- Explore `season_year` and how to categorize


## Outcomes to consider
- (1) pool-level positive/negative --> per-mosquito infection probability
    - dataset pools mosquitos together (bigger pools = higher chance of positive result)
    - Model with a cloglog link or logit link?
        - and `offset(log(pool size))` [^1]
    - PoolTestR [^2]
- (2) Could also look at weekly citywide infection rate
    - via `binGroup::pooledBinom()` or `PoolTestR::getPrevalence()`
- (3) Could also look at peak weekly infection rate, week of first positive pool, etc

## Model considerations
- GAMs? especially with seasonality?


## Predictor variable considerations
- mosquito patterns are often influenced by lagged weather patterns. How should we decide which weather variables to lag / should we do a quick lit review for this?
- how to handle weather anamolies/outliers, and could this be a potential candidate for predictor in the model?

## Validation
tbd


## Sources

[^1]: PoolTestR: An R package for estimating prevalence and regression modelling for molecular xenomonitoring and other applications with pooled samples: https://www.sciencedirect.com/science/article/pii/S1364815221002012

[^2]: https://cran.r-project.org/web/packages/PoolTestR/index.html