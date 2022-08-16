print("Hello World")

from sdv.demo import load_tabular_demo
data = load_tabular_demo('student_placements')
print(data.head())

from sdv.tabular import GaussianCopula

model = GaussianCopula()

model.fit(data)

new_data = model.sample(num_rows=200)

print(new_data.head())



model.save('my_model.pkl')

loaded = GaussianCopula.load('my_model.pkl')

new_data = loaded.sample(num_rows=200)

print(new_data)


import pandas as pd
import matplotlib.pyplot as plt

df = pd.read_csv (r'C:\Users\ND.COM\VS Quantecon\lecture-julia.notebooks\quarterly_cpi_yony.csv')   #read the csv file (put 'r' before the path string to address any special characters in the path, such as '\'). Don't forget to put the file name at the end of the path + ".csv"
print (df)


dataframe = pd.DataFrame(df,columns=['CPI_Quarterly_YonY', 'Quarter'])

#dataframe = pd.DataFrame(df,columns=['Country', 'Quarter', 'Population', 'quarterly_annualized_inflation', 'quarterly_nonannualized_inflation'])

dataframe["Quarter"] = dataframe["Quarter"].astype("datetime64")

dataframe = dataframe.set_index("Quarter")
print(dataframe)





# Plot
#plt.plot(dataframe["quarterly_annualized_inflation"], linewidth = 3)
plt.plot(dataframe["CPI_Quarterly_YonY"], linewidth = 3)


# Labelling 

plt.xlabel("Quarter")
plt.ylabel("Quarterly Inflation (CPI and Year on Year)")
plt.title("Quarterly Inflation in Pakistan")

# Display
plt.tick_params(axis='x',labelsize=15,rotation=90)
plt.tight_layout()
plt.show()

#Synthetic Inflation Generation

#for simulation in range(1, 1001):
 #import pandas as pd
 #import matplotlib.pyplot as plt
    
 #df = pd.read_csv(r'C:\Users\ND.COM\VS Quantecon\lecture-julia.notebooks\pakistan_inflation1970.csv')   
 #read the csv file (put 'r' before the path string to address any special characters in the path, such as '\'). Don't forget to put the file name at the end of the path + ".csv"



import pandas as pd
import matplotlib.pyplot as plt

model = GaussianCopula()

#inflation_data = pd.DataFrame(df,columns=['quarterly_annualized_inflation', 'quarterly_nonannualized_inflation'])
inflation_data = pd.DataFrame(df,columns=['CPI_Quarterly_YonY'])


model.fit(inflation_data)

inflation_data = model.sample(num_rows=250)

print(inflation_data.head())


model.save('inflation_model.pkl')

loaded = GaussianCopula.load('inflation_model.pkl')

inflation_data = loaded.sample(num_rows=250)

print(inflation_data)


inflation_data["Quarter"] = df["Quarter"]
#inflation_data["Country"] = df["Country"]


inflation_data["Quarter"] = inflation_data["Quarter"].astype("datetime64")

inflation_data = inflation_data.set_index("Quarter")

print(inflation_data)

#plt.plot(inflation_data["quarterly_annualized_inflation"], linewidth = 3)
plt.plot(inflation_data["CPI_Quarterly_YonY"], linewidth = 3)
# Labelling 

plt.xlabel("Quarter")
plt.ylabel("Quarterly Inflation Rate (CPI and Year on Year)")
plt.title("Synthetic Quarterly Inflation For Pakistan")

# Display
plt.tick_params(axis='x',labelsize=15,rotation=90)
#plt.tight_layout()
#plt.show()

#for x in range(2, 6):
#  print(x)

for simulation in range(1, 501):
 model = GaussianCopula()
 inflation_data = pd.DataFrame(df,columns=['CPI_Quarterly_YonY'])
 model.fit(inflation_data) 
 inflation_data = model.sample(num_rows=250)
 #print(inflation_data.head())
 inflation_data["Quarter"] = df["Quarter"]
 inflation_data["Quarter"] = inflation_data["Quarter"].astype("datetime64")
 inflation_data = inflation_data.set_index("Quarter")
 #print(inflation_data)
 #plt.figure()
 plt.plot(inflation_data["CPI_Quarterly_YonY"], linewidth = 3)
 
 
 
plt.xlabel("Quarter")
plt.ylabel("Quarterly Inflation Rate (CPI and YonY)")
plt.title("Synthetic Inflation Rate For Pakistan (500 Simulations)")
plt.tick_params(axis='x',labelsize=15,rotation=90)
plt.tight_layout()
plt.show()



#for i in states[0][0][1:20]:
   #     df = quandl.get("FMAC/HPI_"+i, authtoken="yourtoken" )
     #   df.reset_index(inplace=True, drop=False)
    #    plt.plot('Date','Value',data=df)


# plt.plot(x[j],y[j])
#plt.xlabel('Date')
#plt.ylabel('Value')
#plt.title('House prices')
#plt.show()




