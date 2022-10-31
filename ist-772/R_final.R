install.packages("nlme")
install.packages("car")
install.packages("ez")
install.packages("tseries")
install.packages("changepoint")
install.packages("BaylorEdPsych")
install.packages("MCMCpack")
install.packages("BayesFactor")
install.packages("bayesanova")
install.packages("mlr")
install.packages("drc")
install.packages("caret")
library("caret")
library("nlme")
library("car")
library("ez")
library("tseries")
library("changepoint")
library("BaylorEdPsych")
library("MCMCpack")
library("BayesFactor")
library("bayesanova")
library("mlr")
library("drc")

# data cleaning
# check outliers, replace outliers with median.
par(mfrow=c(1,2))
boxplot(districts$PctChildPoverty,xlab = "PctChildPoverty")
boxplot(districts2$PctChildPoverty,xlab = "PctChildPoverty")
outliers <- boxplot(districts2$PctChildPoverty, plot=FALSE)$out
districts2$PctChildPoverty[which(districts2$PctChildPoverty %in% outliers)] <- median(districts2$PctChildPoverty)

boxplot(districts$PctFreeMeal,xlab = "PctFreeMeal")
boxplot(districts2$PctFreeMeal,xlab = "PctFreeMeal")

boxplot(districts$PctFamilyPoverty,xlab = "PctFamilyPoverty")
boxplot(districts2$PctFamilyPoverty,xlab = "PctFamilyPoverty")
outliers <- boxplot(districts2$PctFamilyPoverty, plot=FALSE)$out
districts2$PctFamilyPoverty[which(districts2$PctFamilyPoverty %in% outliers)] <- median(districts2$PctFamilyPoverty)

boxplot(districts$Enrolled,xlab = "Enrolled")
boxplot(districts2$Enrolled,xlab = "Enrolled")
outliers <- boxplot(districts2$Enrolled, plot=FALSE)$out
districts2$Enrolled[which(districts2$Enrolled %in% outliers)] <- median(districts2$Enrolled)

boxplot(districts$TotalSchools,xlab = "TotalSchools")
boxplot(districts2$TotalSchools,xlab = "TotalSchools")
outliers <- boxplot(districts2$TotalSchools, plot=FALSE)$out
districts2$TotalSchools[which(districts2$TotalSchools %in% outliers)] <- median(districts2$TotalSchools)

#1
plot.ts(usVaccines,frequency = 1)
ts.plot(usVaccines, col= 1:5)
legend("bottomright", colnames(usVaccines), col=1:5,lty=1)

view(usVaccines)

decUsVac <- decompose(ts(usVaccines[,"Hib3"],frequency = 1))
plot(decUsVac)

cpt.var(diff(usVaccines[,"DTP1"]))
plot(cpt.var(diff(usVaccines[,"DTP1"])))
cpt.var(usVaccines[,"HepB_BD"])
plot(diff(usVaccines[,"HepB_BD"]))
cpt.var(diff(usVaccines[,"Pol3"]))
plot(cpt.var(diff(usVaccines[,"Pol3"])))
cpt.var(diff(usVaccines[,"Hib3"]))
plot(cpt.var(diff(usVaccines[,"Hib3"])))
cpt.var(diff(usVaccines[,"MCV1"]))
plot(cpt.var(diff(usVaccines[,"MCV1"])))

cpt.mean(usVaccines[,"DTP1"])
cpt.mean(usVaccines[,"HepB_BD"])
cpt.mean(usVaccines[,"Pol3"])
cpt.mean(usVaccines[,"Hib3"])
cpt.mean(usVaccines[,"MCV1"])

summary(usVaccines)


