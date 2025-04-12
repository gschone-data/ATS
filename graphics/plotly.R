library(quantmod)
library(ggplot2)
library(dplyr)
library(lubridate)
library(TTR)
library(plotly)
library(patchwork)

generer_graphique <- function(symbole, periode) {
  # Téléchargement des données
  getSymbols(symbole, auto.assign = TRUE)
  
  # Préparation des données
  data <- get(symbole) |> 
    fortify() |> 
    rename(
      Date = Index,
      Open = paste0(symbole, ".Open"),
      High = paste0(symbole, ".High"),
      Low = paste0(symbole, ".Low"),
      Close = paste0(symbole, ".Close")
    ) |> 
    mutate(Date = as.Date(Date)) |> 
    filter(complete.cases(Open, High, Low, Close))
  
  # Conversion de période
  data_period <- data |> 
    mutate(
      Period = case_when(
        periode == "daily" ~ Date,
        periode == "weekly" ~ ceiling_date(Date, "week"),
        periode == "monthly" ~ ceiling_date(Date, "month"),
        periode == "quarterly" ~ ceiling_date(Date, "quarter"),
        periode == "semiannual" ~ ceiling_date(Date, "6 months"),
        periode == "annual" ~ ceiling_date(Date, "year")
      )
    ) |> 
    group_by(Period) |> 
    summarise(
      Open = first(Open),
      High = max(High),
      Low = min(Low),
      Close = last(Close),
      .groups = "drop"
    )
  nb_ligne<-min(nrow(data_period),30)
  nb_boll<-min(nb_ligne,20)
  nb_m7<-min(nb_ligne,7)
  # Calcul des indicateurs SUR TOUTES LES DONNÉES
  data_tech <- data_period |> 
    mutate(
      M7 = TTR::SMA(Close, nb_m7),
      BB_up = TTR::BBands(Close, n = nb_boll, sd = 2)[, "up"],
      BB_dn = TTR::BBands(Close, n = nb_boll, sd = 2)[, "dn"],
      M20=TTR::SMA(Close, nb_boll),
      SAR = as.vector(TTR::SAR(cbind(High, Low), accel = c(0.02, 0.2)))
    )

  data_tech|> tail(30)->data_tech
 
  data_tech <- data_tech|>
    mutate(
      color_M7 = ifelse(M7 < lag(M7), "#0000FF", "#FF0000"),#|> replace_na("#808080"),
      color_SAR = ifelse(SAR> Close, "#0000FF", "#FF0000"),#|> replace_na("#808080"),
      color_M20 = ifelse(M20 < lag(M20), "#0000FF", "#FF0000"),#|> replace_na("#808080"),
      color_up = ifelse(BB_up < lag(BB_up), "#0000FF", "#FF0000"),#|> replace_na("#808080"),
      color_dn = ifelse(BB_dn < lag(BB_dn), "#0000FF", "#FF0000")#|> replace_na("#808080")
    )->data_tech
  data_tech <- data_tech |> 
    mutate(
      x_pos = 1:nb_ligne,  # Position numérique du facteur
      x_open = x_pos - 0.3,        # Décalage à gauche pour Open
      x_close = x_pos + 0.3        # Décalage à droite pour Close
    )
  nb_ok=T
  if (nb_ligne<20){nb_ok=F;data_tech$BB_up=NA;data_tech$BB_dn=NA;data_tech$M20=NA}
  if (nb_ligne<7){data_tech$m7=NA}
  # Ajout du texte pour le tooltip
  data_tech <- data_tech |> 
    mutate(
      tooltip_text = paste0(
        "<b>Date :</b> ", Period,
        "<br><b>Open :</b> ", round(Open, 2),
        "<br><b>Close :</b> ", round(Close, 2),
        "<br><b>High :</b> ", round(High, 2),
        "<br><b>Low :</b> ", round(Low, 2),
        "<br><b>M7 :</b> ", round(M7, 2),
        "<br><b>M20 :</b> ", round(M20, 2),
        "<br><b>Boll Sup :</b> ", round(BB_up, 2),
        "<br><b>Boll Inf :</b> ", round(BB_dn, 2),
        "<br><b>SAR :</b> ", round(SAR, 2)
      )
    )
  
  
  # Création du graphique ggplot2
  p <- ggplot(data_tech,  aes(x = as.factor(Period),text=tooltip_text)) +
    # Segments pour High-Low
    geom_segment(aes(xend = as.factor(Period), y = Low, yend = High), color = "black",linewidth = 0.4) +
    
    # Segments Open / close
   
    geom_segment(aes(x = x_open, xend = x_open + 0.3, y = Open, yend = Open), color = "black", linewidth = 0.4) +
    geom_segment(aes(x = x_close-0.3, xend = x_close, y = Close, yend = Close), color = "black", linewidth = 0.4) +
    
    
    # indicateurs
    geom_segment(aes(y = lag(M7), yend=M7,x=x_pos-1,xend=x_pos, color = color_M7),linewidth = 0.6) +
    
    # SAR avec couleurs dynamiques
    geom_point(aes(y = SAR, color = color_SAR),shape = 18, size = 1) +

    labs(
      title=paste(periode),
      x=NULL,
      y=NULL
    ) +
    
    scale_x_discrete(breaks = levels(as.factor(data_tech$Period))[seq(1, length(levels(as.factor(data_tech$Period))), by = 4L)])+
    theme(axis.text.x = element_text(angle = 90, hjust = 1,size=6))+
    theme(legend.position = "none")
  if(nb_ok==T){
    p<-p+
      geom_segment(aes(y = lag(M20), yend=M20,x=x_pos-1,xend=x_pos, color = color_M20),linewidth = 0.6)+ 
      geom_segment(aes(y = lag(BB_up), yend=BB_up,x=x_pos-1,xend=x_pos, color = color_up),linewidth = 0.6)+
      geom_segment(aes(y = lag(BB_dn), yend=BB_dn,x=x_pos-1,xend=x_pos, color = color_dn),linewidth = 0.6)}
  # Conversion en graphique interactif avec Plotly
 
   ggplotly(p,tooltip="tooltip_text")
    
  
  
  }

# Exemple d'utilisation pour différentes périodes
#generer_graphique("ALNOV.PA", "weekly")
