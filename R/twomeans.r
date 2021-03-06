#' Two-sample t-test power calculation
#' 
#' @param m1 Mean of a group 1 (e.g., the control-group)
#' @param m2 Mean of a group 2 (e.g., the experimental-group)
#' @param n1 Number of obs. in group 1 (e.g., the control-group)
#' @param n2 Number of obs. in group 2 (e.g., the control-group)
#' @param nratio Ratio of sample sizes, group 2 to group 1; default is nratio = 1, meaning equal group sizes
#' @param sd Standard deviation of each group, i.e., sd = sd1 = sd2
#' @param sd1 Standard deviation of a group 1 (e.g., the control group)
#' @param sd2 Standard deviation of a group 2 (e.g., the experimental group)
#' @param sig.level significance level; default is sig.level = 0.05
#' @param power one minus the probability of type II error; default is power = 0.8
#' @return Returns an object with all the study parameters
#' @export
#' @importFrom stats qnorm
#' @examples
#' twomeans(m1 = 12, m2 = 16, sd = 5)
twomeans <- function(m1        = NULL,
                     m2        = NULL,
                     n1        = NULL,
                     n2        = NULL,
                     nratio    = NULL,
                     sd        = NULL,
                     sd1       = NULL,
                     sd2       = NULL,
                     sig.level = 0.05,
                     power     = 0.80) {

    # Validate function
    .check.twomeans(m1,
                    m2,
                    n1,
                    n2,
                    nratio,
                    sd,
                    sd1,
                    sd2,
                    sig.level,
                    power)

    # Specify ratio
    if(is.null(nratio)) {
        nratio = 1
    }

    # Plug in sd (and sd1/sd2)
    if(!is.null(sd)) {
        sd1 = sd
        sd2 = sd
    }

    beta = 1 - power

    n1 <- (sd1^2 + (sd2^2) / nratio) *
          (qnorm(1 - sig.level / 2) + qnorm(1 - beta))^2 / ((m1 - m2)^2)

    n2 <- nratio * n1

    # Round the n's
    n1 <- ceiling(n1)
    n2 <- ceiling(n2)

    METHOD = "Two-sample t-test power calculation"
    NOTE   = paste("",
                   "m1 and m2 are the means of group 1 and 2, respectively.",
                   "n1 and n2 are the obs. of group 1 and 2, respectively.",
                   sep = "\r\n")

    structure(list(m1          = m1,
                   m2          = m2,
                   n1          = n1,
                   n2          = n2,
                   sig.level   = sig.level,
                   power       = power,
                   alternative = "two.sided",
                   method      = METHOD,
                   note        = NOTE), 
                   class       = "power.htest")

}

.check.twomeans <- function(m1, m2, n1, n2, nratio, sd, sd1, sd2, sig.level, power) {

    # Non-negative standard deviation
    if(any(sd <= 0, sd1 <= 0, sd2 <= 0)) {
        stop("sd must be positive")
    }

    # Non-negative observations
    if(any(n1 <= 0, n2 <= 0, nratio <= 0)) {
        stop("n1, n2, and nratio must be positive")
    }

    # alpha and power must fall within the interval [0, 1]
    if(any(sig.level < 0, sig.level > 1, power < 0, power > 1)) {
        stop("sig.level and power must fall between 0 and 1")
    }

    # Means can't be equal
    if(m1 == m2) {
        stop("m1 and m2 cannot be equal")
    }

    # Can't specify sd and (sd1 and sd2)
    if(is.null(sd)) {
        if(any(is.null(sd1), is.null(sd2))) {
            stop("must specific either just sd or sd1 and sd2")
        }
    } else {
        if(any(!is.null(sd1), !is.null(sd2))) {
            stop("must specific either just sd or sd1 and sd2")
        }
    }
}
