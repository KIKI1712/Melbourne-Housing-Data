library(corrplot)
library(ggplot2)
library(tidyr)
library(dplyr)

#Importing data set
housing <- read.csv("melb_data.csv")


################overview of a price 

summary(housing$Price)
quantile(housing$Price, c(.01, .05, .1, .25, .5, .75, .9, .95, .99))
ggplot(housing, aes(y=Price)) + geom_boxplot() + ggtitle("Price distribution") + theme(plot.title = element_text(hjust = 0.5)) 
#According to the boxplot we can see some outliers in the data
#some statistics
sd(housing_clean$Price) #we can see high standard deviation from the mean
max(housing_clean$Price) - min(housing_clean$Price) #difference between most expensive and cheapest house is  $8,869,000

sd(housing_clean$Price)/mean(sd(housing_clean$Price)) #Coefficient of variation is 1, which indicates high distribution in the Price variable

##########Function to determine outliers
outlier_function <- function(x){
  IQR <- IQR(x)
  first_quantile <- quantile(x, 0.25)
  third_quantile <- quantile(x, 0.75)
  upper_trash <- 1.5*IQR + third_quantile
  lower_trash <- 1.5*IQR - first_quantile
  
  outlier <- list(upper_outlier <- x[x>upper_trash], lower_outlier <- x[x<lower_trash])
  return(outlier)
}

#outliers in price
outlier_function(housing$Price)

#outliers in room
outlier_function(housing$Rooms)

#outliers in distance
outlier_function(housing$Distance)


################################ NA handling
#various ways to find NA
is.na(housing)
colSums(is.na(housing))
which(colSums(is.na(housing)) > 0)
names(which(colSums(is.na(housing)) > 0))

#I decided to TOTALY clean the data from NA
housing_clean <- housing[complete.cases(housing), ] 

#check
colSums(is.na(housing_clean))



##### Let's gain some insights

#Relationship between Region name and price
housing_clean %>% group_by(Regionname) %>% 
  summarise(min(Price), max(Price), meann = mean(Price), median(Price), quantile(Price, 0.25), quantile(Price, 0.75), no_houses <- n()) %>% 
  arrange(-meann) 


#Relationship between house type and Price
housing_clean %>% group_by(Type) %>%  summarise(min(Price), max(Price), meann = mean(Price), median(Price), no_houses <- n()) %>% arrange(-meann)


#Region, type and price relationship with plot
housing_clean %>% group_by(Regionname, Type) %>% summarise(meanp = mean(Price), meand = mean(Distance)) %>% 
  ggplot(aes(x=meand, y=meanp)) + geom_point(aes(color=Regionname, shape = Type)) + ylab("Mean Price") + xlab("Mean Distance")

housing %>% group_by(Regionname, Type) %>% count() %>% arrange(-n) #no. of houses per region and type
#Price and Number of rooms relationship
housing_clean %>% ggplot(aes(x=Rooms, y=Price)) + geom_bar(aes(color=Type), stat = "identity") + scale_x_continuous(breaks = c(1,2,3,4,5,6,7,8))


#analyzing suburbs - relationship between number of houses and price
housing_clean %>% group_by(Suburb) %>% summarise(No.houses = n(), Mean_Price = round(mean(Price))) %>% arrange(-No.houses) %>% 
  ggplot(aes(x = No.houses, y = Mean_Price)) + geom_point() 

#analyzing suburbs - relationship between number of rooms and price
housing_clean %>% group_by(Suburb) %>% summarise(meanr = mean(Rooms), meanp = mean(Price)) %>% 
  ggplot(aes(x = meanr, y = meanp)) + geom_point() 

#Costliest suburbs
housing_clean %>% group_by(Suburb) %>% summarise(median_price = median(Price), mean_price = mean(Price)) %>%  
  arrange(-median_price) %>% slice(1:10) %>%
  ggplot(aes(x = Suburb, y = median_price)) + geom_bar(stat='identity',colour="white")

#Price distribution (ignoring prices over 4mil for better visualization)
housing_clean %>% filter(Price  < 4000000) %>% 
  ggplot(aes(x=Price)) + geom_histogram(aes(color = Type),binwidth = 150000) + 
  scale_x_continuous(breaks = c(1000000,2000000,3000000,4000000),
                     labels = c("1Million","2Million","3Million","4Million")) + ggtitle("Price Distribution") + xlab("Price in $")

#Region popularity and house type 
housing_clean %>% ggplot(aes(x=Regionname)) + geom_bar(aes(fill = Type)) 

#distribution of number of rooms  
housing_clean %>%  ggplot(aes(x = Rooms)) + geom_histogram(aes(fill = Type)) +
  scale_x_continuous(breaks = c(1,2,3,4,5,6,7,8))

