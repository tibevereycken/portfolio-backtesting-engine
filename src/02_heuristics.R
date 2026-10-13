calc_risk_parity <- function(cov_matrix, type = c("vol", "var")) {
  type <- match.arg(type)
  vars <- diag(cov_matrix)
  if (type == "vol") {
    inv_risks <- 1 / sqrt(vars)
  } else {
    inv_risks <- 1 / vars
  }
  return(inv_risks / sum(inv_risks))
}

calc_trend_weights <- function(past_12m_returns) {
  cum_ret <- apply(past_12m_returns + 1, 2, prod) - 1
  positive_assets <- cum_ret > 0
  n_pos <- sum(positive_assets)
  
  weights <- rep(0, length(cum_ret))
  if (n_pos > 0) {
    weights[positive_assets] <- 1 / n_pos
  }
  return(weights)
}
