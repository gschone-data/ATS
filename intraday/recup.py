import pandas as pd
import yfinance as yf
import yaml
from datetime import datetime
import pyarrow as pa
import pyarrow.parquet as pq
open('~/ATS/ATS/intraday/liste.yaml', 'r') 
# Lire les symboles depuis le yaml
with open("~/ATS/ATS/intraday/liste.yaml", 'r') as f:
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
        "close": info['Close'].values,
        "high": info['High'].values,
        "low": info['Low'].values
    })

df_new = pd.DataFrame(data)

try:
    df_old = pd.read_parquet('donnees.parquet')
    df = pd.concat([df_old, df_new]).sort_values(['date','heure'])
    df = df.tail(50)
except FileNotFoundError:
    df = df_new

df.to_parquet('donnees.parquet')
