install.packages("scales")
library(scales)
projectdata <- RDC_Inventory_Core_Metrics_County_History
count(newprojectdata)
install.packages('caTools')
library('caTools')
install.packages('corrplot')
library(corrplot)
library(readr)
library(zipcode)
library(ggmap)
library(ggplot2)
library(reshape2)
library(e1071)
library(arulesViz)


newprojectdata <- projectdata[projectdata$month_date_yyyymm > 201812,] #date between
colnames(new)[colSums(is.na(new)) >0] #col name with NAs
sum(is.na(newdata))
summary(newdata)
a= c("price_increased_count_yy","price_increased_count_mm")
new <- subset(newprojectdata, select = a, drop = FALSE)
str(new)
a = c(17,18,20,21,23,24)
new <- newprojectdata[,-a]

summary(newdata)

colnames(new)
b = c("price_increased_count_yy","price_increased_count_mm","median_listing_price_per_square_foot_mm", "median_listing_price_per_square_foot_yy", "median_square_feet_yy", "median_square_feet_mm","pending_listing_count_mm","pending_listing_count_yy",'price_reduced_count_mm','price_reduced_count_yy')
newdata <- newprojectdata[, !(colnames(newprojectdata) %in% b), drop = FALSE] # picking the columns we want.
sum(is.na(newdata))
newprojectdata <- newdata
library(dplyr)
count(newprojectdata, state)
str(newdata)

us <- map_data("state")
us
newprojectdata$state = unlist(sapply(strsplit(newprojectdata$county_name, ","),function(x) x[2]))
newprojectdata$county = unlist(sapply(strsplit(newprojectdata$county_name, ","),function(x) x[1]))
newprojectdata$state <- toupper(newprojectdata$state)
newprojectdata
newprojectdata$month = substr(newprojectdata$month_date_yyyymm, 1,4)
newprojectdata$date = substr(newprojectdata$month_date_yyyymm, 5,6)
newprojectdata[c('median_listing_price','')]
a <- ggplot(newprojectdata, aes(y=median_listing_price, fill= state, color=)) + geom_bar()
a # count of housing open sales in different state
count(newprojectdata,state)
count(newprojectdata,state)[order(n),]
str(newprojectdata)
m = aggregate(newprojectdata$median_listing_price,list(newprojectdata$state),mean)
colnames(m)
newprojectdata[order(newprojectdata$state),]

beforeCovid <- newprojectdata[which(newprojectdata$month_date_yyyymm < 202003, newprojectdata$month_date_yyyymm > 201900),]
duringCovid <- newprojectdata[which(newprojectdata$month_date_yyyymm < 202102, newprojectdata$month_date_yyyymm > 202002),]
afterCovid <- newprojectdata[which(newprojectdata$month_date_yyyymm > 202101),]
v = tapply(beforeCovid$median_listing_price, beforeCovid$state, mean)
v1 = tapply(duringCovid$median_listing_price, duringCovid$state, mean)
v2 = tapply(afterCovid$median_listing_price, afterCovid$state, mean)
v[which.max(v)]
v1[which.max(v1)]
v2[which.max(v2)]
m[which.max(m$x),]
plot(c(v[which.max(v)],v1[which.max(v1)],v2[which.max(v2)]))
c1=mean(beforeCovid$median_listing_price[beforeCovid$state == ' AR'])
c2=mean(duringCovid$median_listing_price[duringCovid$state == ' AR'])
c3= mean(afterCovid$median_listing_price[afterCovid$state == ' AR'])
plot(c(c1,c2,c3))

gd <- newprojectdata[c('month_date_yyyymm','median_listing_price','state','county')]
gd$state <- toupper(gd$state)
gd$state <- gsub(" ","",gd$state, fixed = TRUE)
gd$stateName <- state.name[match(gd$state,state.abb)]
beforeCovid <- gd[which(gd$month_date_yyyymm < 202003, gd$month_date_yyyymm > 201900),]
duringCovid <- gd[which(gd$month_date_yyyymm < 202102, gd$month_date_yyyymm > 202002),]
afterCovid <- gd[which(gd$month_date_yyyymm > 202101),]

ggplot(gd, aes(x=median_listing_price)) + geom_histogram(binwidth = 10)
str(gd)

