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

#model = PAR(entity_columns=entity_columns,  context_columns=context_columns, sequence_index=sequence_index)
#model.fit(data)
#new_data = model.sample(1)
#new_data.head()
#model.save('my_model.pkl')

#loaded = PAR.load('my_model.pkl')

#print(loaded.sample(num_sequences=1).head())






#df = pd.read_csv (r'C:\Users\ND.COM\Desktop\PIDE\Research\ML and Inflation Prediction\Data\pakistan_inflationtrial.csv')   #read the csv file (put 'r' before the path string to address any special characters in the path, such as '\'). Don't forget to put the file name at the end of the path + ".csv"
df = pd.read_csv(r'C:\Users\ND.COM\VS Quantecon\lecture-julia.notebooks\quarterly_cpi_yony.csv')   #read the csv file (put 'r' before the path string to address any special characters in the path, such as '\'). Don't forget to put the file name at the end of the path + ".csv"
print (df)




dataframe = pd.DataFrame(df,columns=['Quarter', 'CPI_Quarterly_YonY'])

dataframe["Quarter"] = dataframe["Quarter"].astype("datetime64")
dataframe = dataframe.set_index("Quarter")
print(dataframe)




#entity_columns = ['Country']

#context_columns = ['quarterly_annualized_inflation']

#sequence_index = 'Quarter'


for simulation in range(1, 1):
 model = PAR()
 model.fit(dataframe)
 new_data = model.sample(1)
 new_data["Quarter"] = df["Quarter"]
 new_data["Quarter"] = new_data["Quarter"].astype("datetime64")
 new_data = new_data.set_index("Quarter")
 new_data.head()
 model.save('inflationPAR_model.pkl')

 loaded = PAR.load('inflationPAR_model.pkl')

 print(loaded.sample(num_sequences=1).head())

 plt.plot(loaded.sample(num_sequences=1), linewidth = 3)
 plt.plot(new_data["CPI_Quarterly_YonY"], linewidth = 3)


 
plt.xlabel("Quarter")
plt.ylabel("Quarterly Inflation (CPI and YonY)")
plt.title("Synthetic Inflation Rate With PAR Model (5 Simulations)")
plt.tick_params(axis='x',labelsize=15,rotation=90)
plt.tight_layout()
plt.show()








































