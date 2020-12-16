Estimation of the difference in the expected log predictive density (ELPD) on the new data.

logistic regression model <- problem with unbalanced response, plot of posterior predictive estimate (is there an overlap)

# R̂

One way to monitor whether a chain has converged to the equilibrium distribution is to compare its behavior to other randomly initialized chains. 
The R̂ value basically compares the within sample variance and the between sample variance. If the chains have not converged, there is notable difference in these variances and the R̂ value becomes big. Using this kind of measure is the most effective for quantities whose marginal posterior distributions are approximately normal. The Rhat measures ratio of variances within chain with total variance estimate so that a value of 1 indicates that the chains have converged. Greater than 1, should be less than 1.05. 
If R̂ is not near 1 for all of them, continue the simulation runs (perhaps altering the simulation algorithm itself to make the simulations more efficient). The condition of R̂ being ‘near’ 1 depends on the problem at hand, but we generally have been satisfied with setting 1.1 as a threshold.

# The Metropolis algorithm 

Markov chain simulation based method that is used for sampling from Bayesian posterior distributions, with the aim to converge to a specific distribution. It is based on the concept of random walk with an acceptance/rejection rule to converge to the specified target distribution. Metropolis-Hastings algorithm is a method that can be used to obtain random samples from some probability distribution when sampling directly from the distribution is impossible or difficult. The algorithm is initiated by choosing the starting point and probability density from which the samples are drawn (proposal/jumping density). In each iteration a new candidate x’ is drawn, acceptance ratio (r) is calculated and the we set the value of the current iterative value of x to either x’ (accept with probability r) or previous iteratrive value of x (reject with probability 1-r). The iteration is continued until the values converge.
First there is a warmup phase which is intended to move the simulations from their possibly unrepresentative initial values to something closer to the region of parameter space where the log posterior density is close to its expected value. Also during warmup there needs to be some procedure to set the algorithm’s tuning parameters; this can be done using information gathered from the warmup runs.
Third is the sampling phase, which ideally is run until multiple chains have mixed. When fitting a model that has been correctly specified, warmup thus has two purposes: (a) to run through a transient phase to reduce the bias due to dependence on the initial values, and (b) to provide information about the target distribution to use in setting tuning parameters. Recommended standard practice is to run at least until R̂, the measure of mixing of chains, is less than 1.01. It might seem like a safe and conservative choice to run MCMC until the effective sample size is in the thousands or Monte Carlo standard error is tiny in comparison to the required precision for parameter interpretation—but if this takes a long time, it limits the number of models that can be fit in the exploration stage.

# No-U-Turn Hamiltonian Monte Carlo
By default Stan uses the No-U-Turn Hamiltonian Monte Carlo Method (NUTS). 

Hamiltonian Monte Carlo method is a Markov chain Monte Carlo method for obtaining sequence of random samples which converge to target probability distribution. HMC corresponds to Metropolis-Hastings algorithm with Hamiltonian dynamics. NUTS can be understood through example:

Set ball rolling with randomly chosen kinetic energy in to certain direction. After ball has rolled to one direction long enough, it will start rolling backwards because of rolling to uphill. This causes ball to do U-turn, and we can stop sampling. Then we perform twice as many steps to the opposite direction of the original, and stop again after U-turn. This assumes that the ball has gone through the whole parameter space, and now we can choose the best point proposal that was accepted. If no proposal was accepted, we do this again. 

The primary cause of divergent transitions in Euclidean HMC (other than bugs in the code) is highly varying posterior curvature, for which small step sizes are too inefficient in some regions and diverge in other regions. If the step size is too small, the sampler becomes inefficient and halts before making a U-turn (hits the maximum tree depth in NUTS); if the step size is too large, the Hamiltonian simulation diverges.

# Effective number of simulation draws

The effective sample size is an estimate of the number of independent draws from the posterior distribution of the estimand of interest. The neff metric used in Stan is based on the ability of the draws to estimate the true mean value of the parameter, which is related to (but not necessarily equivalent to) estimating other functions of the draws. Because the draws within a Markov chain are not independent if there is autocorrelation, the effective sample size, neff, is usually smaller than the total sample size, N. 
An useful heuristic is to worry about any neff/N less than 0.1. One important thing to keep in mind is that these ratios will depend not only on the model being fit but also on the particular MCMC algorithm used.

n_eff/N decreases as autocorrelation becomes more extreme. Positive autocorrelation is bad (it means the chain tends to stay in the same area between iterations) and you want it to drop quickly to zero with increasing lag. Negative autocorrelation is possible and it is useful as it indicates fast convergence of sample mean towards true mean.

Once the simulated sequences have mixed, we can compute an approximate ‘effective number of independent simulation draws’ for any estimand of interest. If the n simulation draws within each sequence were truly independent, then the between-sequence variance B would be an unbiased estimate of the posterior variance and we would have a total of mn independent simulations from the m sequences.
One way to define effective sample size for correlated simulation draws is to consider the statistical efficiency of the average of the simulations ψ, as an estimate of the posterior mean, E(ψ|y).
From the formula seems than we need infinite number of simulation, but this should not be a problem given that we already want to run the simulations long enough for approximate convergence to the (asymptotic) target distribution. 

