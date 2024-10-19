

liste_alpha= c("EUR/USD","USD/JPY")

liste_yahoo <- c("EURUSD=X", "USDJPY=X")#, "GBP/USD", "USD/CHF")# "AUD/USD",
#"USD/CA=XD", "NZD/USD", "EUR/GBP", "EUR/JPY", "GBP/JPY")

source(~"/ATS/cours/cours_alpha.R")
source(~"/ATS/cours/cours_yahoo.R")

colnames_ok <- c("Date","Open","High","Low","Close")
colnames(`EUR/USDMonthly`)<-colnames_ok
df<-`EUR/USDMonthly`
colnames(df)<-colnames_ok
df
sub_df=df[1:30,]
faire_graph_cour(sub_df)
