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
pwr.t.test(d=0.9, sig.level=0.05, power=0.8, type="two.sample")

#Let's assess the group variance
leveneTest(TimeSearching ~ Ad, data= AB_testing)

#Let's check normality
ggplot(AB_testing, aes(x=TimeSearching, fill=Ad))+
  geom_histogram()+
  facet_grid(Ad~.)

#Let's run the t_test
t.test(TimeSearching~Ad, data=AB_testing, alternative="two.sided", var.equal=TRUE)

#Derive the cohen's d effect size to assess if there is a meaningful difference
cohens_d(TimeSearching~Ad, data=AB_testing)

#Run the power analysis
pwr.t.test(d=0.17, sig.level = 0.4078, n=60, type="two.sample")

#CORRELATION

#Select the variables for the AB design
AB_1=AB_test%>%
  select(AmountSpent, TimeSearching, Ad)

#1st Determine the sample size needed to run a test correlation
pwr.r.test(r=0.8, sig.level=0.05, power=0.95)   # n=92

#Assessing pearson correlation assumption: linearity and normality
#linearity: scatter plot
ggplot(AB_1, aes(x=TimeSearching, y=AmountSpent))+
  geom_point()+
  geom_smooth(method="lm")

#Assess normality
shapiro.test(AB_1$AmountSpent)
shapiro.test(AB_1$TimeSearching)

#Pearson ignoring groups
cor.test(~AmountSpent+TimeSearching, data=AB_1, method="pearson")
variace=proportion=0.2201129^2

#Run a power analysis on the pearson correlation test using
pwr.r.test(r=0.22, n=92, sig.level=0.035)

#pearson correlation within groups

#Run a pearson cor on the "New" Ad
cor.test(~AmountSpent+TimeSearching, subset=(Ad == "New"), data=AB_1, method="pearson")

#Run a pearson cor on the "Old" Ad
cor.test(~AmountSpent+TimeSearching, subset=(Ad == "Old"), data=AB_1, method="pearson")

#1st Create a model and assess the assumptions of homoscedascity and normality
model_AB=lm(AmountSpent~TimeSearching, data=AB_1)
summary(model_AB)

#Assess homoscedascity
plot(fitted(model_AB), resid(model_AB))
abline(0,0)

#Asses normality
qqnorm(resid(model_AB)); qqline(resid(model_AB), color="red")

#Let's predict
TimeSearching=c(25,37,43)
topredict=data.frame(TimeSearching)
pred=predict(model_AB, newdata = topredict)
print(pred)

#Now we are interested in whether the group of ad design, Old and New, in addition to the amount of time searching and amount spent
model_2=lm(AmountSpent~TimeSearching+Ad, data=AB_1)
summary(model_2)





