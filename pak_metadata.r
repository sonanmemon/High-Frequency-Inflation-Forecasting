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
cpi_2004 <- subset(new_data$CPI_YoY, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01')) 




imports_2004 <- subset(new_data$imports, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))
exports_2004 <- subset(new_data$exports, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))

taxrevenue_2004 <- subset(new_data$tax_revenue, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))

m2_2004 <- subset(new_data$m2, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))


erVSUSD_2004 <- subset(new_data$erVSUSD, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))

SRrate_2004 <- subset(new_data$SR_Rate, data$Quarter >= as.POSIXct('2004-10-01') & data$Quarter <= as.POSIXct('2020-04-01'))



m1_2004 <- ts(m1_2004, start = c(2004,4), frequency = 4)

cpi_2004 <- ts(cpi_2004, start = c(2004,4), frequency = 4)

imports_2004 <- ts(imports_2004, start = c(2004,4), frequency = 4)


exports_2004 <- ts(exports_2004, start = c(2004,4), frequency = 4)

taxrevenue_2004 <- ts(taxrevenue_2004, start = c(2004,4), frequency = 4)

m2_2004 <- ts(m2_2004, start = c(2004,4), frequency = 4)

erVSUSD_2004 <- ts(erVSUSD_2004, start = c(2004,4), frequency = 4)

SRrate_2004 <- ts(SRrate_2004, start = c(2004,4), frequency = 4)

IC2004 <- VARselect(cbind(cpi_2004,m1_2004, imports_2004, exports_2004, taxrevenue_2004
                          , m2_2004, erVSUSD_2004, SRrate_2004), type="both", lag.max=12)



print(IC2004)





print(IC2004$selection)



#estimation

var_data <- cbind(cpi_2004, imports_2004, exports_2004, taxrevenue_2004
                        , m2_2004, SRrate_2004)

#colnames(var_data) <- c('cpi_96', 'imports')
#convert vector to data frame
colnames(var_data) <- c("CPI","Imports","Exports","Tax_Revenue", "M2", "SR_Rate")
var_data <- as.data.frame(var_data)
head(var_data)
date <- seq(from = as.Date("2004-10-01"), to = as.Date("2020-04-01"), by = 'quarter')
#var_data <- ts(var_data, start=c(1991, 3), end=c(2020, 2), frequency=3)
var_data$date <- date
head(var_data)


var_model <- VAR(var_data[, 1:6], p = 7, type = "both")
#summary(var_model)
print(var_model)
stargazer(var_model[["varresult"]], header = FALSE, type = 'text')




forecast <- predict(var_model, n.ahead = 4, ci = 0.95)

forecast

fanchart(forecast, names = "cpi_2004", main = "Fanchart for CPI (Inflation)", xlab = "Horizon (Quarters)", ylab = "CPI_YonY")




FEVD1 <- fevd(var_model, n.ahead = 8)

#plot(FEVD1, beside = TRUE)

#plot(FEVD1, oma = c(3, 0, 0, 0))

plot(FEVD1, args.legend = list(x = nrow(FEVD1[[1]]) + 4.7,  y = 0.7))





















































m1 <- ts(m1, start = c(1991,3), frequency = 4)
cpi <- ts(cpi, start = c(1991,3), frequency = 4)
cpi_96 <- ts(cpi_96, start = c(1996,1), frequency = 4)

imports <- ts(imports, start = c(1996,1), frequency = 4)
exports <- ts(exports, start = c(1996,1), frequency = 4)


#var_data <- 
IC <- VARselect(cbind(cpi,m1), type="both", lag.max=12)


IC2 <- VARselect(cbind(imports,exports), type="both", lag.max=12)

IC3 <- VARselect(cbind(cpi_96,imports), type="both", lag.max=12)

print(IC$criteria)

print(IC)

print(IC3$criteria[1,])

AIC_Criteria <- as.matrix(IC$criteria[1,])

print(IC3$selection)


print(IC3$selection[1])

#AIC_Criteria