Even if an iterative simulation appears to converge and has passed all tests of convergence, it still may actually be far from convergence if important areas of the target distribution were not captured by the starting distribution and are not easily reachable by the simulation algorithm.
Monitor function provided both bulk-ESS and tail-ESS. Bulk-ESS estimates the sampling efficiency for the location of the distribution (e.g. mean and median) and Tail-ESS computes the minimum of the effective sample sizes (ESS) of the 5% and 95% quantiles. Tail-ESS can help diagnosing problems due to different scales of the chains and slow mixing in the tails. ESS scores were considered good if they were over 100 per chain. ESS value were also low with first versions of the model.
n_eff>N indicates that the mean estimate of the parameter computed from Stan draws approaches the true mean faster than the mean estimate computed from independent samples from the true posterior. This is possible when the draws are anticorrelated - draws above the mean tend to be well matched with draws below the mean. 

# Random informations taken from the "Bayesian workflow" paper

We need to clearly separate concepts of Bayesian inference from Bayesian data analysis and, critically, from full Bayesian workflow. Bayesian inference is just the formulation and computation of conditional probability or probability densities, p(θ|y) ∝ p(θ)p(y|θ). 
Bayesian workflow includes the three steps of model building, inference, and model checking/improvement, along with the comparison of different models, not just for the purpose of model choice or model averaging but more importantly to better understand these models. In a typical Bayesian workflow we end up fitting a series of models, some of which are in retrospect poor choices. 
Statistics is all about uncertainty. In addition to the usual uncertainties in the data and model parameters, we are often uncertain whether we are fitting our models correctly, uncertain about how best to set up and expand our models, and uncertain in their interpretation.
We like our parameters to be interpretable for both practical and ethical reasons. This leads to wanting them on natural scales and modeling them as independent, if possible, or with an interpretable dependence structure, as this facilitates the use of informative priors.

Prior predictive checks are a useful tool to understand the implications of a prior distribution in the context of a generative model. In particular, because prior predictive checks make use of simulations from the model rather than observed data, they provide a way to refine the model without using the data multiple times. The simulation shows that even independent priors on the individual coefficients have different implications as the number of covariates in the model increases. This is a general phenomenon in regression models where as the number of predictors increases, we need stronger priors on model coefficients (or enough data) if we want to push the model away from extreme predictions.
Once a model has been fit, the workflow of evaluating that fit is more convoluted, because there are many different things that can be checked, and each of these checks can lead in many directions.

Posterior predictive checking is analogous to prior predictive checking, but the parameter draws used in the simulations come from the posterior distribution rather than the prior. While prior predictive checking is a way to understand a model and the implications of the specified priors, posterior predictive checking also allows one to examine the fit of a model to real data.
When comparing simulated datasets from the posterior predictive distribution to the actual dataset, if the dataset we are analyzing is unrepresentative of the posterior predictive distribution, this indicates a failure of the model to describe an aspect of the data. The most direct checks compare the simulations from the predictive distribution to the full distribution of the data or a summary statistic computed from the data or subgroups of the data, especially for groupings not included in the model. We may tolerate that the model fails to capture certain aspects of the data or it may be essential to invest in improving the mode

# LOO

Leave-one-out cross-validation (LOO) is a method for estimating pointwise out-of-sample prediction accuracy from a fitted Bayesian model using the log-likelihood evaluated at the posterior simulations of the parameter values. After fitting a Bayesian model we often want to measure its predictive accuracy,for its own sake or for purposes of model comparison, selection, or averaging. Cross-validation is an approache to estimating out-of-sample predictive accuracy using within-sample fits. In this article we consider computations using the log-likelihood evaluated at the usual posterior simulations of the parameters. Exact cross-validation requires re-fitting the model with different training sets. Approximate leave-one-out cross-validation (LOO) can be computed easily using importance sampling, but the resulting estimate is noisy, as the variance of the importance weights can be large or even infinite. We use the Pareto smoothed importance sampling (PSIS) an approach that provides a more accurate and reliable estimate by fitting a Pareto distribution to the upper tail of the distribution of the importance weights. PSIS allows us to compute LOO using importance weights that would otherwise be unstable.
ELPD = expected log pointwise predictive density for new data
LPD = log pointwise predictive density 
The lpd of observed data is an overestimate of the elpd for future data
We can improve the LOO estimate using Pareto smoothed importance sampling, which applies a smoothing procedure to the importance weights.  The distribution of the importance weights used in LOO may have a long right tail. We use the empirical Bayes estimate to fit a generalized Pareto distribution to the tail (20% largest importance ratios). By examining the shape parameter k of the fitted Pareto distribution, we are able to obtain sample based estimates of the existence of the moments

The estimated shape parameter Khat of the generalised Pareto distribution can be used to asses the reliability of the estimate.

• If k < 1/2 , the variance of the raw importance ratios is finite, the central limit theorem holds, and the estimate converges quickly.
• If k is between 1/2 and 1, the variance of the raw importance ratios is infinite but the mean exists, the generalized central limit theorem for stable distributions holds, and the convergence of the estimate is slower. The variance of the PSIS estimate is finite but may be large.
• If k > 1, the variance and the mean of the raw ratios distribution do not exist. The variance of the PSIS estimate is finite but may be large

