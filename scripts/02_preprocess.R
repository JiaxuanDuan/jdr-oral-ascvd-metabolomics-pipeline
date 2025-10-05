suppressPackageStartupMessages({ library(tidyverse); library(mice); source("R/functions/io.R"); source("R/functions/qc.R") })
cfg <- yaml::read_yaml("config/config.yml"); odir <- cfg$outputs_dir; ddir <- cfg$data_dir
load(file.path(ddir, cfg$files$metabolon_rdata))
my.data$CLIENT_IDENTIFIER <- as.character(my.data$CLIENT_IDENTIFIER)
dat <- my.data[substr(my.data$CLIENT_IDENTIFIER, 5, 5) == "1", ]
dat$CLIENT_IDENTIFIER <- as.numeric(substr(dat$CLIENT_IDENTIFIER, 1, 4))
hdl_col <- which(colnames(dat) == "LAB_HDL_VAP"); meta_cols <- 13:(hdl_col - 1)
keep <- colMeans(is.na(dat[, meta_cols])) <= cfg$analysis$missing_rate_threshold
dat <- dat[, c(1:12, meta_cols[keep], hdl_col:ncol(dat))]
if (isTRUE(cfg$analysis$log_transform)) dat <- log_transform(dat, 13:(which(colnames(dat) == "LAB_HDL_VAP") - 1))
if (cfg$analysis$imputation == "mean") dat <- mean_impute(dat, 13:(which(colnames(dat) == "LAB_HDL_VAP") - 1))
save(dat, file = file.path(odir, "02_preprocessed.RData"))