#Price and parking spots
housing_clean %>% ggplot(aes(y = Price, x = Car)) + geom_bar(stat = "identity") +
  scale_x_continuous(breaks = c(0,1,2,3,4,5,6,7,8,9,10)) + ggtitle("Price & Car parking spots") + theme_classic()

#Top years built by revenue
housing_clean %>% group_by(YearBuilt) %>% summarise(total_revenue=sum(Price)) %>% arrange(-total_revenue) %>% slice(1:10)
#Top Year built by no of house sold
housing_clean %>% group_by(YearBuilt) %>% summarise(no_sold = n()) %>% arrange(-no_sold) %>% slice(1:10)
  
#relationship between number of house sold and year built
housing_clean %>% group_by(YearBuilt) %>% summarise(no_sold = n(), total_revenue=sum(Price)) %>% arrange(-no_sold) %>% 
  ggplot(aes(x=no_sold, y=total_revenue)) + geom_point() + geom_smooth() #we can se positive linear relationship

#Which date sold the most houses and which least? 
str(housing_clean)
library(lubridate)
housing_clean$Date2 <- as.Date(housing_clean$Date, format =  "%d/%m/%Y")
housing_clean$Date2 <- format(housing_clean$Date2, "%m-%Y")

housing_clean %>% group_by(substr(Date2, 4,7)) %>% summarise(number_of_house_sold = n()) %>% arrange(number_of_house_sold) #more houses sold in 2016
housing_clean %>% group_by(Date2) %>% summarise(number_of_house_sold = n()) %>% arrange(number_of_house_sold) 


housing_clean %>% group_by(Date2) %>% summarise(number_of_house_sold = n(), suma = sum(Price)) %>% arrange(substr(Date2, 4,7)) %>% 
  ggplot(aes(x=Date2, y=number_of_house_sold)) + geom_point(aes(size=suma)) +
  scale_x_discrete(limits = c("02-2016","04-2016","05-2016", "06-2016","07-2016","08-2016","09-2016","10-2016","11-2016","12-2016","02-2017","03-2017","04-2017","05-2017","06-2017","07-2017","08-2017","09-2017")) +
  xlab("Date") + ggtitle("Number of house sold on a specific date")


############## Relationship between Price and other explanatory variables

#Room vs Price
housing_clean %>% ggplot(aes(x=Bedroom2, y = Price)) + geom_point(color = "blue") + scale_x_continuous(breaks = c(0,1,2,3,4,5,6,7,8,9,10)) +
  xlab("Room") + ggtitle("Room vs. Price")
#Distance vs Price
housing_clean %>% ggplot(aes(x=Distance, y = Price)) + geom_point(color = "blue") + scale_x_continuous(breaks = c(0,10,20,30,40,50)) +
  xlab("Distance") + ggtitle("Distance vs. Price")
#Bathroom vs Price
housing_clean %>% ggplot(aes(x=Bathroom, y = Price)) + geom_point(color = "blue") + scale_x_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  xlab("Bathroom") + ggtitle("Bathroom vs. Price")
#Car vs. PRice
housing_clean %>% ggplot(aes(x=Car, y = Price)) + geom_point(color = "blue") + scale_x_continuous(breaks = c(0,1,2,3,4,5,6,7,8)) +
  xlab("Car") + ggtitle("Car vs. Price")
#age vs Price (ignoring 1 outlier for the quality of graph)
housing_clean$Age <- 2022 - housing_clean$YearBuilt
housing_clean %>% filter(Age < 200) %>%  ggplot(aes(x=Age, y = Price)) + geom_point(color = "blue") +
  xlab("Age") + ggtitle("Age vs. Price")

################ CORRELATION
#qucik glance
cor(housing_clean[, c("Price", "Rooms")])
#let's add more variables
cor <- cor(housing_clean[, c("Price", "Rooms", "Distance", "Bedroom2", "Bathroom", "Car", "Landsize", "BuildingArea", "YearBuilt", "Lattitude", "Longtitude", "Propertycount", "Age")])
#plotting it
corrplot(cor)

# Weak Positive Correlation
# Age and Price
# Car and Price

# Stronger Positive Correlation
# Rooms and Price
# Bathrooms and Price
# Bedroom2 and Price
# Building Area and Price

#Distance and YearBuilt have negative correlation with Price

regression_model <- lm(Price ~ Rooms+Type+YearBuilt+Bathroom+Car+Landsize+Distance+BuildingArea+YearBuilt, data = housing_clean)
summary(regression_model)

#According to the R-squared, 54.02% of the variance in the dependent variable is explained by the model.


data.frame(regression_model$coefficients)

# FOR every one unit increase in:
#   
# Rooms, Price will increase  by $115,636.81 
# Distance, Price will decrease  by $30,264.10
# Bathroom, Price will increase by $258,546.26
# Car, Price will increase  by $50,916.41
# Landsize, Price will increase  by  $22.97
# BuildingArea, Price will increase  by  $1854.62
# YearBuilt, Price will decrease  by  $4,510.59


