#' Simulate a RCBD with pre and post periods.
#' @author Ryan N. Kinzer
#'
#' @param n_years number of years in the study
#' @param sample_size number of lengths collected during each period sampling event
#' @param low_effect percentage increase for low treatment; e.g., 1.05
#' @param high_effect percentage increase for high treatment; e.g., 1.10 
#'
#' @return
#' @export
#'
#' @examples
simulate_data <- function(n_years, sample_size, low_effect, high_effect){
  
  require(dplyr)
  
  n_streams <- 6 # 1 stream per treatment per block
  #n_years <- 3 # study years
  #sample_size <- 100 # fish sampled each period
  
  # size difference for streams
  stream_size_sd <- 2
  
  # experimental design
  blocks <- c('small', 'large')
  treatments <- c('control', 'low', 'high')
  effect_size <- c('control' = 1, 'low' = low_effect, 'high' = high_effect)
  
  # size difference for streams
  stream_size_sd <- 2
  
  # size difference for years
  year_size_sd <- 2
  
  # mean size
  mu_size <- 70
  sd_size <- 7
  period_growth <- 1.10
  
  # stream design
  design <- tibble(
    stream = 1:n_streams,
    block = factor(rep(blocks, each = n_streams/length(blocks))),
    treatment = factor(rep(treatments, n_streams/length(treatments))),
    stream_size = rnorm(n_streams, 0, stream_size_sd),
    treatment_effect = effect_size[as.character(treatment)]
  )
  
  # year x period effects
  time_effects <- tibble(
    year = 1:n_years,
    year_size = rnorm(n_years, 0, year_size_sd)
  ) %>%
    tidyr::expand(nesting(year, year_size), period = c('pre', 'post')) %>%
    mutate(period_effect = ifelse(period == 'pre', 1.0, period_growth))
  
  # full dataset
  design_long <- design %>%
    tidyr::expand(nesting(stream, stream_size, block, treatment, treatment_effect),
                  year = 1:n_years) %>%
    left_join(time_effects, by = "year", relationship = 'many-to-many') %>%
    mutate(
      mu_size = (mu_size + stream_size + year_size),
      mu_size = case_when(
        period == 'pre' ~ mu_size,
        period == 'post' ~ mu_size * period_effect * treatment_effect
      )
    ) %>%
    rowwise() %>%
    mutate(
      length = list(rnorm(sample_size, mean = mu_size, sd = sd_size))
    ) %>%
    ungroup() %>%
    #mutate(obs_mu = map_dbl(data, ~mean(.x))) %>%
    unnest(length)
  
  design_long <- design_long %>%
    mutate(
      stream = factor(stream),
      treatment = factor(treatment, levels = c('control', 'low', 'high')),
      period = factor(period, levels = c('pre', 'post')),
      block = factor(block),
      year = factor(year)
    )
  
  return(design_long)
}