suppressPackageStartupMessages({ library(tidyverse); library(readxl); source("R/functions/io.R") })
cfg <- cfg_read(); odir <- cfg$outputs_dir; ddir <- cfg$data_dir
load(file.path(odir, "02_preprocessed.RData")); load(file.path(odir, "01_forms.RData"))
find_value <- function(x) { x[which(!is.na(x))[1]] }
dat$GENDER <- factor(dat$GENDER); dat$RACE2 <- factor(dat$RACE2)
dat$PE_BP_CLASS <- dat$PE_SYSTOLIC <- NA
for (i in unique(form5$IDNUM)) { sel <- dat$CLIENT_IDENTIFIER == i; if (any(sel)) { dat$PE_BP_CLASS[sel] <- find_value(form5$PE_BP_CLASS[form5$IDNUM == i]); dat$PE_SYSTOLIC[sel] <- find_value(form5$PE_SYSTOLIC[form5$IDNUM == i]) } }
dat$PE_BP_CLASS <- factor(dat$PE_BP_CLASS)
dat$SCR_CURSMOKE <- NA; for (i in unique(form1$IDNUM)) { sel <- dat$CLIENT_IDENTIFIER == i; if (any(sel)) dat$SCR_CURSMOKE[sel] <- find_value(form1$SCR_CURSMOKE[form1$IDNUM == i]) }
dat$SCR_CURSMOKE[dat$SCR_CURSMOKE == ""] <- NA; dat$SCR_CURSMOKE <- factor(dat$SCR_CURSMOKE)
dat$DEMO_DIABETES <- NA; for (i in unique(form4$IDNUM)) { sel <- dat$CLIENT_IDENTIFIER == i; if (any(sel)) dat$DEMO_DIABETES[sel] <- find_value(form4$DEMO_DIABETES[form4$IDNUM == i]) }
dat$DEMO_DIABETES[dat$DEMO_DIABETES == ""] <- NA; dat$DEMO_DIABETES <- factor(dat$DEMO_DIABETES)
dat$HS_hsCRP <- dat$HS_IL6 <- NA; for (i in unique(markers$IDNUM)) { sel <- dat$CLIENT_IDENTIFIER == i; if (any(sel)) { dat$HS_hsCRP[sel] <- find_value(markers$HS_hsCRP[markers$IDNUM == i]); dat$HS_IL6[sel] <- find_value(markers$HS_IL6[markers$IDNUM == i]) } }
dat$HS_hsCRP.log <- log(dat$HS_hsCRP); dat$HS_IL6.log <- log(dat$HS_IL6)
dat$LAB_CHOL_VAP <- dat$LAB_HDL_VAP <- NA; for (i in unique(form9$IDNUM)) { sel <- dat$CLIENT_IDENTIFIER == i; if (any(sel)) { dat$LAB_CHOL_VAP[sel] <- find_value(form9$LAB_CHOL_VAP[form9$IDNUM == i]); dat$LAB_HDL_VAP[sel] <- find_value(form9$LAB_HDL_VAP[form9$IDNUM == i]) } }
dental <- as.data.frame(dental)
dat$Gingivitis <- dat$Periodontitis <- dat$DMFT <- dat$Edentulism <- NA
for (i in unique(dental$SCORE_ID)) { sel <- dat$CLIENT_IDENTIFIER == i; if (any(sel)) { dat$Gingivitis[sel] <- find_value(dental$Gingivitis[dental$SCORE_ID == i]); dat$Periodontitis[sel] <- find_value(dental$Periodontitis[dental$SCORE_ID == i]); dat$DMFT[sel] <- suppressWarnings(as.numeric(find_value(dental$DMFT[dental$SCORE_ID == i]))); dat$Edentulism[sel] <- find_value(dental$Edentulous[dental$SCORE_ID == i]) } }
dat$Gingivitis <- factor(dat$Gingivitis); dat$Periodontitis <- factor(dat$Periodontitis); dat$Edentulism <- factor(dat$Edentulism)
if (!is.null(cimt_cac)) dat <- dplyr::left_join(dat, cimt_cac, by = c("CLIENT_IDENTIFIER" = "ID"))
save(dat, file = file.path(odir, "03_dat_with_phenotypes.RData"))