#2
nrow(allSchoolsReportStatus[which(allSchoolsReportStatus$pubpriv=="PUBLIC" & allSchoolsReportStatus$reported == "Y"),])
nrow(allSchoolsReportStatus[which(allSchoolsReportStatus$pubpriv=="PRIVATE" & allSchoolsReportStatus$reported == "Y"),])
schoolData <- allSchoolsReportStatus[which(allSchoolsReportStatus$reported == "Y"),]
schoolData$pubpriv <- as.factor(schoolData$pubpriv)
pubschool <- schoolData[schoolData$pubpriv == "PUBLIC",]
prischool <- schoolData[schoolData$pubpriv == "PRIVATE",]

chisq.test(table(schoolData[2:3]))
chisq.test(table(allSchoolsReportStatus[2:3]))
table(schoolData[2:3])


#3
summary(usVaccines)
head(usVaccines)
usv_2013 <- window(usVaccines, start =2013,end= 2013)
usv_2013
summary(districts2[2:5])
#4
cor(districts[2:5])


#5
districts2 <- districts
summary(districts2)

col_name <- c("DistrictComplete","PctChildPoverty","PctFreeMeal","PctFamilyPoverty","Enrolled","TotalSchools")
df <- districts2[col_name]
df <- as.factor(df$DistrictComplete)

df <- data.frame(districts$DistrictComplete,districts2$PctChildPoverty,districts2$PctFreeMeal,
                 districts2$PctFamilyPoverty,districts2$Enrolled,districts2$TotalSchools)
boxplot(districts2$PctChildPoverty)

pairs(df)
colnames(districts2)
predict_glm <- glm(formula = DistrictComplete~PctChildPoverty+PctFreeMeal+PctFamilyPoverty+TotalSchools+Enrolled, data=districts2, family=binomial())
predict_glm <- glm(formula = DistrictComplete~TotalSchools+Enrolled, data=districts2, family=binomial())

summary(predict_glm)
exp(coef(predict_glm))
exp(confint(predict_glm))
PseudoR2(predict_glm)
bayesLogit <- MCMClogit(formula = DistrictComplete~Enrolled+TotalSchools, data=districts2)
summary(bayesLogit)
anova(predict_glm, test="Chisq")
a <- predict(predict_glm,type="response")
table(districts2$DistrictComplete, a>0.5)
table(round(predict(predict_glm,type = "response")), districts2$DistrictComplete)



#6
col_name <- c("PctUpToDate","PctChildPoverty","PctFreeMeal","PctFamilyPoverty","Enrolled","TotalSchools")
df <- districts2[col_name]
pairs(df)


predict_date <- lm(log(PctUpToDate)~ PctChildPoverty + PctFreeMeal + PctFamilyPoverty + Enrolled+TotalSchools, data=districts2)
predict_date <- lm(PctUpToDate~ PctFreeMeal +Enrolled, data=districts2)
summary(predict_date)

cor(districts2[9:13])
vif(predict_date)
date_MCMC <- lmBF(PctUpToDate~ PctFreeMeal + Enrolled, data=districts2,posterior = TRUE,iterations=10000)
summary(date_MCMC)
date_BF <- lmBF(PctUpToDate~PctFreeMeal + Enrolled, data=districts2)
date_BF


#7
col_name <- c("PctBeliefExempt","PctChildPoverty","PctFreeMeal","PctFamilyPoverty","Enrolled","TotalSchools")
df <- districts2[col_name]
pairs(df)
df$PctBeliefExempt <- log(df$PctBeliefExempt+1)
log(districts2$PctChildPoverty)
predict_exempt <- lm(log(PctBeliefExempt+1)~ PctFreeMeal + Enrolled, data=districts2)
summary(predict_exempt)
cor(districts[9:13])
vif(predict_exempt)
exempt_MCMC <- lmBF(PctBeliefExempt~ PctFreeMeal +  Enrolled, data=districts2,posterior = TRUE,iterations=10000)
summary(exempt_MCMC)
exempt_BF <- lmBF(PctBeliefExempt~ PctFreeMeal + Enrolled, data=df)
exempt_BF


