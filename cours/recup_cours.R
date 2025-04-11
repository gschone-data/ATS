library(quantmod)

# Télécharger les données pour plusieurs symboles
symbols <- c("^FCHI", "^IXIC","^GDAXI",  "GC=F","SI=F","CL=F","EURUSD=X","USDJPY=X","GBPUSD=X","AUDUSD=X","USDCAD=X","USDCNY=X","USDCHF=X") # Exemple : S&P500, Dow Jones, Euro/USD, Or
getSymbols(symbols, src = "yahoo", from = "1995-01-01", to = "2025-04-11")

list_fin<-c("OIL","GOLD","DAX","CAC","NSQ","EURUSD","USDJPY","GBPUSD","AUDUSD","USDCAD","USDCNY","USDCHF")

OIL<-`CL=F`
GOLD<-`GC=F`
DAX<-GDAXI
CAC<-FCHI
NSQ<-IXIC
EURUSD<-`EURUSD=X`
USDJPY<-`USDJPY=X`
GBPUSD<-`GBPUSD=X`
AUDUSD<-`AUDUSD=X`
USDCAD<-`USDCAD=X`
USDCNY<-`USDCNY=X`
USDCHF<-`USDCHF=X`
rm("CL")
rm(list=c("FCHI", "IXIC","GDAXI","GC=F",,"CL=F","SI=F","EURUSD=X","USDJPY=X","GBPUSD=X","AUDUSD=X","USDCAD=X","USDCNY=X","USDCHF=X"))
