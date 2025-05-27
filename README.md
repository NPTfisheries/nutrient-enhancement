# nutrient-enhancement
Nez Perce Tribe nutrient enhancement study and analysis. Does adding fish carcasses from broodstock and fish buy-back sources increase natural productivity in historically underperforming streams?
# Nez Perce Tribe Nutrient Enhancement Study

This repository contains code, data structure, and documentation for the Nez Perce Tribe's experimental study evaluating the ecological effects of nutrient enhancement in tributary streams of the Snake River Basin.

## 🎯 Objective

To determine whether adding salmon carcasses and nutrient-rich byproducts (e.g., from the broodstock and fish buy-back program) increases natural fish productivity, including juvenile abundance, biomass, and overall food web support.

Specifically, we ask:

- Does nutrient enhancement improve fish abundance or biomass relative to untreated control streams?
- Are impacts proportional to the amount of nutrients added (1× vs. 2× historical productivity levels)?
- Are responses consistent across streams with different baseline productivity levels?

## 🧪 Study Design

- **Streams**: 6 total tributaries
  - 3 with historically high productivity
  - 3 with historically low productivity
- **Treatments**:
  - Control (no nutrients)
  - Low dose: 1× historical carcass loading
  - High dose: 2× historical carcass loading
- **Design**: Randomized Complete Block Design (RCBD), with productivity level as a blocking factor
- **Duration**: Pre-treatment baseline year + 3 years of treatment and monitoring

## 📊 Data & Analysis

- **Response Variables**:
  - Juvenile fish abundance and biomass
  - Macroinvertebrate density (optional)
  - Water quality metrics (optional)
- **Statistical Methods**:
  - Linear Mixed-Effects Models (`lme4` package in R)
  - Power Analysis using `simr`
  - Before-After-Control-Impact (BACI) contrasts (optional)
  - Trend visualization with `ggplot2`

See the [`scripts/`](./scripts) directory for R scripts related to:
- Data simulation
- Power analysis for RCBD
- Model fitting and diagnostics
- Visualization and summary plots

## 📁 Repository Structure

```text
/
├── README.md                 # Project overview and instructions
├── data/                     # Raw or simulated data inputs
├── scripts/                  # R scripts for analysis and visualization
├── figures/                  # Output plots and figures
└── docs/                     # Any write-ups, reports, or methods notes
