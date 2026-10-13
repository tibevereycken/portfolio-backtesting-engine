# Portfolio Backtesting & Asset Allocation Engine

A modular R framework for backtesting constrained asset allocation models, risk-parity heuristics, and trend-following strategies across multi-asset portfolios.

## Methodology & Strategies

The engine tests dynamic strategies using a **120-month rolling lookback window** to prevent look-ahead bias:
- **Mean-Variance Tangency Portfolio (TPA):** Quadratic programming formulation under Karush-Kuhn-Tucker (KKT) conditions:
  - Long-only constraint ($\sum w_j = 1, w_j \ge 0$)
  - Maximum single-asset concentration cap ($w_j \le 0.40$)
- **Minimum Variance Portfolio (MVP):** Global risk minimization without short positions.
- **Risk Parity (RPP):** Allocations inversely proportional to asset volatility ($\sigma_j^{-1}$) and variance ($\sigma_j^{-2}$).
- **Trend-Following (Momentum):** 12-month trailing cumulative momentum filter with equal allocation to positive-trend assets.
- **Equal-Weighted (1/N):** Naive benchmark allocation.

## Performance Metrics
Strategies are evaluated out-of-sample across risk-adjusted and utility dimensions:
- Annualized Return & Realized Volatility
- Sharpe Ratio ($R_f = 0\%$)
- Maximum Drawdown (MDD)
- Certainty Equivalent Return (CER) under Constant Relative Risk Aversion (CRRA) utility ($\gamma \in \{2, 4\}$)

## Repository Structure
- `src/00_synthetic_data.R`: Generates simulated multi-asset return series.
- `src/01_optimizers.R`: QP implementations using `quadprog::solve.QP`.
- `src/02_heuristics.R`: Risk parity and momentum allocation algorithms.
- `src/03_metrics.R`: Quantitative performance and utility evaluation suite.
- `main.R`: End-to-end rolling backtest runner.

## Quickstart

```bash
# Clone the repository
git clone [https://github.com/](https://github.com/)<jouw-username>/portfolio-backtesting-engine.git
cd portfolio-backtesting-engine

# Run via Rscript
Rscript main.R
```