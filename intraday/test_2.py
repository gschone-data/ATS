import os
import pandas as pd
import datetime as dt
#from gestion_artefact import load_intr

df_old=pd.read_csv('donnees.csv')
#now=dt.datetime.now()
#df_old['dow']=pd.to_datetime(df_old['date']).dt.weekday

x=df_old['date'].groupby(pd.to_datetime(df_old['date']).dt.weekday).count()
print(x)
df_old2=df_old[pd.to_datetime(df_old['date']).dt.weekday.isin([0,1,2,3,4])] # on garde que les jours de semain

print(df_old)