#overall 
price <- tapply(gd$median_listing_price, gd$stateName,sum)
state<-row.names(price)
stateincome <- data.frame(state,price)
stateincome$state <- tolower(stateincome$state)
ggplot(stateincome, aes(map_id = state)) +geom_map(map=us,aes(fill=price)) +expand_limits(x=us$long,y=us$lat)+ coord_map()
str(stateincome)

#beforecovid
beforeprice <- tapply(beforeCovid$median_listing_price, beforeCovid$stateName,mean)
state<-row.names(beforeprice)
stateincome <- data.frame(state,beforeprice)
stateincome$state <- tolower(stateincome$state)
beforecovidplot <- ggplot(stateincome, aes(map_id = state)) +geom_map(map=us,aes(fill=beforeprice),color='black') 
beforecovidplot <- beforecovidplot + expand_limits(x=us$long,y=us$lat) + scale_fill_gradient(low='red',high='white') + coord_map()
beforecovidplot + ggtitle('Median Housing price per states before Covid')

#duringcovid
price <- tapply(duringCovid$median_listing_price, duringCovid$stateName,mean)
state<-row.names(price)
stateincome <- data.frame(state,price)
stateincome$state <- tolower(stateincome$state)
duringcovidplot <- ggplot(stateincome, aes(map_id = state)) +geom_map(map=us,aes(fill=price),color='black') 
duringcovidplot <- duringcovidplot + expand_limits(x=us$long,y=us$lat) 
duringcovidplot <- duringcovidplot + scale_fill_gradient(low='red',high='white') + coord_map()
duringcovidplot + ggtitle('Median Housing price per states during Covid')

#aftercovid
options(scipen=10)
price <- tapply(afterCovid$median_listing_price, afterCovid$stateName,mean)
state<-row.names(price)
stateincome <- data.frame(state,price)
stateincome$state <- tolower(stateincome$state)
aftercovidplot <- ggplot(stateincome, aes(map_id = state)) +geom_map(map=us,aes(fill=price),color='black') 
aftercovidplot <- aftercovidplot + expand_limits(x=us$long,y=us$lat) + coord_map() + scale_fill_gradient(low='red',high='white')
aftercovidplot <- aftercovidplot + ggtitle('Median Housing price per states After Covid') 
aftercovidplot <- aftercovidplot + theme(plot.title = element_text(hjust = 0.5))
aftercovidplot

summary(gd)

# ANOVA
anova1 <- aov(median_listing_price~active_listing_count,data=newprojectdata)
summary(anova1)
cor(newprojectdata[c('median_listing_price','active_listing_count','new_listing_count','median_days_on_market','month_date_yyyymm')], use='complete.obs',method='spearman')

#t test for house price
a <- afterCovid$median_listing_price
b <- beforeCovid$median_listing_price
t.test(a,b)

z.test = function(x,mu,popvar){
  
  one.tail.p <- NULL
  
  z.score <- round((mean(x)-mu)/(popvar/sqrt(length(x))),3)
  
  one.tail.p <- round(pnorm(abs(z.score),lower.tail = FALSE),3)
  
  cat(" z =",z.score,"\n",
      
      "one-tailed probability =", one.tail.p,"\n",
      
      "two-tailed probability =", 2*one.tail.p )}


#t test for days on market 
t.test(day_table$afterday, day_table$beforeday)

# t test one each state

(mean(a)-mean(b))/(sqrt(sd(a)/length(b)) - sd(b)/length(b))

ap <- data.frame(tapply(afterCovid$median_listing_price, afterCovid$stateName,mean))
ap$state <- rownames(ap)
dp <- data.frame(tapply(duringCovid$median_listing_price, duringCovid$stateName,mean))
dp$state <- rownames(dp)
bp <- data.frame(tapply(beforeCovid$median_listing_price, beforeCovid$stateName,mean))
bp$state <- rownames(bp)

t1 <- merge(ap,dp, by = 'state')
t2 <- merge(t1,bp, by='state')
str(t2)
colnames(t2) <- c('state','aftercovidprice','duringcovidprice','beforecovidprice')
plot(t2)

