#Importing libraries
library(tidyverse)
library(ggplot2)
library(pwr)
library(effectsize)
library(car)

#Importing dataset AB_test
AB_test=read.csv("AB_test.csv")

#Exploring dataset

str(AB_test)

head(AB_test)

#Plot TimeSearching and AmountSpent by Ad

ggplot(AB_test, aes(TimeSearching, AmountSpent))+
  geom_point()+
  geom_smooth(method="lm", se=FALSE)+
  facet_wrap(~Ad)

#We are assessing whether the mean time spent searching on the website varies with the Ad impacted by the user.

#Selecting the variables to analyse
AB_testing=AB_test%>%
  select(AmountSpent, TimeSearching, Ad)



#1st Determine the sample size needed to ensure enough data is obtained to analyse the AB test

pwr.t.test(d=0.9, sig.level=0.05, power=0.8, type="two.sample") #with a effect size of 0.9, a power of 0.8, and a significance level of 0.05, n= 21

#Let's assess the group variance
leveneTest(TimeSearching ~ Ad, data= AB_testing)

# p-value=0.1524>0.05 #variance are equal


#Let's check normality
ggplot(AB_testing, aes(x=TimeSearching, fill=Ad))+
  geom_histogram()+
  facet_grid(Ad~.)

#Both assumptions are met, so we can use the t-test

#Let's run the t_test
t.test(TimeSearching~Ad, data=AB_testing, alternative="two.sided", var.equal=TRUE) #the mean for the New Ad is 31.93 and the mean of Old Ad is 31.26

##Running the two sample independent t-test on the mean time searching on impact of the New Ad and the Old Ad indicates that time on searching have no different rates impact, so the p-value of 0.41 is above of 0.05.

#Derive the cohen's d effect size to assess if there is a meaningful difference
cohens_d(TimeSearching~Ad, data=AB_testing)

#Run the power analysis
pwr.t.test(d=0.17, sig.level = 0.4078, n=60, type="two.sample")

#power of 0.58 so the power analysis indicates there's (100%-58%) a 42% likelihood of deriving an anaccurate result.


###CORRELATION####


#Description: A company is interested in the activity of its website users, and believes that the amount of time spent searching on the website is positively correlated with the amount of money spent.

#Select the variables for the AB design

AB_1=AB_test%>%
  select(AmountSpent, TimeSearching, Ad)

#Exploration Data Analysis

str(AB_1)


#1st Determine the sample size needed to run a test correlation

pwr.r.test(r=0.8, sig.level=0.05, power=0.95)   # n=92

#Assessing pearson correlation assumption: linearity and normality

#linearity: scatter plot
ggplot(AB_1, aes(x=TimeSearching, y=AmountSpent))+
  geom_point()+
  geom_smooth(method="lm")

#Assess normality

shapiro.test(AB_1$AmountSpent) #p-value= 0.2992. p-value above 0.05, therefore the distribution is normal

shapiro.test(AB_1$TimeSearching) #p-value= 0.8108. p-value above 0.05, therefore the distribution is normal

#Pearson ignoring groups

cor.test(~AmountSpent+TimeSearching, data=AB_1, method="pearson")  #correlation is 0.2201129

#let's calculate the proportion of variance explained in the AmountSpent that can be attributed to the TimeSearching

0.2201129^2 # proportion is 0.048

#Run a power analysis on the pearson correlation test using

pwr.r.test(r=0.22, n=92, sig.level=0.035)  #power analysis 0.504

#### This pearson correlation is significant with a positive cor with a mid size power, indicating there is a 50% chance of an error have been made in the test results.

#pearson correlation within groups

unique(AB_1$Ad)

#Run a pearson cor on the "New" Ad

cor.test(~AmountSpent+TimeSearching, subset=(Ad == "New"), data=AB_1, method="pearson") #cor within the New Ad is 0.30338

#Run a pearson cor on the "Old" Ad

cor.test(~AmountSpent+TimeSearching, subset=(Ad == "Old"), data=AB_1, method="pearson") #cor within the Old Ad is 0.1433502

###Given both correlation, the new Ads will remain on the website

#The company is now interested in whether the amount  of time spent searching for items on the web, impacts the amount of money spent purchased.

# 1st Create a model and assess the assumptions of homoscedascity and normality

model_AB=lm(AmountSpent~TimeSearching, data=AB_1)

summary(model_AB)

#Assess homoscedascity
plot(fitted(model_AB), resid(model_AB))
abline(0,0)

#Asses normality
qqnorm(resid(model_AB)); qqline(resid(model_AB), color="red") #the plot shows that the assumptions are met, so can use t to make predictions

#The company wants to know, using the model, how much money a user is likely to spent on the site given 25, 37 & 43 second regardless of the groups.

TimeSearching=c(25,37,43)

topredict=data.frame(TimeSearching)

pred=predict(model_AB, newdata = topredict)

print(pred)

#the amount of money spent with 25 sec is 43.6, with 37 sec is 47.54 and with 43 sec is 49.5

#Now the company is interested in whether the group of ad design, Old and New, in addition to the amount of time searching and amount spent

model_2=lm(AmountSpent~TimeSearching+Ad, data=AB_1)

summary(model_2)

#The t-value of grouping independent variable is not significant -0.440, not is the p-value, 0.661, indicating the groups does not impact the amount of money spent.



