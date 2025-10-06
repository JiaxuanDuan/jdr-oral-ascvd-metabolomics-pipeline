# 🦷 Oral Disease ↔ ASCVD Metabolomics Pipeline (JDR Clinical & Translational Research)

**Code skeleton for reproducible analyses** accompanying the paper:

> *Bezamat M, Saeed A, McKennan C, Duan J, et al.*  
> **Oral Disease and Atherosclerosis May Be Associated with Overlapping Metabolic Pathways.**  
> *JDR Clinical & Translational Research.* 2025;10(3):315–319. DOI: 10.1177/23800844241280383

This repository provides a **clean, modular R workflow** to reproduce the data-processing and modeling logic used in the study, with safely **no participant-level data** included. It is meant as a **professional, well-documented** research pipeline that demonstrates engineering discipline (structure, naming, documentation) and scientific reproducibility.

> **Note:** This repository mirrors the analysis *logic* and structure only. It ships **no data**. See `data/README.md` and `config/config.yml` for how to wire local paths.

---

## Folder Layout

```
R/                      # function definitions
R/functions/            # helpers: I/O, QC, stats utilities
scripts/                # pipeline steps (01_... -> 07_...)
config/                 # YAML config (paths, toggles)
data/                   # your local data (excluded by .gitignore)
outputs/                # generated figures/tables (excluded by .gitignore)
.github/workflows/      # optional R CMD check / lint (disabled by default)
```

---

## Pipeline Overview

1. **01_ingest.R** — Load raw Metabolon matrices & study forms (FORM1/4/5/9/XX markers; dental CSV/XLSX).  
2. **02_preprocess.R** — Remove high-missing metabolites, log-transform, summarize missingness, mean-impute or `mice`.  
3. **03_covariates_merge.R** — Build analysis-ready dataset; factor encodings; derive Gingivitis/Periodontitis/DMFT/Edentulism; merge CIMT/CAC.  
4. **04_marginal_assoc.R** — Per-metabolite regressions with BH-FDR; QQ plots.  
5. **05_latent_factors.R** — Estimate latent confounders (eg. `sva::num.sv`, `bcv::bcv`, or `cate::cate`), **configurable `r`**.  
6. **06_modeling.R** — Adjusted models (logistic/linear) for oral phenotypes and subclinical ASCVD (CIMT/CAC); optional latent factors.  
7. **07_figures_tables.R** — Publication-quality figures/tables written to `outputs/`.

All scripts are **pure R** and documented to be readable by recruiters and collaborators.

---

## Getting Started

```r
# 0) Optional: reproducible environment
install.packages("renv")
renv::init()
renv::install(c("tidyverse","readxl","mice","pROC","sva","bcv","cate","yaml","cowplot","ggplot2","gridExtra"))

# 1) Configure paths & files (edit config/config.yml to match your local file names)
# 2) Run scripts in order: 01 -> 07
```

---

## Data & Compliance

- **No participant-level data** are included.  
- `data/` is git-ignored. Provide your own local copies of Heart/Dental SCORE extracts and Metabolon outputs.  
- If IRB or journal policy requires, keep the repository private.

---

## Citation

If you use this code skeleton or adapt parts of it, please cite the paper above and this repository.

---

## License

MIT (see `LICENSE`). If your institutional/journal policy differs, switch to “No license” or a restricted license.
