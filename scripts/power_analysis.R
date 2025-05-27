# Purpose: power analysis for randomized complete block design.
# Author: Ryan N. Kinzer
# Created: 27 May 2025

library(tidyverse)
library(lme4)
library(simr)


#n_blocks <- 2         # Large vs Small spawning aggregates
#n_treatments <- 3     # Control, Low, High
n_streams <- 6        # 1 stream per treatment per block
n_years <- 3

blocks <- c('small', 'large')
treatments <- c('control', 'low', 'high')

low_growth <- 1.15
high_growth <- 1.20
effect_size <- c('Control' = 1, 'Low' = low_growth, 'High' = high_growth)

min_size <- 70
max_size <- 75
sd_mu <- 2 # std.dev of mean size
sd_size <- 5 # std.dev of annual size

design <- tibble(
  'stream' = 1:n_streams,
  'mu_size' = round(runif(n_streams, min_size, max_size)),
  'block' = factor(rep(blocks, each = 3)),
  'treatment' = factor(rep(treatments, 2)),
  'effect' = rep(effect_size, 2)
  ) %>%
  expand(nesting(stream, mu_size, block, treatment, effect), year = 1:n_years) %>%
  rowwise() %>%
  mutate(yr_mu_size = (effect * mu_size) + rnorm(1, 0, sd_mu))


design$id <- 1:n_streams
design$treatment <- factor(design$treatment, levels = c("control", "low", "high"))
design$stream <- interaction(design$block, design$treatment)

year = 1:n_years






design$size <- with(design,
                    stream_size)
design$growth <- with(design,
                        effect_size[Treatment] + rnorm(nrow(design), sd = 0.5) + rnorm(length(Stream), sd = 0.2)[as.numeric(Stream)]  # random stream effect
                        )


mod <- lmer(response ~ treatment + (1|stream), data = design)

# convert to a simr model
mod_sim <- extend(mod, along="year", n=n_years)

# power for detecting effect (overall F-test)
powerSim(mod_sim, nsim = 100, test = fixed("treatment", "Anova"))