#row.names(AIC_Criteria) <- 1:12
#colnames(AIC_Criteria) <- "AIC (Akaike Information Criteria)"
#print(AIC_Criteria)

#maxlag <- 12
#plot(AIC_Criteria, type="n", ylim=c(min(AIC_Criteria),max(AIC_Criteria)))
#text(1:maxlag, AIC_Criteria[,1], 1:maxlag)

pacf <- as.matrix(acf(cpi, plot=TRUE, lag.max=12,type="partial")$acf)

#pacf <- as.matrix(acf(exports, plot=TRUE, lag.max=12,type="partial")$acf)

#acf <- as.matrix(acf(cpi, plot=TRUE, lag.max=12))






#estimation

var_data <- cbind(cpi_96, imports)

colnames(var_data) <- c('cpi_96', 'imports')
#convert vector to data frame
var_data <- as.data.frame(var_data)
head(var_data)
date <- seq(from = as.Date("1996-01-01"), to = as.Date("2020-04-01"), by = 'quarter')
#var_data <- ts(var_data, start=c(1991, 3), end=c(2020, 2), frequency=3)
var_data$date <- date
head(var_data)



var_model <- VAR(var_data[,1:2], p = 7, type = "both")
summary(var_model)
print(var_model)
stargazer(var_model[["varresult"]], header = FALSE, type = 'text')




forecast <- predict(var_model, n.ahead = 8, ci = 0.95)

#forecast <- data.frame(forecast)


#https://cran.r-project.org/web/packages/ggfan/vignettes/geom_fan.html


#geom_fan(mapping = NULL, data = forecast, stat = "interval",  position = "identity", show.legend = NA, inherit.aes = TRUE,
        #   intervals = (0:100)/100, ...)
  


#ggplot(fake_df, aes(x=x,y=y)) +geom_fan()

#tikz(file = "cpi_forecasts1.tex", width = 6, height = 3.7)





fanchart(forecast, names = "cpi_96", main = "Fanchart for CPI (Inflation)", xlab = "Horizon (Quarters)", ylab = "CPI_YonY")

#print(fanchart(forecast, names = "cpi_96", main = "Fanchart for CPI", xlab = "Horizon", ylab = "CPI_YonY"))
#dev.off()



#fanchart(forecast, names = "imports", main = "Fanchart for Imports", xlab = "Horizon", ylab = "Imports")




FEVD1 <- fevd(var_model, n.ahead = 10)
FEVD1
plot(FEVD1)

















#estimation

var_data <- cbind(cpi,m1)

colnames(var_data) <- c('CPI_YonY', 'M1')
#convert vector to data frame
var_data <- as.data.frame(var_data)
head(var_data)
date <- seq(from = as.Date("1991-07-01"), to = as.Date("2020-04-01"), by = 'quarter')
#var_data <- ts(var_data, start=c(1991, 3), end=c(2020, 2), frequency=3)
var_data$date <- date
head(var_data)



var_model <- VAR(var_data[,1:2], p = 5, type = "both")
summary(var_model)
print(var_model)
stargazer(var_model[["varresult"]], header = FALSE, type = 'text')




forecast <- predict(var_model, n.ahead = 1, ci = 0.95)
forecast

















#reg_output <- stargazer(linear_reg, header=FALSE, type='text', out = "reg1.txt")

#stargazer(eqAR_Mogas_PACF, eqAR_Mogas_1, 
#eqAR_Mogas_2, eqAR_Mogas_3, eqAR_Mogas_4, type = 'text', omit = "Constant", keep.stat = c("n", "rsq"))
#mogas_forecast <- exp(4.329953)



#decomposition <- fevd(var_model, n.ahead = 8)
#dat <- map_df(decomposition, ~as.data.frame(.x), .id="id") %>%
#  mutate(horizon = rep(1:10, 2))
#pivot_longer(names_to = "var", cols = c(CPI))

#ggplot(data = dat, mapping = aes(x = horizon, y = value, fill = var)) +
#  facet_wrap(~id) +
#  geom_bar(stat = "identity") +
 # theme_bw()

#head(dat)