when khat exceeds 0.7 the user should consider sampling directly from p(θs|y−i) (leave-one-out predictive density without that data) for the problematic i, use K-fold cross-validation, or use a more robust model. The additional computational cost of sampling directly from each p(θs|y−i) is approximately the same as sampling from the full posterior, but it is recommended if the number of problematic data points is not too high.
As the data can be divided in many ways into K groups it introduces additional variance in the
estimates, which is also evident from our experiments. This variance can be reduced by repeating K-fold-CV several times with different permutations in the data division, but this will further increase the computational cost.

# Teemu slides
## Feature selection
- done to reduce the amount of parameters that are being estimated. 
  - Find correlating ones
- Positively correlating:
  - Age, serum creatinine
- Negatively correlating
  - ejection fraction, serum sodium
  - DISCARDED TIME
 ##  Prior selection
 - Priors according to references
   - Check average range of levels, check maximum lethal level
 - Half-Cauchy for age is actually not very good, as it might have too long tail
 - Inverse gamma distribution should be centered around mean values we found
 ## Prior sensitivity analysis
 - Fit model based on only priors
 - Perform posterior predictive checking
- The plotting was done by kernel density estimation, for which reason we see our discrete DEATH_EVENT variable as continuous. 
- Each line is individual prediction with our fitted model
- The key take away from this is, that by choosing priors we get less variance between each measurement, and we get more consistent results

## Weibull diagnostics
- R: 
- Effective sample size: 80 individual samples are worth 100 from MCMC
- Divergent chains: if we have too big step according to target distribution resolution, there might be. We have 0.
- LOO (leave one out CV)
  - ELPD (expected log pointwise density): sum of N probability densities, can be lower than 1 (negative ELPD) or higher than 1 (positive ELPD)
  - ELPD SE: SE of N components that ELPD is calculated over. Small N leads to overoptimistic SE
  - p_loo (p_eff): how much harder is it to predict future data (CV) than observed data. 
    - p_loo < p is good.
  - Pareto k: how far leave-one-out distribution is from full distribution. k higher when its further from full distribution.
    - k < 0.5, elpd estimated with high acc
    - 0.5 < k < 0.7 less accuracy, but still ok
    - k > 0.7 elpd_loo isn't useful estimate
## Weibull intrepretation
- 


# Nicola slides:
To proceed our bayesian workflow we designed 3 models and we chose to use BRMS for modeling that’s an interface to fit Bayesian generalized (non-)linear multivariate models using Stan. The Generalised Linear Model used is Bernoulli-Logit, which is logistic regression. First model: all features excluding TIME, second model: selected features strongest correlation with DEATH_EVENT, third model hierarchical with age as a grouping feature, there will be three groups since, by intuition, we thought that different aged people tend to have different medical conditions by default.
After fitting all these three models we asses the convergence using different measures. The first measure we investigated was the Rhat, that is a convergence diagnostic for Markov chain Monte Carlo. R̂ statistic measures the ratio between the average variance of draws within each chain and the variance of the pooled draws across chains; if all chains are at equilibrium, R̂ will be one. We had a look also at the effective sample size is an estimate of the number of independent draws from the posterior distribution of the estimand of interest. Because the draws within a Markov chain are not independent if there is autocorrelation, the effective sample size, neff, is usually smaller than the total sample size, N. We made sure that there werent divergent chains and the maximum tree depth only reached using the hierarchical model.
A model comparison have been carried out using the loo package for the estimation of elpd that is the expected log pointwise predictive density for new data and the k-values. The estimated shape parameter of the generalised Pareto distribution can be used to asses the reliability of the estimate. We want those values to be less than 0.7 to consider the estimation of elpd reliable.
 
Maximum treedepth: warnings about hitting the maximum treedepth are not as serious as warnings about divergent transitions. While divergent transitions are a validity concern, hitting the maximum treedepth is an efficiency concern. Configuring the No-U-Turn-Sampler (the variant of HMC used by Stan) involves putting a cap on the depth of the trees that it evaluates during each iteration . 
NUTS generates a proposal by starting at an initial position determined by the parameters drawn in the last iteration. It then generates an independent standard normal random momentum vector. It then evolves the initial system both forwards and backwards in time to form a balanced binary tree. At each iteration of the NUTS algorithm the tree depth is increased by one, doubling the number of leapfrog steps and effectively doubles the computation time. The algorithm terminates in one of two ways, either:
•the NUTS criterion  is satisfied for a new subtree or the completed tree, or
•the depth of the completed tree hits the maximum depth allowed.

Concluding our study we can say that the feature selected model is the best one in this case. We believe there is room for improvements such as: more advance feature engineering, use of different priors, more accurate estimation of the predictive performance for new data and more accurate calibration of the predictions. In addition the weibull model gave us interesting insight on how a dataset can be seen from different point of view and more ehaustive and comprehensive survival analysis can be subject for further studies.
We want to leave our contact details if someone is interested in having additional informations.



























