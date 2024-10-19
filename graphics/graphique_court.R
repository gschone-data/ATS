faire_graph_cour<-function(df){
# Créer un graphique OHLC
fig <- df |> 
  plot_ly(x = ~Date, 
          type = "ohlc", 
          open = ~Open, 
          high = ~High, 
          low = ~Low, 
          close = ~Close)   #|> 
  # layout(title = "Graphique OHLC",
  #        xaxis = list(title = "Date de cotation"),
  #        yaxis = list(title = "Prix"))

# Afficher le graphique
return(fig)}
