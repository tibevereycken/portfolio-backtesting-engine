library(quadprog)

solve_mvp <- function(cov_matrix) {
  n <- ncol(cov_matrix)
  Dmat <- 2 * cov_matrix
  dvec <- rep(0, n)
  
  # Restricties: som van de gewichten = 1 en w_j >= 0
  Amat <- cbind(rep(1, n), diag(n))
  bvec <- c(1, rep(0, n))
  
  sol <- solve.QP(Dmat = Dmat, dvec = dvec, Amat = Amat, bvec = bvec, meq = 1)
  weights <- pmax(sol$solution, 0)
  return(weights / sum(weights))
}

solve_tpa <- function(mu, cov_matrix, max_cap = 1.0) {
  n <- length(mu)
  Dmat <- 2 * cov_matrix
  dvec <- rep(0, n)
  
  # Basisrestricties: som(w) = 1, w_i >= 0
  Amat <- cbind(rep(1, n), diag(n))
  bvec <- c(1, rep(0, n))
  
  # Optionele asset cap (bijv. max 40%)
  if (max_cap < 1.0) {
    Amat <- cbind(Amat, -diag(n))
    bvec <- c(bvec, rep(-max_cap, n))
  }
  
  # Doelrendement opnemen
  Amat <- cbind(mu, Amat)
  bvec <- c(max(mean(mu), 0.0001), bvec)
  
  sol <- tryCatch(
    solve.QP(Dmat = Dmat, dvec = dvec, Amat = Amat, bvec = bvec, meq = 0),
    error = function(e) NULL
  )
  
  if (is.null(sol)) {
    return(solve_mvp(cov_matrix))
  }
  
  weights <- pmax(sol$solution, 0)
  return(weights / sum(weights))
}

