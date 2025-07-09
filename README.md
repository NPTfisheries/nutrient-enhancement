# nutrient-enhancement

Nez Perce Tribe nutrient enhancement study and analysis. Does adding fish carcasses from hatchery broodstock and the Fish Buy Initiative increase natural productivity in historically under performing streams?

# Carcass-Based Nutrient Supplementation Study

This repository contains code, data structure, and documentation for the Nez Perce Tribe's experimental study evaluating the ecological effects of nutrient enhancement in tributary streams of the Clearwater River subbasin.

## 🎯 Objective

To determine whether adding salmon carcasses and nutrient-rich byproducts (e.g., from the Fish Buy Initiative) increases natural fish productivity, including juvenile growth and survival and overall food web support.

Specifically, we ask:

- Does nutrient enhancement improve fish growth or biomass relative to untreated control streams?
- Does nutrient supplementation delay juvenile emigration timing due to relieved density dependence?
- Does survival from natal rearing areas increase relative to control streams?
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
  - Juvenile fish growth, emigration timing, and survival
  - Water chemistry metrics (optional)
  - Primary (e.g., periphyton) and secondary (e.g., macroinvertebrate) density
- **Statistical Methods**:
  - Linear Mixed-Effects Models (`lme4` package in R)
  - Power Analysis using `simr`
  - Before-After-Control-Impact (BACI) contrasts (optional)
  - Trend visualization with `ggplot2`

See the [`scripts/`](./scripts) directory for R scripts related to:
- Treatment levels
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
```

## 🔬 Citation / Attribution

This project is led by the Nez Perce Tribe Department of Fisheries Resources Management.

If you use data, code, or findings from this repository, please cite appropriately. For academic or collaborative use, contact the project lead to request permission or coordinate use.

Kinzer, R.N., and Ackerman, M.@. Nez Perce Tribe DFRM. (2025). *Carcass-Based Nutrient Supplementation: Evaluating Benefits to Juvenile Salmonids in the Clearwater River - Study Design*. Nez Perce Tribe Fisheries Research Division. GitHub repository: https://github.com/NPTfisheries/nutrient-enhancement

## 📬 Contacts

**Ryan N. Kinzer**  
Fisheries Data Analyst, Research Division  
Nez Perce Tribe, Department of Fisheries Resources Management  
📧 [ryank@nezperce.org](mailto:ryank@nezperce.org)

**Mike W. Ackerman**  
Research Scientist, Research Division  
Nez Perce Tribe, Department of Fisheries Resources Management  
📧 [mikea@nezperce.org](mailto:mikea@nezperce.org)


