
api_key <- "EGCV0CPVOK4ND6OO"
api_key<-"Z5J4P28YYRE9ZVYR"

    # Liste des paires de devises (par exemple EUR/USD, USD/JPY, etc.)
liste_instruments_yahoo <- c("EURUSD=X", "USDJPY=X")#, "GBP/USD", "USD/CHF")# "AUD/USD",
                       #"USD/CA=XD", "NZD/USD", "EUR/GBP", "EUR/JPY", "GBP/JPY")
liste_instruments<- c("EUR/USD","USD/JPY")
for (item in liste_instruments_yahoo){
as.data.frame(
  getSymbols(item, src = "yahoo", from = "2023-01-01", to = "2023-10-17"))
}
    # Fonction pour récupérer les données
get_forex_data <- function(symbol, interval = "daily", api_key) {
  url <- paste0("https://www.alphavantage.co/query?function=FX_", toupper(interval),
                "&from_symbol=", substr(symbol, 1, 3), 
                "&to_symbol=", substr(symbol, 5, 7), 
                "&apikey=", api_key)
  response <- GET(url)
      data <- fromJSON(content(response, "text", encoding = "UTF-8"))
      return(data)
    }

    # Boucle sur les instruments et récupérations de données
    forex_data_list <- list()

    for (instrument in liste_instruments) {
      forex_data_list[[instrument]] <- list(
       # daily = get_forex_data(instrument, interval = "daily", api_key),
        weekly = get_forex_data(instrument, interval = "weekly", api_key),
        monthly = get_forex_data(instrument, interval = "monthly", api_key)#,
        
        #yearly = get_forex_data(instrument, interval = "yearly", api_key)
        # trimestriel, semestriel et annuel ne sont pas toujours supportés par cette API,
        # il faudrait travailler avec les données mensuelles et les agréger manuellement.
      )
    }

    # Afficher les données
    print(forex_data_list)
class(forex_data_list)
