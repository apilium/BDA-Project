Estimation of the difference in the expected log predictive density (ELPD) on the new data.

logistic regression model <- problem with unbalanced response, plot of posterior predictive estimate (is there an overlap)

#R̂

One way to monitor whether a chain has converged to the equilibrium distribution is to compare its behavior to other randomly initialized chains. R̂ statistic measures the ratio of the average variance of draws within each chain to the variance of the pooled draws across chains; if all chains are at equilibrium, these will be the same and R̂ will be one. If the chains have not converged to a common distribution, the R̂ statistic will be greater than one. The R̂ value basically compares the within sample variance and the between sample variance. If the chains have not converged, there is notable difference in these variances and the R̂ value becomes big. Using this kind of measure is the most effective for quantities whose marginal posterior distributions are approximately normal. The Rhat measures ratio of variances within chain with total variance estimate son that a value of 1 indicates that the chains have converged. Greater than 1, should be less than 1.05. 
If R̂ is not near 1 for all of them, continue the simulation runs (perhaps altering the simulation algorithm itself to make the simulations more efficient). The condition of R̂ being ‘near’ 1 depends on the problem at hand, but we generally have been satisfied with setting 1.1 as a threshold.

#The Metropolis algorithm 

Markov chain simulation based method that is used for sampling from Bayesian posterior distributions, with the aim to converge to a specific distribution. It is based on the concept of random walk with an acceptance/rejection rule to converge to the specified target distribution. Metropolis-Hastings algorithm is a method that can be used to obtain random samples from some probability distribution when sampling directly from the distribution is impossible or difficult. The algorithm is initiated by choosing the starting point and probability density from which the samples are drawn (proposal/jumping density). In each iteration a new candidate x’ is drawn, acceptance ratio (r) is calculated and the we set the value of the current iterative value of x to either x’ (accept with probability r) or previous iteratrive value of x (reject with probability 1-r). The iteration is continued until the values converge.


#Effective number of simulation draws

The effective sample size is an estimate of the number of independent draws from the posterior distribution of the estimand of interest. The neff metric used in Stan is based on the ability of the draws to estimate the true mean value of the parameter, which is related to (but not necessarily equivalent to) estimating other functions of the draws. Because the draws within a Markov chain are not independent if there is autocorrelation, the effective sample size, neff, is usually smaller than the total sample size, N. 
An useful heuristic is to worry about any neff/N less than 0.1. One important thing to keep in mind is that these ratios will depend not only on the model being fit but also on the particular MCMC algorithm used.
n_eff/N decreases as autocorrelation becomes more extreme. Positive autocorrelation is bad (it means the chain tends to stay in the same area between iterations) and you want it to drop quickly to zero with increasing lag. Negative autocorrelation is possible and it is useful as it indicates fast convergence of sample mean towards true mean.
Once the simulated sequences have mixed, we can compute an approximate ‘effective number of independent simulation draws’ for any estimand of interest. If the n simulation draws within each sequence were truly independent, then the between-sequence variance B would be an unbiased estimate of the posterior variance and we would have a total of mn independent simulations from the m sequences.
One way to define effective sample size for correlated simulation draws is to consider the statistical efficiency of the average of the simulations ψ, as an estimate of the posterior mean, E(ψ|y).
From the formula seems than we need infinite number of simulation, but this should not be a problem given that we already want to run the simulations long enough for approximate convergence to the (asymptotic) target distribution. 
We can use effective sample size neff to give us a sense of the precision obtained from our simulations. For many purposes it should suffice to have 100 or even 10 independent simulation draws. (If neff = 10, the simulation standard error is increased by 1 + 1/10 = 1.05). As a default rule, we suggest running the simulation until neff is at least 5m, that is, until there are the equivalent of at least 10 independent draws per sequence (recall that m is twice the number of sequences, as we have split each sequence into two parts so that R̂ can assess stationarity as well as mixing). Having an effective sample size of 10 per sequence should typically correspond to stability of all the simulated sequences. Once R̂ is near 1 and neff is more than 10 per chain for all scalar estimands of interest, just collect the mn simulations (with warm-up iterations already excluded, as noted before) and treat them as a sample from the target distribution.
Even if an iterative simulation appears to converge and has passed all tests of con- vergence, it still may actually be far from convergence if important areas of the target distribution were not captured by the starting distribution and are not easily reachable by the simulation algorithm.
Monitor function provided both bulk-ESS and tail- ESS. Bulk-ESS measures the center of the distribution and tail-ESS measures for interval estimates. ESS scores were considered good if they were over 100 per chain. ESS value were also low with first versions of the model.










