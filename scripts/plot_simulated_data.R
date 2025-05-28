# Purpose: Plot simulated data.
# Author: Ryan N. Kinzer
# Created: 28 May 2025

library(ggplot)

# plot simulated data
ggplot(data = design_long, aes(x = period, y = length, fill = treatment)) +
  geom_boxplot(alpha = 0.7, outlier.size = 0.5) +
  facet_wrap(~treatment) +
  labs(
    title = "Simulated Fish Lengths by Treatment and Period",
    y = "Fish Length (mm)",
    x = "Period"
  ) +
  theme_minimal()

ggplot(design_long, aes(x = period, y = length, color = treatment)) +
  geom_jitter(width = 0.2, alpha = 0.2) +
  stat_summary(fun.data = mean_cl_normal, geom = "errorbar", width = 0.1, size = 0.7) +  # CI bars
  stat_summary(fun = "mean", geom = "point", size = 2.5, shape = 21, fill = "black") +   # Mean point
  facet_wrap(~treatment) +
  labs(title = "Fish Length Distributions (BACI Design)",
       y = "Length (mm)", x = "Period") +
  theme_minimal()

ggplot(design_long, aes(x = length, fill = period)) +
  geom_density(alpha = 0.2) +
  facet_wrap(~treatment) +
  labs(title = "Fish Length Distributions (BACI Design)") +
  theme_minimal()