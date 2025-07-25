# -----------------------
# Author: Mike Ackerman
# Purpose: 
# 
# Created: May 28, 2025
#   Last Modified: July 9, 2025
# 
# Notes:

# clear environment
rm(list = ls())

# load necessary packages
library(here)
library(tidyverse)
library(sf)

# load carcass study streams
load(file = here("output/carcass_study_streams.rda"))

# load the prepped intrinsic potential and redd qrf datasets
load(file = here("data/spatial/prepped_snake_ip.rda"))

# convert streams_sf to long form for below analysis
streams_sf_long = streams_sf %>%
  pivot_longer(cols = c("sthd_popid", "chnk_popid"),
               names_to = "spc_code",
               values_to = "popid") %>%
  mutate(spc_code = str_sub(spc_code, 1, 4))

# create empty data frame to store results for each site
streams_ip_df = NULL
for (s in 1:nrow(streams_sf_long)) {
  
  # grab the site_code, spc_code, and polygons for each combination
  site_code = streams_sf_long[s,] %>% pull(site_code)
  spc_code  = streams_sf_long[s,] %>% pull(spc_code)
  
  stream_poly = get(load(paste0(here("output/stream_polygons"), "/", spc_code, "/", site_code, ".rda")))
  
  cat(paste0("Estimating available habitat within stream ", site_code, ", ", spc_code, ".\n"))
  
  # summarize intrinsic potential habitat for each site polygon
  stream_ip = ip_sf %>%
    st_intersection(stream_poly) %>%
    st_drop_geometry() %>%
    {
      if (spc_code == "chnk") {
        summarise(.,
                  length_wip_m = sum(length_w_chnk, na.rm = TRUE),
                  avg_width_m  = mean(wide_ww[chnk_wt != 0], na.rm = TRUE),
                  tot_length_m = sum(length_m, na.rm = TRUE),
                  tot_area_m2  = sum(area_ww, na.rm = TRUE),
                  area_non0_m2 = sum(area_ww[chnk_wt != 0], na.rm = TRUE),
                  area_wip_m2  = sum(area_w_chnk, na.rm = TRUE),
                  .groups = "drop")
      } else if (spc_code == "sthd") {
        summarise(.,
                  length_wip_m = sum(length_w_sthd, na.rm = TRUE),
                  avg_width_m  = mean(wide_bf[sthd_wt != 0], na.rm = TRUE),
                  tot_length_m = sum(length_m, na.rm = TRUE),
                  tot_area_m2  = sum(area_bf, na.rm = TRUE),
                  area_non0_m2 = sum(area_bf[sthd_wt != 0], na.rm = TRUE),
                  area_wip_m2  = sum(area_w_sthd, na.rm = TRUE),
                  .groups = "drop")
      }
    } %>%
    mutate(site_code = site_code,
           spc_code = spc_code) %>%
    select(site_code, spc_code, everything())
  
  # append ip results to site_ip_df
  streams_ip_df = bind_rows(streams_ip_df, stream_ip)
  
} # end site loop

# get available habitat for populations
load("C:/Git/SnakeRiverIPTDS/output/available_habitat/snake_river_iptds_and_pop_available_habitat.rda") ; rm(site_avail_hab, avail_hab_df)

#--------------------
# escapement goals
esc_goal_df = tribble(
  ~popid, ~low, ~med, ~high,
  "SCUMA",1000, 2500, 4000,
  "CRLOL", 500, 1250, 2000,
  "CRLAP", 750, 1875, 3000, 
  #"SCLAW", 500, 1250, 2000,
  #"CRLOC",1000, 2500, 4000,
  "SEMEA", 500, 1250, 2000,
  "SFSMA", 1000, 5000, 8000,
  "SFEFS", 1000, 2500, 4000,
  "CRSFC-s", 1000, 3000, 5000,
  "CRLOL-s",  500, 1500, 2500,
  "CRLMA-s", 1500, 4500, 7500,
  #"CRLOC-s", 1000, 3000, 5000,
  "CRSEL-s", 1000, 3000, 5000,
  "SFMAI-s", 1000, 3000, 5000
)

stream_order = c("Lolo",
                 "Red",
                 "American",
                 "Crooked",
                 "Newsome",
                 "Tenmile",
                 "OHara",
                 #"Meadow",
                 "Sweetwater",
                 "Mission",
                 "SFSR_Weir",
                 "Johnson_Weir")

# estimate proportion ip within potential study stream
carcass_ip_df = streams_ip_df %>%
  filter(spc_code == "chnk") %>%
  left_join(streams_sf_long %>% st_drop_geometry(),
            by = join_by(site_code, spc_code)) %>%
  left_join(pop_avail_hab %>%
              select(popid,
                     spc_code,
                     pop_area_wip_m2 = ip_area_w),
            by = join_by(popid, spc_code)) %>%
  mutate(p_ip = area_wip_m2 / pop_area_wip_m2) %>%
  left_join(esc_goal_df %>%
              select(popid, high),
            by = join_by(popid)) %>%
  mutate(est_hist_n = high * p_ip,
         est_hist_kg = case_when(
           spc_code == "chnk" ~ est_hist_n * 2.72,
           spc_code == "sthd" ~ est_hist_n * 1.89,
           TRUE ~ est_hist_n * NA
         ),
         kg_per_total_m2 = est_hist_kg / tot_area_m2,
         kg_per_wip_m2   = est_hist_kg / area_wip_m2) %>%
  select(site_code, 
         spc_code,
         popid,
         avg_width_m,
         high_esc_goal = high,
         p_ip,
         est_hist_n,
         est_hist_kg,
         kg_per_total_m2,
         kg_per_wip_m2) %>%
  filter(site_code %in% stream_order) %>%
  mutate(site_code = factor(site_code, levels = stream_order)) %>%
  arrange(site_code)

# write to .csv for sharing
write_csv(carcass_ip_df,
          file = here("output/carcass_ip_df.csv"))

# grab reach length
reaches_km = st_read(here("data/spatial/proposed_carcass_study_reaches.gpkg"), layer = "reaches") %>%
  st_drop_geometry() %>%
  select(stream, length_km)

#reach_length = 1000 # meters
treatment_df = carcass_ip_df %>%
  select(site_code,
         popid,
         avg_width_m,
         high_esc_goal,
         p_ip,
         est_hist_n,
         est_hist_kg) %>%
  left_join(reaches_km, 
            join_by("site_code" == "stream")) %>%
  mutate(treatment = case_when(
    site_code %in% c("Lolo", "Crooked") ~ "TH",
    site_code %in% c("Red", "Newsome")  ~ "TL",
    site_code %in% c("American", "Tenmile", "OHara", "Mission") ~ "C"
  )) %>%
  mutate(multiplier = case_when(
    treatment == "TH" ~ 3,
    treatment == "TL" ~ 1.5,
    treatment == "C"  ~ 0
  ),
  treatment_kg = est_hist_kg * multiplier,
  kg_m2 = treatment_kg / ((length_km * 1000) * avg_width_m))

sum(treatment_df$treatment_kg, na.rm = T)

### END SCRIPT