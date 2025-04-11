library(xts)
library(zoo)

calculer_MA7 <- function(xts_obj) {
  # Vérification de l'entrée
  if (!is.xts(xts_obj)) {
    stop("L'objet doit être de classe xts")
  }
  
  # Extraction des cours de clôture
  close_prices <- Cl(xts_obj)
  
  # Calcul des moyennes mobiles
  ma7 <- rollmean(close_prices, k = 7, fill = NA, align = "right")
  
  # Fusion des résultats
  result <- merge(xts_obj, ma7)
  colnames(result)<-c(colnames(xts_obj),"MA7")
  return(result)
}
for (i in list_fin){
  tmp<-get(i)
  tmp<-calculer_MA(tmp)
  assign(i,tmp)
}

calculer_bollinger <- function(xts_obj, n = 20, sd = 2) {
  # Vérification de l'entrée
  if (!is.xts(xts_obj)) stop("L'objet doit être de classe xts")
  
  # Extraction des cours de clôture
  close_prices <- Cl(xts_obj)
  
  # Calcul de la moyenne mobile
  ma20 <- rollmean(close_prices, k = n, fill = NA, align = "right")
  
  # Calcul de l'écart-type mobile
  sd20 <- rollapply(close_prices, width = n, 
                    FUN = sd, fill = NA, align = "right")
  
  # Calcul des bandes
  upper_band <- ma20 + sd * sd20
  lower_band <- ma20 - sd * sd20
  
  # Création du nouvel objet xts
  result <- merge(xts_obj, 
                  ma20,
                  upper_band,
                  lower_band)
  
  colnames(result)=c(colnames(xts_obj),"MA20","U20","L20")
  
  return(result)
}

calculer_sar <- function(xts_obj, accel = c(0.02, 0.2)) {
  # Vérification de l'entrée
  if (!is.xts(xts_obj)) stop("L'objet doit être de classe xts")
    # Extraction des prix Haut (High) et Bas (Low)
  colLow<-colnames(xts_obj)[endsWith(colnames(xts_obj),"Low")]
  colHigh<-colnames(xts_obj)[endsWith(colnames(xts_obj),"High")]
  high_low <- xts_obj[,c(colLow,colHigh)]
  high_low<-high_low[rowSums(is.na(high_low))<ncol(high_low)]
  # Calcul du Parabolic SAR
  parabolic_sar <- SAR(high_low, accel = accel)
  
  # Ajout du Parabolic SAR à l'objet xts
  xts_obj$Parabolic_SAR <- parabolic_sar
  
  return(xts_obj)
}

calculer_sar(GOLD)
