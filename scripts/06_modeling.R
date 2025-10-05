suppressPackageStartupMessages({ library(tidyverse); library(pROC) })
load("outputs/03_dat_with_phenotypes.RData")

set.seed(100)
n <- nrow(dat); idx <- sample(n, floor(n * 0.7))
train <- dat[idx, ]; test <- dat[-idx, ]

# Baseline logistic model for Gingivitis (clinical covariates only)
m_base <- glm(as.factor(Gingivitis) ~ AGE + GENDER + RACE2 + PE_BP_CLASS + PE_SYSTOLIC +
                SCR_CURSMOKE + DEMO_DIABETES + HS_hsCRP.log + HS_IL6.log +
                LAB_CHOL_VAP + LAB_HDL_VAP,
              family = "binomial", data = train)
prob <- predict(m_base, newdata = test, type = "response")
roc_obj <- roc(test$Gingivitis ~ prob, quiet = TRUE)
png("outputs/figures/06_roc_gingivitis_baseline.png", width = 1200, height = 800, res = 150)
plot.roc(roc_obj, main = sprintf("Gingivitis baseline ROC (AUC = %.3f)", auc(roc_obj))); dev.off()

# Optional: include latent factors (if available)
if (file.exists("outputs/05_latent_factors.rds")) {
  C_hat <- readRDS("outputs/05_latent_factors.rds")
  C_tr  <- C_hat[idx, , drop = FALSE]; C_te <- C_hat[-idx, , drop = FALSE]
  m_lc <- glm(as.factor(Gingivitis) ~ AGE + GENDER + RACE2 + PE_BP_CLASS + PE_SYSTOLIC +
                SCR_CURSMOKE + DEMO_DIABETES + HS_hsCRP.log + HS_IL6.log +
                LAB_CHOL_VAP + LAB_HDL_VAP + C_tr,
              family = "binomial", data = train)
  prob2 <- predict(m_lc, newdata = cbind(test, C_te), type = "response")
  roc_obj2 <- roc(test$Gingivitis ~ prob2, quiet = TRUE)
  png("outputs/figures/06_roc_gingivitis_latent.png", width = 1200, height = 800, res = 150)
  plot.roc(roc_obj2, main = sprintf("Gingivitis + latent ROC (AUC = %.3f)", auc(roc_obj2))); dev.off()
}

# ----------------------------------------------------------
# Optional: Subclinical ASCVD modeling (CIMT / CAC)
# ----------------------------------------------------------
if (file.exists("data/CIMT_CAC.csv")) {
  message("CIMT/CAC dataset detected — running subclinical ASCVD models")
  library(dplyr); library(MASS)   # polr for ordinal regression

  cimt_data <- read.csv("data/CIMT_CAC.csv")
  dat2 <- left_join(dat, cimt_data, by = "CLIENT_IDENTIFIER")

  # Linear regression for continuous CIMT (if present)
  if ("CIMT" %in% colnames(dat2)) {
    m_cimt <- lm(CIMT ~ AGE + GENDER + RACE2 + PE_BP_CLASS + PE_SYSTOLIC +
                   SCR_CURSMOKE + DEMO_DIABETES + HS_hsCRP.log + HS_IL6.log +
                   LAB_HDL_VAP + LAB_CHOL_VAP + Gingivitis, data = dat2)
    print(summary(m_cimt))
  }

  # Ordinal regression for categorized CAC (if present)
  if ("CAC_category" %in% colnames(dat2)) {
    m_cac <- MASS::polr(factor(CAC_category) ~ AGE + GENDER + RACE2 + PE_BP_CLASS +
                           SCR_CURSMOKE + DEMO_DIABETES + HS_hsCRP.log + HS_IL6.log +
                           LAB_HDL_VAP + LAB_CHOL_VAP + Gingivitis,
                         data = dat2, Hess = True)
    print(summary(m_cac))
  }

  save(m_cimt, m_cac, file = "outputs/06_models_cimt_cac.RData")
}

save(m_base, roc_obj, file = "outputs/06_models_gingivitis.RData")
