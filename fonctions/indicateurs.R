calcul_BB<-function(row_id,df,nb_periode=20){

  df <- df %>%
    fill(Close, .direction = "down")->df
  df |> rowid_to_column()->df
  debut=  row_id# Indice à partir duquel on commence
   if (nb_periode<=row_id) {
    # Sous-ensemble des x lignes à partir du start_index
    subset_df <- df[(debut-nb_periode+1):debut, ]
    
  # "ecart type du close"
    SD=sd(subset_df$Close)
    m20=mean(subset_df$Close)
    u<-m20+2*SD
    l<-m20-2*SD
    # Affiche les moyennes des colonnes
    } else {
  mean_values <-NA
  m20<-NA
  u<-NA
  l<-NA
    }
  

  return (c(l,u,m20))
}


calcul_BB(1,df)
class(`EURUSD=X`)
EURUSD=as.data.frame(`EURUSD=X`)
EURUSD$date=rownames(EURUSD)
head(EURUSD
     )
EURUSD |> 
head(EURUSD
     )
