bh_adjust <- function(p) p.adjust(p, method = "BH")
qqplot_bh <- function(pvals, out_png = NULL, title = "QQ plot (-log10 p)") {
  exp <- -log10(seq(1/length(pvals), 1, length.out = length(pvals))); obs <- -log10(sort(pvals))
  if (!is.null(out_png)) png(out_png, width = 1200, height = 800, res = 150)
  plot(exp, obs, main = title, xlab = "Expected -log10(p)", ylab = "Observed -log10(p)"); abline(a = 0, b = 1)
  if (!is.null(out_png)) dev.off()
}
