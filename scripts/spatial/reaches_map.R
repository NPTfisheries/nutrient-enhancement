# -----------------------
# Author: Mike Ackerman
# Purpose: Create a map of proposed study reaches
# 
# Created: July 1, 2025
#   Last Modified: July 9, 2025
# 
# Notes:

# clear environment
rm(list = ls())

# load necessary packages
library(here)
library(tidyverse)
library(sf)
library(tmap)

# read in proposed study reaches
reaches_sf = st_read(here("data/spatial/proposed_carcass_study_reaches.gpkg"), layer = "reaches") %>%
  st_transform(32611) %>%
  filter(!stream == "OHara") %>%
  mutate(treatment = case_when(
    stream == "Sweetwater" ~ "High",
    TRUE ~ treatment
  )) %>%
  mutate(
    block = factor(block, levels = c("High Production", "Low Production", "Lapwai Creek")),
    treatment = factor(treatment, levels = c("High", "Low", "Control"))
  )

# create map using tmap
reaches_p = tm_shape(reaches_sf) +
  tm_lines(col = "blue", lwd = 2) +
  tm_text("stream", size = 0.8, col = "white") +
  tm_basemap("Esri.WorldImagery") +
  tm_facets(rows = "block", columns = "treatment", free.coords = T)

# save tmap to file
tmap_save(reaches_p,
          filename = here("figures/reaches_map.png"),
          width = 8.5,
          height = 11,
          units = "in",
          dpi = 300)

### END SCRIPT