# each state median price for different time period
str(t2)
t4$state <- factor(t4$state, levels = t4$state[order(t4$pricechange)])
p1 <- ggplot(data=t4,aes(x=state)) +geom_line(aes(y=aftercovidprice,group=1,color='after')) 
p1 <- p1 + geom_line(aes(y=beforecovidprice,group=1,color='before')) +geom_line(aes(y=duringcovidprice,group=1,color='during')) 
p1 <- p1 + geom_point(aes(y=aftercovidprice),color='red') +geom_point(aes(y=beforecovidprice),color='green') +geom_point(aes(y=duringcovidprice),color='blue')
p1 <- p1 + theme(axis.text.x= element_text(angle=90))
p1 + labs(color='legend')
str(t3)
t3 <- melt(t2,id='state')
newdata['median_listing_price']
ggplot(data=t3,aes(y=state,x=value,fill=variable)) + geom_bar(width = 0.8,stat='identity')  + theme(axis.text.x= element_text(angle=90)) + scale_fill_brewer(palette="Paired") + theme_minimal() + ggtitle('Median housing price per states')

# before and after percent change for house price
pricechange <-t4[order(t4$pricechange),]
plot_price <- pricechange[,c(1,7)]
plot_price$state <- factor(plot_price$state, levels = plot_price$state[order(plot_price$pricechange)])
ggplot(data = plot_price, aes(x=pricechange,y=state)) + geom_bar(stat="identity") + ggtitle("housing price percentage change")
head(plot_price)

colnames(t4)
t4<-t2
t4$pricechangeafter <- (t4$aftercovidprice/t4$duringcovidprice)-1
t4$pricechangeduring <- (t4$duringcovidprice/t4$beforecovidprice)-1
t4$pricechange <- (t4$aftercovidprice/t4$beforecovidprice)-1
str(t4)
melt(t4[,c(1,5:7)],id='state')
t4$state <- tolower(t4$state)
c <- ggplot(t4[,c(1,7)], aes(map_id = state)) + geom_map(map=us,aes(fill=pricechange),color='black') 
c <- c + expand_limits(x=us$long,y=us$lat) + coord_map() + scale_fill_gradient(low='white',high='red')
c + theme(axis.title.x = element_blank(), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.text.x=element_blank()) + ggtitle("housing price percentage change")



# Create dataFrame for median days on makret plot
rm(gdd)
gdd<-data.frame()
gdd <- newprojectdata[c('month_date_yyyymm','median_days_on_market','state','county')]
gdd$state <- gsub(" ","",gdd$state, fixed = TRUE)
gdd$stateName <- state.name[match(gdd$state,state.abb)]
beforeCovidd <- gdd[which(gdd$month_date_yyyymm < 202003, gdd$month_date_yyyymm > 201900),]
duringCovidd <- gdd[which(gdd$month_date_yyyymm < 202102, gdd$month_date_yyyymm > 202002),]
afterCovidd <- gdd[which(gdd$month_date_yyyymm > 202101),]
str(gdd)

# after covid days on market
days <- tapply(afterCovidd$median_days_on_market, afterCovidd$stateName,mean)
state<-row.names(days)
daysonmarket <- data.frame(state,days)
daysonmarket$state <- tolower(daysonmarket$state)
aftercoviddplot <- ggplot(daysonmarket, aes(map_id = state)) +geom_map(map=us,aes(fill=days),color='black') 
aftercoviddplot <- aftercoviddplot + expand_limits(x=us$long,y=us$lat) + coord_map() + scale_fill_gradient(low='red',high='white')
aftercoviddplot <- aftercoviddplot + ggtitle('Median day on market per states After Covid') 
aftercoviddplot <- aftercoviddplot + theme(plot.title = element_text(hjust = 0.5))
aftercoviddplot

# before covid days on market
days <- tapply(beforeCovidd$median_days_on_market, beforeCovidd$stateName,mean)
state<-row.names(days)
daysonmarket <- data.frame(state,days)
daysonmarket$state <- tolower(daysonmarket$state)
beforecoviddplot <- ggplot(daysonmarket, aes(map_id = state)) +geom_map(map=us,aes(fill=days),color='black') 
beforecoviddplot <- beforecoviddplot + expand_limits(x=us$long,y=us$lat) + coord_map() + scale_fill_gradient(low='red',high='white')
beforecoviddplot <- beforecoviddplot + ggtitle('Median day on market per states Before Covid') 
beforecoviddplot <- beforecoviddplot + theme(plot.title = element_text(hjust = 0.5))
beforecoviddplot

p1 <- ggplot(data=t2,aes(x=state)) +geom_line(aes(y=aftercovidprice,group=1,color='after')) 
p1 <- p1 + geom_line(aes(y=beforecovidprice,group=1,color='before')) +geom_line(aes(y=duringcovidprice,group=1,color='during')) 
p1 <- p1 + geom_point(aes(y=aftercovidprice),color='red') +geom_point(aes(y=beforecovidprice),color='green') +geom_point(aes(y=duringcovidprice),color='blue')
p1 <- p1 + theme(axis.text.x= element_text(angle=90))
p1 + labs(color='legend')

