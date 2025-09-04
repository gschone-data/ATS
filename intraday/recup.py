import pandas as pd
import yfinance as yf
import yaml
from datetime import datetime
import os
import sys
from gestion_artefact import load_intraday

path = os.path.abspath(os.path.join(os.path.dirname(__file__),".."))

# Lire les symboles depuis le yaml
with open(os.path.join(path, 'liste.yaml')) as f:
    symbols = yaml.safe_load(f)['symbols']

now = datetime.now()
data = []

for symbol in symbols:
    ticker = yf.Ticker(symbol)
    info = ticker.history(period="1d").tail(1)
    data.append({
        "symbole": symbol,
        "date": now.strftime("%Y-%m-%d"),
        "heure": now.strftime("%H:%M"),
        "close": info['Close'].values
    })
df_new = pd.DataFrame(data)
try: 
    df_old=load_intraday()
    df_combined = pd.concat([df_old, df_new])
    df = df_combined.sort_values(['symbole','date','heure']).groupby('symbole', group_keys=False).tail(50)
except ImportError as e:
    print(e)
    df = df_new
    # Ici, le reste du script continue ou tu peux ajouter un autre comportement


df.to_csv('donnees.csv',index=False)