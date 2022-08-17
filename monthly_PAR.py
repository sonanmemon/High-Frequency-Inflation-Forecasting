print("Hello World")
from sdv.demo import load_timeseries_demo
data = load_timeseries_demo()

print(data.head())


#entity_columns = ['Symbol']

#context_columns = ['MarketCap', 'Sector', 'Industry']

#sequence_index = 'Date'


from sdv.timeseries import PAR
from turtle import pd
import pandas as pd
import copy
import torch
import matplotlib.pyplot as plt
import matplotlib.dates as mdates

from gluonts.dataset.common import ListDataset


from gluonts.dataset.util import to_pandas
from gluonts.dataset.pandas import PandasDataset
from gluonts.dataset.repository.datasets import get_dataset
from gluonts.model.deepar import DeepAREstimator
#from pts import Trainer
from gluonts.mx import Trainer










df_month = pd.read_csv(r'C:\Users\ND.COM\VS Quantecon\lecture-julia.notebooks\CPI_Monthly.csv')   #read the csv file (put 'r' before the path string to address any special characters in the path, such as '\'). Don't forget to put the file name at the end of the path + ".csv"
print(df_month)


dataframe = pd.DataFrame(df_month,columns=['Month', 'CPI_YonY'])
print(dataframe)

#dataframe = pd.to_datetime(dataframe.Month)
dataframe.Month = pd.to_datetime(dataframe.Month)
print(dataframe)

#dataframe["Month"] = dataframe["Month"].astype("datetime64")
dataframe = dataframe.set_index("Month")
print(dataframe)

TestData = dataframe[:-21] # To end at 2020 Month 7

print(TestData)


TrainData = TestData[:-33] #Different cuts for test data, 33 months, 69 months and 105 month cuts respectively.
#TrainData = TestData[:-69]
#TrainData = TestData[:-105]
print(TrainData)




training_data = ListDataset(
    [{"start": TrainData.index[0], "target": TrainData.CPI_YonY}], freq = "Q"
)

test_data = ListDataset(
    [{"start": TestData.index[0], "target": TestData.CPI_YonY}],
    freq = "Q"
)



print(training_data)

print(test_data)

print(dataframe)


estimator = DeepAREstimator(prediction_length=36, freq="M", trainer=Trainer(epochs=5))
predictor = estimator.train(training_data=training_data, num_workers=4)

for test_entry, forecast in zip(test_data, predictor.predict(test_data)):
    to_pandas(test_entry)[-174:].plot(linewidth=2)
    forecast.plot(color='r', prediction_intervals=[5.0, 30.0])

#plt.grid(which='both')
plt.grid()
#plt.xlabel("Month", fontweight='bold', color = 'orange', fontsize='17', horizontalalignment='center')
plt.xticks([])
plt.ylabel("Montly Inflation (CPI and YonY)")
plt.title("36 Month Ahead Forecasts From Probabilistic TS Model")
#plt.tick_params(axis='x',labelsize=15)
plt.tight_layout()
#plt.xticks(rotation=45)
plt.show()

#plt.xlim(2006, 2023)


#fig, ax = plt.subplots()
#ax.xaxis.set_major_locator(mdates.MonthLocator())
#fmt = mdates.DateFormatter('%b %Y')
#ax.xaxis.set_major_formatter(fmt)
#ax.plot(temp.tMin)
#ax.plot(temp.tMax)
#ax.fill_between(temp.index, temp.tMin, temp.tMax, color='#AOEOAO', alpha = 0.2)
#plt.setp(ax.get_xticketlabels(), rotation = 45);

