# after covid days on market
days <- tapply(afterCovidd$median_days_on_market, afterCovidd$stateName,mean)
state<-row.names(days)
daysonmarket <- data.frame(state,days)
daysonmarket$state <- tolower(daysonmarket$state)
aftercoviddplot <- ggplot(daysonmarket, aes(map_id = state)) +geom_map(map=us,aes(fill=days),color='black') 
aftercoviddplot <- aftercoviddplot + expand_limits(x=us$long,y=us$lat) + coord_map() + scale_fill_gradient(low='red',high='white')
aftercoviddplot <- aftercoviddplot + ggtitle('Median day on market per states After Covid') 
aftercoviddplot <- aftercoviddplot + theme(plot.title = element_text(hjust = 0.5))
aftercoviddplot

# during covid days on market
days <- tapply(duringCovidd$median_days_on_market, duringCovidd$stateName,mean)
state<-row.names(days)
daysonmarket <- data.frame(state,days)
daysonmarket$state <- tolower(daysonmarket$state)
duringcoviddplot <- ggplot(daysonmarket, aes(map_id = state)) +geom_map(map=us,aes(fill=days),color='black') 
duringcoviddplot <- duringcoviddplot + expand_limits(x=us$long,y=us$lat) + coord_map() + scale_fill_gradient(low='red',high='white')
duringcoviddplot <- duringcoviddplot + ggtitle('Median day on market per states during Covid') 
duringcoviddplot <- duringcoviddplot + theme(plot.title = element_text(hjust = 0.5))
duringcoviddplot

#percentage change on days on market
str(before_day)

afterday <- tapply(afterCovidd$median_days_on_market, afterCovidd$stateName,mean)
beforeday <- tapply(beforeCovidd$median_days_on_market, beforeCovidd$stateName,mean)
after_day <- data.frame(row.names(afterday),afterday)
colnames(after_day)<- c('state','afterday')
before_day <- data.frame(row.names(beforeday),beforeday)
colnames(before_day)<- c('state','beforeday')
day_table <- merge(before_day, after_day, by='state')
day_table$percentchange <- abs((day_table$afterday/day_table$beforeday) -1)
#plot result for percentage change for days on market before and after covid
plot_day <- day_table[,c(1,4)]
plot_day$state <- factor(plot_day$state, levels = plot_day$state[order(plot_day$percentchange)])
ggplot(data = plot_day, aes(x=percentchange,y=state)) + geom_bar(stat="identity") + scale_fill_viridis_c() + ggtitle("days on market percentage change in different states")

#listing days on market for each state  bar chart
a1 <- melt(day_table[1:3], id='state')
str(day_table)
ggplot(data=a1,aes(y=state,x=value,fill=variable)) + geom_bar(width = 0.8,stat='identity')  + theme(axis.text.x= element_text(angle=90)) + scale_fill_brewer(palette="Paired") + theme_minimal() + ggtitle('listing days on market for each state')
mean(day_table[,4])
#map plot for days
day_table$state <- tolower(day_table$state)
map_day <- ggplot(day_table[,c(1,4)], aes(map_id = state)) + geom_map(map=us,aes(fill=percentchange),color='black') 
map_day <- map_day + expand_limits(x=us$long,y=us$lat) + coord_map() + scale_fill_gradient(low='white',high='red')
map_day + theme(axis.title.x = element_blank(), axis.title.y = element_blank(), axis.text.y = element_blank(), axis.text.x=element_blank())
map_day + ggtitle("days on market percentage change")

lmdata <- newdata
scatter.smooth(x=afterCovid$median_listing_price, y=duringCovid$median_listing_price,beforeCovid$median_listing_price)
cor.data <- select(newdata,-c('county_name'))
  #newprojectdata[,c('median_days_on_market','median_listing_price','total_listing_count','median_listing_price_mm','median_listing_price_yy','active_listing_count_mm')]
str(cor.data)
cor.data
c<-cor(x=cor.data)
cor(x= newprojectdata$median_listing_price,select(newprojectdata))
any(is.na(newdata))

two.way <- aov(aftercovidprice ~ beforecovidprice + duringcovidprice, data = t2)
summary(two.way)

