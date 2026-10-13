library(MASS)

generate_mock_returns <- function(n_months = 445, seed = 42) {
  set.seed(seed)
  assets <- c("World", "UK", "EM", "B_German", "B_USA", "B_Japan", "Gold")
  
  # Historische priors voor maandelijkse returns en volatiliteit
  mu <- c(0.0085, 0.0072, 0.0102, 0.0044, 0.0053, 0.0034, 0.0055)
  sigma <- c(0.0427, 0.0439, 0.0627, 0.0175, 0.0330, 0.0360, 0.0434)
  
  # Correlatiematrix
  rho <- matrix(c(
    1.00,  0.80,  0.65,  0.15,  0.20,  0.10,  0.10,
    0.80,  1.00,  0.60,  0.18,  0.22,  0.12,  0.12,
    0.65,  0.60,  1.00,  0.05,  0.10,  0.05,  0.20,
    0.15,  0.18,  0.05,  1.00,  0.45,  0.30, -0.05,
    0.20,  0.22,  0.10,  0.45,  1.00,  0.35,  0.00,
    0.10,  0.12,  0.05,  0.30,  0.35,  1.00, -0.02,
    0.10,  0.12,  0.20, -0.05,  0.00, -0.02,  1.00
  ), nrow = 7, byrow = TRUE)
  
  cov_mat <- diag(sigma) %*% rho %*% diag(sigma)
  raw_returns <- mvrnorm(n = n_months, mu = mu, Sigma = cov_mat)
  
  dates <- seq(as.Date("1988-01-31"), by = "month", length.out = n_months)
  df <- data.frame(Date = dates, raw_returns)
  colnames(df) <- c("Date", assets)
  return(df)
}

