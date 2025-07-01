# -----------------------
# Author: Mike Ackerman
# Purpose: Export tentative treatment & control reaches to a .gpkg
# 
# Created: July 1, 2025
#   Last Modified: 
# 
# Notes:

# clear environment
rm(list = ls())

# load necessary packages
library(here)
library(tidyverse)
library(sf)
library(janitor)

# reach info from sherman sprague
reaches_sf = read_csv(file = here("data/spatial/prelim_treatment_control_reaches.csv"), show_col_types = F) %>%
  clean_names() %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

# write to .gpkg
st_write(reaches_sf, here("data/spatial/prelim_reaches.gpkg"), layer = "reach_pts", delete_layer = T)

# idfg sp/sum chnk spatial redd data
idfg_redd_sf = read_csv(file = here("data/spatial/idfg_chnk_redd_ifwis_export_20250701.csv"), show_col_types = F) %>%
  clean_names() %>%
  filter(!is.na(latitude) & !is.na(longitude)) %>%
  st_as_sf(coords = c("longitude", "latitude"), crs = 4326)

# write to .gpkg
st_write(idfg_redd_sf, here("data/spatial/idfg_redd_export_20250701.gpkg"), layer = "reach_pts", delete_layer = T)

### END SCRIPT