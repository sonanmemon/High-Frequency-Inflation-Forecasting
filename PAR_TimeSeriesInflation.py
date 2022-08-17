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

from gluonts.dataset.common import ListDataset


from gluonts.dataset.util import to_pandas
from gluonts.dataset.pandas import PandasDataset
from gluonts.dataset.repository.datasets import get_dataset
from gluonts.model.deepar import DeepAREstimator
#from pts import Trainer
from gluonts.mx import Trainer






df = pd.read_csv(r'C:\Users\ND.COM\VS Quantecon\lecture-julia.notebooks\quarterly_cpi_yony.csv')   #read the csv file (put 'r' before the path string to address any special characters in the path, such as '\'). Don't forget to put the file name at the end of the path + ".csv"
print (df)




dataframe = pd.DataFrame(df,columns=['Quarter', 'CPI_Quarterly_YonY'])

dataframe["Quarter"] = dataframe["Quarter"].astype("datetime64")
dataframe = dataframe.set_index("Quarter")
print(dataframe)





TestData = dataframe

print(TestData)

#Train = copy.copy(TrainData)



#Train = Test[:239]
#new_column = ['Train']
#Train.rename(columns = {'Test' : 'Train'}, inplace=True)
#Train = pd.DataFrame(Train)
#Train["Quarter"] = df["Quarter"]
#Train["Quarter"] = Train["Quarter"].astype("datetime64")
#Train = Train.set_index("Quarter")
#Train.head()
#print(Train)
#experiment = TrainData + 2
#print(experiment)
#Train = pd.DataFrame(Train, columns = new_column)
#Train = pd.read_csv('out.csv', header = None, names=new_column)


#TrainData = TestData[:-11]
#TrainData = TestData[:-23]
TrainData = TestData[:-35]


print(TrainData)





#Train = pd.DataFrame(Train, columns = new_column)
#Train = pd.read_csv('out.csv', header = None, names=new_column)







#Test["Quarter"] = df["Quarter"]
#Test["Quarter"] = Test["Quarter"].astype("datetime64")
#Test = Test.set_index("Quarter")
#Test.head()

training_data = ListDataset(
    [{"start": TrainData.index[0], "target": TrainData.CPI_Quarterly_YonY}], freq = "Q"
)

test_data = ListDataset(
    [{"start": TestData.index[0], "target": TestData.CPI_Quarterly_YonY}],
    freq = "Q"
)

print(training_data)

estimator = DeepAREstimator(prediction_length=12, freq="Q", trainer=Trainer(epochs=5))
predictor = estimator.train(training_data=training_data, num_workers=4)





for test_entry, forecast in zip(test_data, predictor.predict(test_data)):
    to_pandas(test_entry)[-58:].plot(linewidth=2)
    forecast.plot(color='r', prediction_intervals=[5.0, 30.0])
plt.grid(which='both')
plt.xlabel("Quarter")
plt.ylabel("Quarterly Inflation (CPI and YonY)")
plt.title("Forecasts From Probabilistic TS Model")
plt.tick_params(axis='x',labelsize=15)
plt.tight_layout()
plt.show()













#print(predictions)

#predictions.plot()

#model = deepar.train(Train.Train)
#print(df[['Name', 'Qualification']])
#Report_Card.loc[:,"Grades"]


#prediction_input = PandasDataset([true_values[:-34], true_values[:-23], true_values[:-11]])
#predictions = predictor.predict(prediction_input)

# Make predictionsa
#true_values = TestData
# Make predictions
#true_values = to_pandas(list(dataset.test)[0])
#true_values.to_timestamp().plot(color="k")

#for color, prediction in zip(["green", "blue", "purple"], predictions):
   # prediction.plot(color=f"tab:{color}")

#plt.legend(["True values"], loc="upper left", fontsize="xx-large")

#plt.show()

#https://sagemaker-examples.readthedocs.io/en/latest/introduction_to_amazon_algorithms/deepar_synthetic/deepar_synthetic.html








