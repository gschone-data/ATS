
date_fin <- Sys.Date()
date_debut <- make_date(year(date_fin) - 30, 1, 1)
# Liste des paires de devises (par exemple EUR/USD, USD/JPY, etc.)

for (item in liste_instruments_yahoo){
  as.data.frame(
    getSymbols(item, src = "yahoo", from = date_debut, to = date_fin))
}
for(instrument in liste_instruments_yahoo){
  assign(instrument,as.data.frame(get(instrument)) |> rownames_to_column())
}

for(instrument in liste_instruments_yahoo){
  pattern=paste0("^",{{instrument}},".")
  assign(instrument,
         get(instrument) |> 
           rename_with(~ str_replace(.,paste0({{instrument}},"."), ""), starts_with({{instrument}})))
  
}
