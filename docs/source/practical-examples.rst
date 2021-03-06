==================
Practical Examples
==================

-----------------
Two sample t-test
-----------------

Load the included Balsakhi data set, which we'll use to estimate the control mean.

.. code-block:: r

    library(pwrcalc)
    data(balsakhi)
    control_data <- balsakhi[which(balsakhi$bal == 0), ]
    control_mean <- mean(control_data$post_totnorm, na.rm = TRUE)
    control_sd   <- sd(control_data$post_totnorm, na.rm = TRUE)

Let's inspect the results to make sure we're all on the same page.

.. code-block:: rconsole

    > print(control_mean)
    [1] 0.4288781
    > print(control_sd)
    [1] 1.15142

Let's say, based on other studies, that we expect an effect size of a tenth of a standard deviation. Now let's calculate the sample size for our anticipated effect size.

.. code-block:: r

    expected_effect <- control_sd / 10
    treated_mean    <- control_mean + expected_effect

We can now calculate the sample size needed to test that hypothesis at the significance level of 0.05 and power of 0.8.

.. code-block:: rconsole

    > twomeans(m1 = control_mean, m2 = treated_mean, sd = control_sd)

         Two-sample t-test power calculation 

                 m1 = 0.4288781
                 m2 = 0.5440201
                 n1 = 1570
                 n2 = 1570
          sig.level = 0.05
              power = 0.8
        alternative = two.sided

    NOTE: 
    m1 and m2 are the means of group 1 and 2, respectively.
    n1 and n2 are the obs. of group 1 and 2, respectively.

Now imagine we anticipate an effect half as large as the previous example. In particular, we now expect 1/20 of a standard deviation.

.. code-block:: r

    smaller_expected_effect <- control_sd / 20
    smaller_treated_mean    <- control_mean + smaller_expected_effect

.. code-block:: rconsole

    > twomeans(m1 = control_mean, m2 = smaller_treated_mean, sd = control_sd)

         Two-sample t-test power calculation 

                 m1 = 0.4288781
                 m2 = 0.4864491
                 n1 = 6280
                 n2 = 6280
          sig.level = 0.05
              power = 0.8
        alternative = two.sided

    NOTE: 
    m1 and m2 are the means of group 1 and 2, respectively.
    n1 and n2 are the obs. of group 1 and 2, respectively.

Notice now we need four times as many observations as the previous example.

-------------------------------------
Two sample t-test with group clusters
-------------------------------------

Many designs randomize at the group level instead of at the individual level. For such designs, we need to adjust our power calculations so that they incorporate the fact that individuals within the same group may be subject to similar shocks, and thereby have correlated outcomes. Duflo et al. presents a modified parametric approach, which takes into account the intra-cluster correlation (ICC) that arises from randomization at the group level.

.. code-block:: r

    library(ICC)
    icc_sample <- control_data[!is.na(divid) & !is.na(post_totnorm), ]
    control_subset$divid = as.factor(control_subset$divid)
    icc <- ICCest(divid, post_totnorm, data = control_subset)
    rho <- icc$ICC

.. code-block:: rconsole

    > twomeans(m1 = control_mean, m2 = treated_mean, sd = control_sd) %>% clustered(obsclus = 10, rho = 0.3)

         Two-sample t-test power calculation 

                            m1 = 0.4288781
                            m2 = 0.5440201
               n1 (unadjusted) = 1570
               n2 (unadjusted) = 1570
                           rho = 0.3
           Average per cluster = 10
    Mininum number of clusters = 1162
                 n1 (adjusted) = 5809
                 n2 (adjusted) = 5809
                     sig.level = 0.05
                         power = 0.8
                   alternative = two.sided

    NOTE: 
    - m1 and m2 are the means of group 1 and 2, respectively.
    - n1 (unadjusted) and n2 (unadjusted) are the obs. of group 1 and 2 ignoring clustering.
    - n1 (adjusted) and n2 (adjusted) are the obs. of group 1 and 2 adjusting for clustering.
