suppressPackageStartupMessages({ library(tidyverse); library(cowplot) })
tab <- tryCatch(read.csv("outputs/tables/04_marginal_gingivitis.csv"), error = function(e) NULL)
if (!is.null(tab)) { head_tab <- tab %>% arrange(p_adj) %>% head(20); write.csv(head_tab, "outputs/tables/07_top20_gingivitis.csv", row.names = FALSE) }
