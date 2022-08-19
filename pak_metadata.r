library(dslabs)
library(dplyr)
library(ggplot2)
options(stringsAsFactors = FALSE)
library(tidyverse)
library(gridExtra)
library(Lahman)
library(dslabs)
library(AER)
library(tseries)
#library(TSstudio)
library(dynlm)
library(broom)
library(stargazer)
library(forecast)
library(mFilter)
library(data.table)
library(caTools)
library(scales)
library(grid)
library(gridExtra)
library(AER)
library(plm)
library(tidyr)
library(vars)
library(glmnet)
ds_theme_set()
library(tikzDevice)
require(tikzDevice)








data <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/ML and Inflation Prediction/Data/pak_metadata.csv")



data


data <- data[-(1:339),]

head(data$time)

data <- ts(data, start = c(1950,2), frequency = 3)

data <- data.frame(data)

tail(data)



data$Quarter <- seq(from = as.Date("1950-04-01"), to = as.Date("2020-07-01"), by = 'quarter')



data <- data[,-(1:2)]

data <- data[-(1:32),]

head(data)

#mean(Quarterly_CPI$CPI_Quarterly_YonY)

#Points where new variables are added are stated below e.g 1991/Q1, 2009/Q1. 
#Starting point has at least 3 non-inflation data variables are available
#At 1991/Q3, we have M1, M2 and VS/USD data available (3 non-inflation variables).
#More than 3 are available after 1995/Q4 and so on.

#1991/Q3, 1995/Q4, 2004/Q1, 2006Q2. 2009/Q1, 2011/Q1, 2013/Q1, 2015/Q1


mean(data$m1, na.rm = TRUE)

mean(data$m2, na.rm = TRUE)

mean(data$erVSUSD, na.rm = TRUE)






inflation <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/ML and Inflation Prediction/Data/quarterly_cpi_yony.csv")

tail(inflation)



inflation <- ts(inflation, start = c(1958,2), frequency = 3)

inflation <- data.frame(inflation)

inflation$quarter <- seq(from = as.Date("1958-04-01"), to = as.Date("2020-07-01"), by = 'quarter')


head(inflation)



data$CPI_YoY <- inflation$CPI_Quarterly_YonY





head(data)

new_data <- data[, -(1:2)]



new_data <- new_data[, -(2)]



new_data <- new_data[, -(3:4)]

new_data <- new_data[, -(3:4)]

new_data <- new_data[, -(13)]

new_data <- new_data[, -(14)]

new_data <- new_data[, -(14)]

new_data <- new_data[, -(14)]

new_data <- new_data[, -(4)]




head(new_data)



#new_data starts from 1958Q2 and ends at 2020 Q3.






#length(cpi) <- length(m1) <- max(c(length(cpi), length(m1)))

#cbind(cpi, m1)

tail(data)


m1 <- subset(data$m1, data$Quarter >= as.POSIXct('1991-07-01') & data$Quarter <= as.POSIXct('2020-04-01'))
cpi <- subset(data$CPI_YoY, data$Quarter >= as.POSIXct('1991-07-01') & data$Quarter <= as.POSIXct('2020-04-01')) 

cpi_96 <- subset(data$CPI_YoY, data$Quarter >= as.POSIXct('1996-01-01') & data$Quarter <= as.POSIXct('2020-04-01')) 
cpi_96


imports <- subset(data$imports, data$Quarter >= as.POSIXct('1996-01-01') & data$Quarter <= as.POSIXct('2020-04-01'))
exports <- subset(data$exports, data$Quarter >= as.POSIXct('1996-01-01') & data$Quarter <= as.POSIXct('2020-04-01'))




m1_2004 <- subset(new_data$m1, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))
m1_2006 <- subset(new_data$m1, data$Quarter >= as.POSIXct('2006-04-01') & data$Quarter <= as.POSIXct('2020-04-01'))


