### ab_test

#### We assessed whether the mean time spent searching on the website varies with the Ad impacted by the user.

###### After determining the sample size of 21 observations, we checked for both assumptions, the variance, and the normality, to conclude that both assumptions are met.

![Rplot_TimeSearcing_AmountSpent by Ad](https://github.com/SelvaCamp/ab_test/assets/158846801/a993860e-a347-42a4-bcac-2f4ccdda8069)

###### Running the two independent sample t-test on the mean time searching on impacts of the New Ad and the Old Ad indicates that time on searching has no different rates impact, so the p-value of **0.41 is above 0.05.

###### The mean for the **New Ad is 31.93** and the mean of **Old Ad is 31.26**

###### For this AB test, we got a power of 0.58, so the power analysis indicates there's (100%-58%) a 42% likelihood of deriving an inaccurate result.

###### Now, we are interested in the activity of its website users, and believe that the amount of time spent searching on the website is positively correlated with the amount of money spent.

###### To determine the correlation between time spent searching and, the amount spent we need **92 observations.

###### We first assessed the Pearson correlation assumption, the linearity and normality, and both are met.

![Rplot](https://github.com/SelvaCamp/ab_test/assets/158846801/576248ac-9191-488b-a6ec-40a5243cb98d)

###### First we run the Pearson's correlation ignoring groups. The proportion of variance explained in the AmountSpent that can be attributed to the TimeSearching is **0.048.

###### After running the person correlation test, we got that the correlation is significant with a mid-size power, indicating there is a 50% chance of error.

###### Secondly, we run the pearson's correlation with for each group, New Ad with a correlation of **0.3** and the Old Ad with a correlation of **0.14**. ***So we maintain the new ad on the website.***

###### Let’s find out whether the amount of time spent searching for items on the web, impacts the amount of money spent purchased.

###### First we checked for homoscedascity, and normality. Both assumptions are met, so can use t to make predictions.

![homoscedascity](https://github.com/SelvaCamp/ab_test/assets/158846801/e4db1a6f-3c1f-4096-bcd4-458be41aacc2)

![normality](https://github.com/SelvaCamp/ab_test/assets/158846801/5602edfa-b953-4e26-8d7d-995c247d27c4)

###### Using the model regardless of the groups, the amount of money spent with 25 sec. are 43.6, with 37 sec. are 47.54 and with 43 sec. are 49.5.

###### Finally, we checked whether the group of ad design, Old and New, in addition to the amount of time searching and amount spent. The t-value of grouping independent variable is not significant -0.440, not is the p-value, 0.661, indicating the groups do not impact the amount of money spent.
