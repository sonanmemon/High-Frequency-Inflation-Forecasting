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
library(scales)
ds_theme_set()
library(tikzDevice)
require(tikzDevice)




data <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/ML and Inflation Prediction/Data/Pak_Inflation1.csv")



head(data)


inflation_data <- data[-(1:14), ]



head(inflation_data)


CPI_1957 <- read_csv("C:/Users/ND.COM/Desktop/PIDE/Research/ML and Inflation Prediction/Data/CPI_1957.csv")


head(CPI_1957)

CPI_1957 <- ts(CPI_1957, start = c(1957,1), frequency = 12)

CPI_1957 <- data.frame(CPI_1957)

head(CPI_1957)



CPI_1957 <- CPI_1957[, -1]

head(CPI_1957)

CPI_1957$Month <- seq(from = as.Date("1957-01-01"), to = as.Date("2022-06-01"), by = 'month')

head(CPI_1957)

tikz(file = "PakInflation_Monthly.tex", width = 6, height = 3.7)





graph <- ggplot(CPI_1957) +
  geom_line(aes(x=Month, y=CPI_YonY), color = "blue") +
  scale_x_date(breaks=date_breaks("35 months"), date_labels = "%Y-%m") +
  scale_y_continuous(breaks = c(-10, -5, 0, 5, 10, 15, 20, 25, 30, 35, 40)) +
  #geom_hline(yintercept=mean(data$GDP), linetype="dashed", color = "black") +
  #scale_x_continuous(breaks = c("Month$1958-01-01", 1970, 1980, 1990, 2000, 2010, 2020)) +
  labs(x = "Month", y = "Monthly Inflation Rate (Annualized)", title = "Inflation in Pakistan") +
  theme(plot.title = element_text(hjust = 0.5), axis.text.x=element_text(angle=90))



#graph









#This line is only necessary if you want to preview the plot right after compiling
#Necessary to close or the tikxDevice .tex file will not be written
print(graph)
dev.off()
















#Linear trend separation

#data


#trend <- lm(data$index ~ c(1:length(data$index)))


#plot(resid(trend), type="l")  # resid(trModel) contains the de-trended series.


#HP Filter



#hpindex <- hpfilter(data$index, freq = 1600, type=c("lambda","frequency"),drift=FALSE)

#plot(hpindex)





#lims <- as.POSIXct(strptime(c("2011-01-01 03:00","2011-01-01 16:00"), format = "%Y-%m-%d %H:%M")) 

#scale_x_datetime(
#  breaks = seq(as.POSIXct("1958-01-01"),
#           as.POSIXct("2020-06-01"), "1 month"),
# labels = date_format("%b"),
#expand = c(0, 0)
#limits = c(
#  as.POSIXct("2012-02-09 00:00:00 CET"),
#  as.POSIXct("2012-02-11 00:00:00 CET")
#) +

#scale_x_datetime(labels = date_format("%b"))+

#lims <- as.POSIXct(strptime(c("1958-01-01","2022-06-01"), format = "%Y-%m-%d")) 
#ggplot(df, aes(x=dates, y=times)) + 
#  geom_point() + 
# scale_y_datetime(limits =lims, breaks=date_breaks("4 hour"), labels=date_format("%H:%M"))+ 
# theme(axis.text.x=element_text(angle=90))






