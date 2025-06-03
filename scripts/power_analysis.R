# Purpose: power analysis for randomized complete block design.
# Author: Ryan N. Kinzer
# Created: 27 May 2025

library(tidyverse)
source('./R/simulate_data.R')
library(lme4)
library(lmerTest)
library(emmeans)


n_years = 3
sample_size <- 100

eloop = 10
iloop = 1000

low_effect <- seq(1.0, 1.1, length.out = eloop)
high_effect <- seq(1.1, 1.4, length.out = eloop)

low_results <- matrix(NA, ncol = eloop, nrow = iloop)
high_results <- matrix(NA, ncol = eloop, nrow = iloop)
singular_flags <- matrix(FALSE, nrow = iloop, ncol = eloop)

for(e in 1:eloop){
  for(i in 1:iloop){
    dat <- simulate_data(n_years, sample_size, low_effect[e], high_effect[e])
    mod <- lmer(length ~ treatment * period + year + (1|stream), data = dat)
    
    singular_flags[i, e] <- isSingular(mod, tol = 1e-4)
    
    coef_summary <- summary(mod)$coefficients
    low_results[i,e] <- coef_summary["treatmentlow:periodpost", "Pr(>|t|)"]
    high_results[i,e] <- coef_summary["treatmenthigh:periodpost", "Pr(>|t|)"]
    #low_results[i] <- summary(mod)$coefficients[7,5]
    #high_results[i] <- summary(mod)$coefficients[8,5]
  }
}

save(low_results, high_results, singular_flags, file = './data/power_results/n100.rda')

alpha <- .05 # prob. of a type I error (reject the Ho when the Ho is true)

power_df <- tibble(
  low_effect = low_effect,
  high_effect = high_effect,
  power_low = colMeans(low_results <= alpha), # prob. of detecting a true effect
  power_high = colMeans(high_results <= alpha),
  beta_low = 1 - power_low, # prob of a type II error (failing to reject Ho when Ho is false)
  beta_high = 1 - power_high,
  singular = colSums(singular_flags)
)


# Plot
ggplot(power_df) +
  geom_line(aes(x = low_effect-1, y = power_low), size = 1.2, color = "#0072B2") +
  geom_hline(yintercept = 0.80, linetype = "dashed", color = "gray40") +
  scale_y_continuous(limits = c(0, 1), breaks = seq(0, 1, 0.1)) +
  scale_x_continuous(labels = scales::percent_format(accuracy = 1)) +
  labs(
    title = "Statistical Power to Detect BACI Effect in Treatment Group",
    subtitle = "Simulated power using linear mixed-effects model with 3 years, 6 streams,\nand 100 fish sampled per stream in both pre- and post-treatment periods.",
    x = "Treatment Effect Size (Post-Treatment Growth Relative to Pre-Treatment Levels)",
    y = "Power (α = 0.05)"
  ) +
  theme_minimal(base_size = 14) +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    plot.subtitle = element_text(size = 13),
    axis.title = element_text(face = "bold"),
    panel.grid.minor = element_blank()
  )

ggsave('./figures/power_growth.png', width = 11, height = 8.5)

# 
# # fit individual model
# mod <- lmer(length ~ treatment * period + year + (1|stream), data = dat)
# summary(mod)
# 
# # estimated marginal means
# emmeans(mod, ~ treatment * period)
# 
# # contrasts (e.g., BACI effect)
# contrast(emmeans(mod, ~ treatment * period), interaction = "pairwise")
# 
# # marginal means by treatment and period
# emm <- emmeans(mod, ~ treatment * period)
# 
# # compare post vs. pre within each treatment
# pairs(emm, by = "treatment", adjust = "tukey")
# 
# # interaction (difference of differences)
# contrast(emm, interaction = "trt.vs.ctrl", by = "period")





library(simr)
# Extend model for simr
mod_sim <- makeLmer(length ~ treatment * period + (1|stream), fixef(mod), VarCorr(mod), data = design_long)

# Estimate power for interaction
powerSim(mod_sim, fixed("treatment:period", "anova"), nsim = 100)




