missing_counts <- function(mat) colSums(is.na(mat))
log_transform <- function(df, cols) { df[, cols] <- log(df[, cols]); df }
mean_impute <- function(df, cols) {
  for (i in cols) { idx <- is.na(df[[i]]); if (any(idx)) df[[i]][idx] <- mean(df[[i]], na.rm = TRUE) }
  df
}
