api_key <- "EGCV0CPVOK4ND6OO"
api_key<-"Z5J4P28YYRE9ZVYR"
periodes=c("Weekly","Monthly")

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

convert_to_df <- function(time_series) {
  # Conversion de la liste de séries temporelles en data frame
  df <- map_df(time_series, ~as.data.frame(t(.x)), .id = "Date")
  
  # Conversion des colonnes en valeurs numériques et la date en format Date
  df <- df %>%
    mutate(across(-Date, as.numeric)) %>%
    mutate(Date = as.Date(Date))
  
  return(df)
}

for (per in periodes){
  for (instru in liste_alpha){
    assign(paste0(instru,per),
            convert_to_df(
              forex_data_list[[{{instru}}]][[{{tolower(per)}}]][[paste0("Time Series FX (",per,")")]]))
  }
}
str(forex_data_list)
forex_data_list$`USD/JPY`$weekly$`Time Series FX (Weekly)` |> head()