ap <- data.frame(tapply(afterCovid$median_listing_price, afterCovid$stateName,mean))
ap$state <- rownames(ap)
dp <- data.frame(tapply(duringCovid$median_listing_price, duringCovid$stateName,mean))
dp$state <- rownames(dp)
bp <- data.frame(tapply(beforeCovid$median_listing_price, beforeCovid$stateName,mean))
bp$state <- rownames(bp)
str(price)
t1 <- merge(ap,dp, by = 'state')
t2 <- merge(t1,bp, by='state')
one.anova <- aov(aftercovidprice ~ beforecovidprice, data = t2)
summary(one.anova)
str(t2)
test1 <- newprojectdata[c('month_date_yyyymm','median_listing_price','county_name','median_days_on_market')]


#svm
packages=c("arulesViz", "kernlab","e1071","gridExtra","ggplot2", "caret", "arules")
package.check <- lapply(packages, FUN = function(x) {
  if (!require(x, character.only = TRUE)) {
    install.packages(x, dependencies = TRUE)
    library(x, character.only = TRUE)
  }
})

#verify they are loaded
svmData <- newdata[c('')]
search()

# train test split
randIndex <- sample(1:dim(newdata)[1])
nrow(newdata)
cutpoint2_3 <- floor(2*nrow(newdata)/3)
cutpoint2_3
trainData <- newdata[randIndex[1:cutpoint2_3],]
dim(trainData)
head(trainData)
testData <- newdata[randIndex[(cutpoint2_3+1):nrow(newdata)],]
str(testData)
any(is.na(testData))
colnames(trainData)

#month_date_yyyymm + county_name + median_days_on_market+median_square_feet+new_listing_count+total_listing_count
#Linear model
projectlm <- lm(median_listing_price~month_date_yyyymm + county_name + median_days_on_market+median_square_feet+new_listing_count+total_listing_count, data=trainData)
summary(projectlm)
lm_pred1 <- predict(projectlm,testData)

# root mean squared error for linear model
lm_table1<- data.frame(testData[,4],lm_pred1)
colnames(lm_table1) <- c("test","Pred")
sqrt(mean((lm_table1$test-lm_table1$Pred)^2))


# ksvm model
projectksvm <- ksvm(median_listing_price~., # set "Ozone" as the target predicting variable; "." means use all other variables to predict "Ozone"
                  data = trainData, # specify the data to use in the analysis
                  kernel = "rbfdot", # kernel function that projects the low dimensional problem into higher dimensional space
                  kpar = "automatic",# kpar refer to parameters that can be used to control the radial function kernel(rbfdot)
                  C = 10, # C refers to "Cost of Constrains"
                  cross = 5, # use 10 fold cross validation in this model
                  prob.model = TRUE # use probability model in this model
)
projectksvm
summary(projectksvm)
ksvm_pred <- predict(projectksvm, testData)
summary(ksvm_pred)
str(testData[4])

# root mean squared error for ksvm model
compTable <- data.frame(testData[,4], ksvm_pred[,1])
colnames(compTable) <- c("test","Pred")
#Root Mean Squared Error
sqrt(mean((compTable$test-compTable$Pred)^2))

# svm
projectsvm <- svm(median_listing_price~county_name + month_date_yyyymm + median_days_on_market+median_square_feet+new_listing_count+total_listing_count,data=trainData,kernel="radial",C=10,cross=10,prob.model=TRUE)
summary(projectsvm)
projectsvmpred <- predict(projectsvm, testData, type= "votes")
# root mean squared error for svm model
compTable <- data.frame(testData[,4], projectsvmpred)
colnames(compTable) <- c("test","Pred")
#Root Mean Squared Error
sqrt(mean((compTable$test-compTable$Pred)^2))




#lm
colnames(aot) <- c('count_name','price_after','price_before')
str(aot)
randIndex <- sample(1:dim(aot)[1])
nrow(aot)
cutpoint2_3 <- floor(2*nrow(aot)/3)
cutpoint2_3
trainData <- aot[randIndex[1:cutpoint2_3],]
dim(trainData)
head(trainData)
any(is.na(testData))
str(testData)
testData <- aot[randIndex[(cutpoint2_3+1):nrow(aot)],]
lm_p <- lm(price_after~price_before, data =trainData)
summary(lm_p)
lm_pred <- predict(lm_p,testData)


