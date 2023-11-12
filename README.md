# Melbourne-Housing-Data
Statistical Analysis and Regression with R

## Data available at Kaggle: https://www.kaggle.com/datasets/anthonypino/melbourne-housing-market
On the link above you can find a description of variables and more info about the dataset

The goal of analysis was to gain general insight into the housing market in Melbourne, focusing on Price. 
I analyzed the relationship of Price with other variables (through correlation analysis and multiple linear regression analysis).

### Note: I will not display nor explain all of the results in this file. Some graphs will be shown here, and some comments will be provided. I believe that you can get the conclusion by looking at the graph, so I will not comment on everything. Also, correlation and regression analysis together with conclusion will be shown and explained at the end. You can find the rest of the analysis together with some comments in R.file.

### Prior to analysis the pre-processing of data was done (Removing NAs, adding additional column and organizing data). After that, some statistics with visual representation of findings and comments. 

## Let's start

#### Prior to analysis, I wanted to gain some insights on our dependend variable - Price. 
<img src="https://user-images.githubusercontent.com/82513917/204154751-0b56fd1c-1e9e-405a-83e5-8a8c005c3df3.png" width="600" height="600">

According to the boxplot we can see some outliers in the data
Price summary :  Min Price: $85,000 - Mean Price: $1,075,684  -  Max Price: $9,000,000

#### Furtherly, I did some data exploration in order to see relationship between variables.


<img src="https://user-images.githubusercontent.com/82513917/204154988-84e3b70e-2b27-44ca-99c4-77f21dab4144.png" width="600" height="600">


<img src="https://user-images.githubusercontent.com/82513917/204155058-bc395469-63c1-4513-9e00-08cd56a210af.png" width="600" height="600">


<img src="https://user-images.githubusercontent.com/82513917/204155188-6e7ca243-1b9c-4086-9f15-f8016778f78b.png" width="600" height="600">


<img src="https://user-images.githubusercontent.com/82513917/204155808-362190e6-8707-4ea2-a1a6-8eb6b884cc73.png" width="600" height="600">


<img src="https://user-images.githubusercontent.com/82513917/204156003-6fe24952-b057-4b99-a68d-b6a449eb6243.png" width="600" height="600">


### Correlation analysis

<img src="https://user-images.githubusercontent.com/82513917/204155272-f7c337ca-7d36-46e9-9e54-8ce6fa7350f1.png" width="600" height="600">

### Conclusions from the correlation plot above: 

##### Weak Positive Correlation:
 Age and Price -
 Car and Price

##### Stronger Positive Correlation
Rooms and Price -
Bathrooms and Price -
Bedroom2 and Price - 
Building Area and Price

##### Distance and YearBuilt have negative correlation with Price



I will only display relationship between Distance and Price. As we can see the relationship is negative, meaning that houses with lower distance have higher price.

<img src="https://user-images.githubusercontent.com/82513917/204155405-6b51962b-638e-433d-8339-61b5ff6bc909.png" width="600" height="600">




### We come to the main part of analysis - Regression model.
<img src="https://user-images.githubusercontent.com/82513917/204155513-ed457d80-bd1e-436d-9ad8-1aa8c3f8ba31.png" width="600" height="600">

As we can see, I only keept variables that have statistically significant influence on Price (p < 0.05).
According to the R-squared, 54.02% of the variance in the dependent variable is explained by the model.

<img src="https://user-images.githubusercontent.com/82513917/204155570-68d024a4-d5fa-4457-b28f-510046a22530.png" width="600" height="600">

Above, we can see the coefficients of regression model. Therefore, we can conclude following: 

FOR every one unit increase in:

-Rooms, Price will increase  by $115,636.81 

-Distance, Price will decrease  by $30,264.10

-Bathroom, Price will increase by $258,546.26

-Car, Price will increase  by $50,916.41

-Landsize, Price will increase  by  $22.97

-BuildingArea, Price will increase  by  $1854.62

-YearBuilt, Price will decrease  by  $4,510.59

To put it simply, the number of bathrooms, number of rooms, and parking space for car will have the highest influence on the Price of the apartment. 


