suppressPackageStartupMessages({ library(tidyverse); source("R/functions/stats_utils.R") })
load("outputs/03_dat_with_phenotypes.RData")
hdl_col <- which(colnames(dat) == "LAB_HDL_VAP"); meta_cols <- 13:(hdl_col - 1)
covars <- ~ AGE + GENDER + RACE2 + PE_BP_CLASS + PE_SYSTOLIC + SCR_CURSMOKE + DEMO_DIABETES + HS_hsCRP.log + HS_IL6.log + LAB_CHOL_VAP + LAB_HDL_VAP
p <- beta <- numeric(length(meta_cols))
for (j in seq_along(meta_cols)) {
  f <- reformulate(termlabels = c(colnames(dat)[meta_cols[j]], all.vars(covars)), response = "as.factor(Gingivitis)")
  fit <- glm(f, data = dat, family = "binomial")
  beta[j] <- coef(summary(fit))[2,1]; p[j] <- coef(summary(fit))[2,4]
}
res <- tibble(metabolite = colnames(dat)[meta_cols], beta = beta, p = p) %>% mutate(p_adj = p.adjust(p, method = "BH"))
write.csv(res, "outputs/tables/04_marginal_gingivitis.csv", row.names = FALSE)
qqplot_bh(res$p, "outputs/figures/04_qq_gingivitis.png", "Gingivitis: marginal regressions")
