evaluate_performance <- function(returns, rf = 0) {
  ann_ret <- prod(1 + returns)^(12 / length(returns)) - 1
  ann_vol <- sd(returns) * sqrt(12)
  sharpe  <- (ann_ret - rf) / ann_vol
  prob_loss <- mean(returns < 0)
  
  # Maximum Drawdown
  wealth_index <- cumprod(1 + returns)
  peaks <- cummax(wealth_index)
  drawdowns <- (wealth_index - peaks) / peaks
  max_dd <- abs(min(drawdowns))
  
  # Certainty Equivalent Return (CRRA)
  calc_cer <- function(gamma) {
    if (gamma == 1) return(NA)
    u_vals <- (1 + returns)^(1 - gamma) / (1 - gamma)
    eu <- mean(u_vals)
    ce_monthly <- ((1 - gamma) * eu)^(1 / (1 - gamma)) - 1
    (1 + ce_monthly)^12 - 1
  }
  
  data.frame(
    Ann_Return = ann_ret * 100,
    Ann_Vol    = ann_vol * 100,
    Sharpe     = sharpe,
    Prob_Loss  = prob_loss,
    Max_DD     = max_dd * 100,
    CER_g2     = calc_cer(2) * 100,
    CER_g4     = calc_cer(4) * 100
  )
}

