calcul_BB<-fonction(num,df){
  start_index <- num  # Indice à partir duquel on commence
  x <- 20    
  if (start_index + x - 1 <= nrow(df)) {
    # Sous-ensemble des x lignes à partir du start_index
    subset_df <- df[start_index:(start_index + x - 1), ]
    
    # Calcul de la moyenne pour chaque colonne
    mean_values <- colMeans(subset_df)
    
    # Affiche les moyennes des colonnes
    print(mean_values)
  } else {
    print("Erreur : Les indices dépassent le nombre de lignes du data frame")
  }
  
  
  
  
  
  
  return (l,u,m)
}
class(`EURUSD=X`)
EURUSD=as.data.frame(`EURUSD=X`)
EURUSD$date=rownames(EURUSD)
head(EURUSD
     )
EURUSD |> 
head(EURUSD
     )