cpi_2004 <- subset(new_data$CPI_YoY, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01')) 

cpi_2006 <- subset(new_data$CPI_YoY, data$Quarter >= as.POSIXct('2006-04-01') & data$Quarter <= as.POSIXct('2020-04-01')) 
cpi_2006


imports_2004 <- subset(new_data$imports, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))
exports_2004 <- subset(new_data$exports, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))


imports_2006 <- subset(new_data$imports, data$Quarter >= as.POSIXct('2006-04-01') & data$Quarter <= as.POSIXct('2020-04-01')) 
exports_2006 <- subset(new_data$exports, data$Quarter >= as.POSIXct('2006-04-01') & data$Quarter <= as.POSIXct('2020-04-01')) 

exports_2006


taxrevenue_2004 <- subset(new_data$tax_revenue, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))
taxrevenue_2006 <- subset(new_data$tax_revenue, data$Quarter >= as.POSIXct('2006-04-01') & data$Quarter <= as.POSIXct('2020-04-01'))





m2_2004 <- subset(new_data$m2, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))

m2_2006 <- subset(new_data$m2, data$Quarter >= as.POSIXct('2006-04-01') & data$Quarter <= as.POSIXct('2020-04-01'))


erVSUSD_2004 <- subset(new_data$erVSUSD, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))




SRrate_2004 <- subset(new_data$SR_Rate, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))

SRrate_2006 <- subset(new_data$SR_Rate, data$Quarter >= as.POSIXct('2006-04-01') & data$Quarter <= as.POSIXct('2020-04-01'))



short_term_externaldebt2006 <- subset(new_data$short_term_externaldebt, data$Quarter >= as.POSIXct('2006-04-01') & data$Quarter <= as.POSIXct('2020-04-01'))






m1_2004 <- ts(m1_2004, start = c(2004,4), frequency = 4)

cpi_2004 <- ts(cpi_2004, start = c(2004,4), frequency = 4)

imports_2004 <- ts(imports_2004, start = c(2004,4), frequency = 4)


exports_2004 <- ts(exports_2004, start = c(2004,4), frequency = 4)

taxrevenue_2004 <- ts(taxrevenue_2004, start = c(2004,4), frequency = 4)

m2_2004 <- ts(m2_2004, start = c(2004,4), frequency = 4)

erVSUSD_2004 <- ts(erVSUSD_2004, start = c(2004,4), frequency = 4)

SRrate_2004 <- ts(SRrate_2004, start = c(2004,4), frequency = 4)







m1_2006 <- ts(m1_2006, start = c(2006,2), frequency = 4)

cpi_2006 <- ts(cpi_2006, start = c(2006,2), frequency = 4)
cpi_2006

imports_2006 <- ts(imports_2006, start = c(2006,2), frequency = 4)


exports_2006 <- ts(exports_2006, start = c(2006,2), frequency = 4)

taxrevenue_2006 <- ts(taxrevenue_2006, start = c(2006,2), frequency = 4)

m2_2006 <- ts(m2_2006, start = c(2006,2), frequency = 4)



SRrate_2006 <- ts(SRrate_2006, start = c(2006,2), frequency = 4)

short_term_externaldebt2006 <- ts(short_term_externaldebt2006, start = c(2006,2), frequency = 4)


IC2004 <- VARselect(cbind(cpi_2004,m1_2004, imports_2004, exports_2004, taxrevenue_2004
                          , m2_2004, erVSUSD_2004, SRrate_2004), type="both", lag.max=12)

IC2006 <- VARselect(cbind(cpi_2006, imports_2006, taxrevenue_2006, 
                          m2_2006, SRrate_2006, short_term_externaldebt2006), type="both", lag.max=12)

print(IC2004)








print(IC2006$selection)

#estimation



var_data2006 <- cbind(cpi_2006, imports_2006, taxrevenue_2006, 
                  m2_2006, SRrate_2006, short_term_externaldebt2006)

smallvar_data2006 <- cbind(cpi_2006, imports_2006)

IC2006_small <- VARselect(cbind(cpi_2006, imports_2006), type="both", lag.max=12)
print(IC2006_small$selection)
#ts_plot(cpi_2006)

