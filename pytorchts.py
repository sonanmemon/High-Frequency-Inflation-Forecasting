print("Hello World")

# support for mxnet models, faster datasets
#pip install gluonts[mxnet,pro]  

# support for torch models, faster datasets
#pip install gluonts[torch,pro]

# pip install pytorchts

from turtle import pd
import pandas as pd
import torch
import matplotlib.pyplot as plt

from gluonts.dataset.common import ListDataset


from gluonts.dataset.util import to_pandas
from gluonts.dataset.pandas import PandasDataset
from gluonts.dataset.repository.datasets import get_dataset
from gluonts.model.deepar import DeepAREstimator
#from pts import Trainer
from gluonts.mx import Trainer






dataset = get_dataset("airpassengers")
print(dataset)


url = "https://raw.githubusercontent.com/numenta/NAB/master/data/realTweets/Twitter_volume_AMZN.csv"
df = pd.read_csv(url, header=0, index_col=0, parse_dates=True)
print(df)

#deepar = DeepAREstimator(prediction_length=12, freq="M", trainer=Trainer(epochs=5))
#model = deepar.train(dataset.train)

# Make predictions
#true_values = to_pandas(list(dataset.test)[0])
#true_values.to_timestamp().plot(color="k")

#prediction_input = PandasDataset([true_values[:-36], true_values[:-24], true_values[:-12]])
#predictions = model.predict(prediction_input)

#for color, prediction in zip(["green", "blue", "purple"], predictions):
 #   prediction.plot(color=f"tab:{color}")

#plt.legend(["True values"], loc="upper left", fontsize="xx-large")

#plt.show()


#for test_entry, forecast in zip(test_data, predictor.predict(test_data)):
  #  to_pandas(test_entry)[-60:].plot(linewidth=2)
  #  forecast.plot(color='g', prediction_intervals=[50.0, 90.0])
#plt.grid(which='both')













#Note that the forecasts are displayed in terms of a probability distribution
#: The shaded areas represent the 50% and 90% prediction intervals, respectively, centered around the median.

#https://github.com/awslabs/gluon-ts
#https://github.com/zalandoresearch/pytorch-ts
#https://pypi.org/project/pytorchts/

#https://www.kaggle.com/code/steverab/m5-forecasting-competition-gluonts-template/notebook

#@article{gluonts_arxiv,
 # author  = {Alexandrov, A. and Benidis, K. and Bohlke-Schneider, M. and
 #   Flunkert, V. and Gasthaus, J. and Januschowski, T. and Maddix, D. C.
  #  and Rangapuram, S. and Salinas, D. and Schulz, J. and Stella, L. and
  #  Türkmen, A. C. and Wang, Y.},
 # title   = {{GluonTS: Probabilistic Time Series Modeling in Python}},
 # journal = {arXiv preprint arXiv:1906.05264},
 # year    = {2019}
#}






#url = "https://raw.githubusercontent.com/numenta/NAB/master/data/realTweets/Twitter_volume_AMZN.csv"
#df = pd.read_csv(url, header=0, index_col=0, parse_dates=True)

