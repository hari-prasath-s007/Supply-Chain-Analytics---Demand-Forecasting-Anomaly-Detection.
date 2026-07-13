# ---
# jupyter:
#   jupytext:
#     text_representation:
#       extension: .py
#       format_name: percent
#       format_version: '1.3'
#       jupytext_version: 1.19.4
#   kernelspec:
#     display_name: Python 3 (ipykernel)
#     language: python
#     name: python3
# ---

# %%
import pandas as pd
import numpy as np
###############################################Load the Excel file########################################
df= pd.read_excel(r"C:\Users\Hari\Downloads\Supply_Chain_Analytics_Dataset_5000_Records.xlsx")
###############################################Understand the Dataset####################################
df.head()

# %%
#########################Check summary statistics
df.describe()

# %%
########################Check missing values
df.isnull().sum()


# %%
##################################################################Data Cleaning###############################################
############################Remove duplicate records
df.drop_duplicates(inplace=True)
#############################Fill missing values
df.fillna(0, inplace=True)

# %%
#######################################################Convert the date column##################################################
df["Order_Date"] = pd.to_datetime(df["Order_Date"])

# %%
########################################################Check data types###########################################################
df.dtypes

# %%
######################################################Feature Engineering(Create new columns that help in analysis)############
#####################Extract the year
df["Year"] = df["Order_Date"].dt.year
######################Extract the month
df["Month"] = df["Order_Date"].dt.month_name()
######################Extract the quarter
df["Quarter"] = df["Order_Date"].dt.quarter


# %%
#################################################Calculate profit#########################################################
df['Cost']=df['Revenue']*0.70
df["Profit"] = df["Revenue"] - df["Cost"]
print(df)



# %%
######################################################Exploratory Data Analysis (EDA)##########################################
#######################Find the total sales
df["Sales_Quantity"].sum()

# %%
######################Find the total revenue
df["Revenue"].sum()

# %%
#####################Find the average demand
df["Sales_Quantity"].mean()

# %%
##################Find region-wise sales
df.groupby("Region")["Revenue"].sum()

# %%
##################Find product-wise sales
df.groupby("Product")["Sales_Quantity"].sum()

# %%
#####################Find warehouse inventory
df.groupby("Warehouse")["Inventory"].sum()

# %%
#####################################################Time-Series Preprocessing################################################
df["Order_Date"] = pd.to_datetime(df["Order_Date"])

# %%
####################Set the date as the index
df.set_index("Order_Date", inplace=True)

# %%
###################Sort the data
df.sort_index(inplace=True)

# %%
#######################################################Create monthly sales totals############################################
monthly_sales = df["Sales_Quantity"].resample("ME").sum()

# %%
######################################################Create weekly sales totals#############################################
weekly_sales = df["Sales_Quantity"].resample("W").sum()

# %%
######################################################Time-Series Decomposition##############################################
#####################Import the required function
from statsmodels.tsa.seasonal import seasonal_decompose

# %%
###########################Decompose the monthly sales
result = seasonal_decompose(
    monthly_sales,
    model="additive"
)

# %%
##########################Display the plots
result.plot()

# %%
###################################################Demand Forecasting########################################################
################Create a simple moving average
forecast = monthly_sales.rolling(3).mean()

# %%
####################################################Anomaly Detection#########################################################
################Using the Z-score method
from scipy.stats import zscore

df["Z_Score"] = zscore(df["Sales_Quantity"])

df["Anomaly"] = abs(df["Z_Score"]) > 3

# %%
###############################################(actual → The real sales values)(predicted → The forecasted values from your model)#############
actual = [120,135,150,170]
predicted = [118,130,155,168]

# %%
#######################################################Model Evaluation###################################################
##########Calculate RMSE
from sklearn.metrics import mean_squared_error
import numpy as np

rmse = np.sqrt(
    mean_squared_error(actual, predicted)
)

# %%
##########################Calculate MAPE
import numpy as np

actual = np.array(actual)
predicted = np.array(predicted)

mape = np.mean(np.abs((actual - predicted) / actual)) * 100

print("MAPE:", mape)

# %%
##############################################Export the Results################################################################
df.to_excel(
    "Supply_Chain_Final.xlsx",
    index=False
)

# %%
print(df)


# %%
df.to_excel("Supply_Chain_Cleaned.xlsx", index=False)

print("✅ Cleaned dataset exported successfully!")

# %%