autoplot(cpi_2006)
autoplot(imports_2006)
autoplot(taxrevenue_2006)
autoplot(m2_2006) #clear upward trend
autoplot(SRrate_2006)
autoplot(short_term_externaldebt2006)



pp.test(cpi_2006) #non-stationary
pp.test(imports_2006) #stationarity accepted at 10% significance.
pp.test(taxrevenue_2006) #stationrity accepted at less than 1% signifiance level.
pp.test(m2_2006) #Non-stationary
pp.test(SRrate_2006) #non-stationary
pp.test(short_term_externaldebt2006) #non-stationary













colnames(var_data2006) <- c("CPI","Imports", "Tax_Revenue", "M2", "SR_Rate", "External Debt")
colnames(smallvar_data2006) <- c("CPI", "Imports")
var_data2006 <- as.data.frame(var_data2006)
smallvar_data2006 <- as.data.frame(smallvar_data2006)
date2006 <- seq(from = as.Date("2006-04-01"), to = as.Date("2020-04-01"), by = 'quarter')
#var_data <- ts(var_data, start=c(1991, 3), end=c(2020, 2), frequency=3)
var_data2006$date2006 <- date2006
smallvar_data2006$date2006 <- date2006
head(smallvar_data2006)



var_model2006 <- VAR(var_data2006[, 1:6], p = 7, type = "both")
smallvar_model2006 <- VAR(smallvar_data2006[, 1:2], p = 6, type = "both")
#summary(var_model)
#print(var_model2006)
stargazer(var_model2006[["varresult"]], header = FALSE, type = 'text')

stargazer(smallvar_model2006[["varresult"]], header = FALSE, type = 'text')



forecast2006 <- predict(var_model2006, n.ahead = 12, ci = 0.95)

forecast2006

smallvarforecast <- predict(smallvar_model2006, n.ahead = 12, ci = 0.95)

smallvarforecast

fanchart(forecast2006, names = "cpi_2006", main = "Fanchart for CPI (Big VAR)", xlab = "Horizon (Quarters)", ylab = "CPI_YonY")


fanchart(smallvarforecast, names = "cpi_2006", main = "Fanchart for CPI (Imports' VAR)", xlab = "Horizon (Quarters)", ylab = "CPI_YonY")








FEVD_2006 <- fevd(var_model2006, n.ahead = 12)



#plot(FEVD1, beside = TRUE)

#plot(FEVD1, oma = c(3, 0, 0, 0))

plot(FEVD_2006, args.legend = list(x = nrow(FEVD_2006[[1]]) + 7,  y = 0.7))


pacf <- as.matrix(acf(cpi_2006, plot=TRUE, lag.max=12,type="partial")$acf)

acf <- as.matrix(acf(cpi_2006, plot=TRUE, lag.max=12))


Serial1 <- serial.test(var_model2006, lags.pt = 8, type = "PT.asymptotic") #serial autocorrelation test

Serial2 <- serial.test(smallvar_model2006, lags.pt = 7, type = "PT.asymptotic") #serial autocorrelation test

Serial1
Serial2


Arch1 <- arch.test(var_model2006, lags.multi = 8, multivariate.only = TRUE) #heteroskedasticity
Arch2 <- arch.test(smallvar_model2006, lags.multi = 6, multivariate.only = TRUE) #heteroskedasticity
Arch1
Arch2


Norm1 <- normality.test(var_model2006, multivariate.only = TRUE)
Norm2 <- normality.test(smallvar_model2006, multivariate.only = TRUE)#Normality for distribution of residuals
Norm1
Norm2


Stability1 <- stability(var_model2006, type = "OLS-CUSUM") #The stability test is for testing structural breaks
Stability2 <- stability(smallvar_model2006, type = "OLS-CUSUM") 
plot(Stability1)

print(Stability2)

















#https://towardsdatascience.com/a-deep-dive-on-vector-autoregression-in-r-58767ebb3f06

#NExT: take the monthly inflation predictions from cubic interpolation
#and compare them with actual inflation series. Calculate forecast error. Take these series from Julia.


#Python: Compare simulations with actual data and calculate forecast error.


















