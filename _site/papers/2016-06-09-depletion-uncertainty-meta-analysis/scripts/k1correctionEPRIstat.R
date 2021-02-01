# Determination of 95/50 tolerance interval penalty factor to apply to EPRI calculated regression uncertainty

## One-sided tolerance factor based on the non-central t distribution. 
## Source: http://www.itl.nist.gov/div898/handbook/prc/section2/prc263.r 
## Discussion: http://www.itl.nist.gov/div898/handbook/prc/section2/prc263.htm

k1 <-
function(samp, cov, conf){
    n = samp                  # number of samples
    p = cov                   # coverage parameter
    g = conf                  # confidence parameter
    f = n - 1                 # degrees of freedom
    delta = qnorm(p)*sqrt(n)  # non-centrality parameter
    k = qt(g,f,delta)/sqrt(n) # k-factor for a one-sided tolerance interval
    return(k)
}

## The burnup data that is greater than 45 GWd/MTU is as follows:

highBUdata <- c(750, 575, 550, 510, 500, 400, 375, 300, 250, 250, 250, 220, 210, 125, 115, -115, -115, -500)

## This high burnup data is a subset of higher burnup data that is used for the estimation of the actual root mean square error
## that is required to determine the effective number of observations. Ultimately, this is needed to conservatively estimate the
## effect of using a 95/50 regression tolerance interval rather than a 95/95 regression tolerance interval.

## This quantity is also needed in the determination of the effective number of observations.

## From "tolerance: An R Package for Estimating Tolerance Intervals," Journal of Statistical Software, August 2010, Volume 36, Issue 5
## Article available at: https://www.jstatsoft.org/article/view/v036i05/v36i05.pdf

## For a regression tolerance interval, need to determine the effective number of observations as defined by Wallis' 1951 paper.
## This formulation is based on the root mean square error (RMSE) of the data divided by the standard error of the data. The RMSE is:

library(hydroGOF)

RMSE <- rmse(sim=highBUdata, obs=rep(0, length(highBUdata)))

## The RMSE is contained to a subset of higher burnup data (i.e. greater than 45 GWd/MTU) to obtain a conservative estimate of the RMSE
## since the data shows that variance increases with burnup.

## The standard error is estimate to be:

stdErr <- sd(highBUdata)/sqrt(length(highBUdata))

## Therfore, the effective number of observations is:

nEff <-  RMSE^2/stdErr^2

## To determine a penalty for using a 95/50 regression tolerance interval instead of a 95/95 regression tolerance interval, the
## regression fit uncertainty should be increased by the following factor:

library(tolerance)
adjFactor <- k1(nEff,0.95,0.95)/K.factor(n=nEff, f=nEff-1, alpha=1-0.50, P=0.95, side=2, method="EXACT", m=100)

## Note: A 0.90 vs. 0.95 coverage parameter is used when dividing out the prediction interval because a two-sided interval
##       is being adjusted rather than a one-sided interval.

## This factor is based on dividing the regression fit uncertainty by the one-sided tolerance factor that covers 95% of the population
## 50% of the time and multiplying it by th one-sided tolerance factor that covers 95% of the populations 95% of the time.

## The uncertainty data, as quantified by EPRI, is as follows:

EPRIuncData <- tbl_df(read.csv("data/EPRIuncData.csv"))

# ggplot(EPRIuncData, aes(burnup, regUncHigh)) + geom_point()

## The "burnup" column is the burnup in gigawatt-days per metric ton of uranium, "HtoC" is the 2-sigma hot-to-cold cross-section
## uncertainty, "fTemp" is the 2-sigma fuel temperature uncertainty as applied to the cold SFP environment, and "regUnc" is the
## uncertainty derived from the 95/50 tolerance interval as calculated by EPRI; the 95/50 penalty factor applies only to this regression
## uncertainty. The adjusted uncertainty then becomes:

EPRIuncDataAdj <- EPRIuncData %>%
    mutate(regUnc=round(regUncHigh * adjFactor))
    # mutate(regUnc=round(regUncHigh * ifelse(adjFactor*regUncHigh/last(regUncHigh) > 1, adjFactor*regUncHigh/last(regUncHigh), 1)))

## Combining the uncertainties by the root sum of squares and adding depletion code specific biases in the SFP environment, as
## determined by EPRI, results in the following final 95/95 determination based on the combination of code-specific biases and
## uncertainties:

EPRIadj <- 
    EPRIuncDataAdj %>%
    mutate(RSS=round(sqrt(HtoC^2+fTemp^2+regUnc^2))) %>%
    mutate(utilBias=150+(643-576)) %>%
    mutate(BandU=round(RSS+utilBias))
