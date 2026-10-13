source("src/00_synthetic_data.R")
source("src/01_optimizers.R")
source("src/02_heuristics.R")
source("src/03_metrics.R")

# 1. Genereer gesimuleerde return-data
df <- generate_mock_returns()
return_matrix <- as.matrix(df[, -1])
n_total <- nrow(return_matrix)
window_size <- 120

# 2. Containers voor out-of-sample returns
strategies <- c("TPA_NoShort", "TPA_Cap40", "MVP", "RPP_Vol", "RPP_Var", "Trend", "Equally_Weighted")
oos_returns <- matrix(0, nrow = n_total - window_size, ncol = length(strategies))
colnames(oos_returns) <- strategies

cat("Running rolling 120-month backtest...\n")

# 3. Rolling window backtesting loop
for (t in seq(window_size + 1, n_total)) {
  hist_ret <- return_matrix[(t - window_size):(t - 1), ]
  current_ret <- return_matrix[t, ]
  
  mu <- colMeans(hist_ret)
  sigma_mat <- cov(hist_ret)
  
  w_tpa_ns  <- solve_tpa(mu, sigma_mat, max_cap = 1.0)
  w_tpa_cap <- solve_tpa(mu, sigma_mat, max_cap = 0.40)
  w_mvp     <- solve_mvp(sigma_mat)
  w_rpp_vol <- calc_risk_parity(sigma_mat, "vol")
  w_rpp_var <- calc_risk_parity(sigma_mat, "var")
  w_trend   <- calc_trend_weights(hist_ret[(nrow(hist_ret) - 11):nrow(hist_ret), ])
  w_ew      <- rep(1 / ncol(return_matrix), ncol(return_matrix))
  
  idx <- t - window_size
  oos_returns[idx, "TPA_NoShort"]      <- sum(w_tpa_ns * current_ret)
  oos_returns[idx, "TPA_Cap40"]        <- sum(w_tpa_cap * current_ret)
  oos_returns[idx, "MVP"]              <- sum(w_mvp * current_ret)
  oos_returns[idx, "RPP_Vol"]          <- sum(w_rpp_vol * current_ret)
  oos_returns[idx, "RPP_Var"]          <- sum(w_rpp_var * current_ret)
  oos_returns[idx, "Trend"]            <- sum(w_trend * current_ret)
  oos_returns[idx, "Equally_Weighted"] <- sum(w_ew * current_ret)
}

# 4. Resultaten aggregeren en printen
summary_table <- do.call(rbind, lapply(as.data.frame(oos_returns), evaluate_performance))
cat("\n--- Backtest Performance Results ---\n")
print(round(summary_table, 2))

