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
library(stargazer)
library(forecast)
library(mFilter)
library(data.table)
library(caTools)
ds_theme_set()
library(tikzDevice)
require(tikzDevice)




data <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/ML and Inflation Prediction/Data/pakistan_inflation1970.csv")



head(data)


data <- ts(data, start = c(1970,1), frequency = 3)


data <- data.frame(data)






data <- data[, -1]

head(data)

data <- data[, -1]


data


data$quarter <- seq(from = as.Date("1970-01-01"), to = as.Date("2021-01-01"), by = 'quarter')


head(data)

graph1 <- ggplot(data) +
  geom_line(aes(x=quarter, y=quarterly_annualized_inflation), color = "blue") +
  #geom_hline(yintercept=mean(data$GDP), linetype="dashed", color = "black") +
  #scale_x_continuous(breaks = c(1970, 1975, 1980, 1985, 1990, 1995, 2000, 2005,2010, 2015, 2020)) +
  labs(x = "Quarter", y = "Quarterly Inflation (Annualized)", title = "Inflation in Pakistan")

graph1






tikz(file = "pakistan_inflation.tex", width = 6, height = 3.7)








graph1 <- ggplot(data) +
  geom_line(aes(x=quarter, y=quarterly_annualized_inflation), color = "blue") +
  #geom_hline(yintercept=mean(data$GDP), linetype="dashed", color = "black") +
  #scale_x_continuous(breaks = c(1970, 1975, 1980, 1985, 1990, 1995, 2000, 2005,2010, 2015, 2020)) +
  labs(x = "Quarter", y = "Quarterly Inflation (Annualized)", title = "Inflation in Pakistan")









#This line is only necessary if you want to preview the plot right after compiling
print(graph1)
#Necessary to close or the tikxDevice .tex file will not be written
dev.off()













graph2 <- ggplot(data) +
  geom_line(aes(x=quarter, y=quarterly_nonannualized_inflation), color = "blue") +
  #geom_hline(yintercept=mean(data$GDP), linetype="dashed", color = "black") +
  #scale_y_continuous(breaks = c(50, 70, 86, 90,  110)) +
  labs(x = "Quarter", y = "Quarterly Inflation (Non-Annualized)", title = "Inflation in Pakistan")

graph2





data_monthlyinf <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/ML and Inflation Prediction/Data/monthlyinf_pakistan.csv")





head(data_monthlyinf)





data_monthlyinf <- ts(data_monthlyinf, start = c(2020, 1), frequency = 12)





data_monthlyinf <- data.frame(data_monthlyinf)









data_monthlyinf$DATE <- seq(from = as.Date("2020-01-01"), to = as.Date("2022-06-01"), by = 'month')





data_monthlyinf <- data_monthlyinf[, -1]



head(data_monthlyinf)



tikz(file = "pakistan_monthlyinf202022.tex", width = 6, height = 3.7)


monthlyinf <- ggplot(data_monthlyinf) +
  geom_line(aes(x=DATE, y=Inflation_YonY), color = "blue") +
  #geom_hline(yintercept=mean(data$GDP), linetype="dashed", color = "black") +
  #scale_y_continuous(breaks = c(50, 70, 86, 90,  110)) +
  labs(x = "Month", y = "Monthly Inflation Rate (Year on Year)", title = "Recent Inflation in Pakistan")



#This line is only necessary if you want to preview the plot right after compiling
print(monthlyinf)
#Necessary to close or the tikxDevice .tex file will not be written
dev.off()








