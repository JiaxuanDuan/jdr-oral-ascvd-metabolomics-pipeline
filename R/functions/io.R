suppressPackageStartupMessages({
  library(readr); library(readxl); library(yaml)
})
cfg_read <- function(path = "config/config.yml") yaml::read_yaml(path)
ensure_dir <- function(path) { if (!dir.exists(path)) dir.create(path, recursive = TRUE); invisible(path) }
