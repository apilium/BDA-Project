// generated with brms 2.14.4
functions {
}
data {
  int<lower=1> N;  // total number of observations
  vector[N] Y;  // response variable
  int<lower=-1,upper=2> cens[N];  // indicates censoring
  real ub[N];  // upper truncation bounds
  int<lower=1> K;  // number of population-level effects
  matrix[N, K] X;  // population-level design matrix
  int prior_only;  // should the likelihood be ignored?
}
transformed data {
  int Kc = K - 1;
  matrix[N, Kc] Xc;  // centered version of X without an intercept
  vector[Kc] means_X;  // column means of X before centering
  for (i in 2:K) {
    means_X[i - 1] = mean(X[, i]);
    Xc[, i - 1] = X[, i] - means_X[i - 1];
  }
}
parameters {
  vector[Kc] b;  // population-level effects
  real Intercept;  // temporary intercept for centered predictors
  real<lower=0> shape;  // shape parameter
}
transformed parameters {
}
model {
  // likelihood including all constants
  if (!prior_only) {
    // initialize linear predictor term
    vector[N] mu = Intercept + Xc * b;
    for (n in 1:N) {
      // apply the inverse link function
      mu[n] = exp(mu[n]) / tgamma(1 + 1 / shape);
    }
    for (n in 1:N) {
    // special treatment of censored data
      if (cens[n] == 0) {
        target += weibull_lpdf(Y[n] | shape, mu[n]) -
        weibull_lcdf(ub[n] | shape, mu[n]);
      } else if (cens[n] == 1) {
        target += weibull_lccdf(Y[n] | shape, mu[n]) -
        weibull_lcdf(ub[n] | shape, mu[n]);
      } else if (cens[n] == -1) {
        target += weibull_lcdf(Y[n] | shape, mu[n]) -
        weibull_lcdf(ub[n] | shape, mu[n]);
      }
    }
  }
  // priors including all constants
  target += cauchy_lpdf(b[1] | 40,20);
  target += normal_lpdf(b[2] | .5,.5);
  target += normal_lpdf(b[3] | .5,.5);
  target += student_t_lpdf(Intercept | 3, 4.8, 2.5);
  target += gamma_lpdf(shape | 0.01, 0.01);
}
generated quantities {
  // actual population-level intercept
  real b_Intercept = Intercept - dot_product(means_X, b);
}

