library(quantmod)
library(ggplot2)
library(dplyr)
library(plotly)
library(lubridate)
library(stringr)

recup_symbol<-function(symbole){
  symbole_bis=symbole
  if(substr(symbole,1,1)=="^"){symbole_bis=substr(symbole,2,nchar(symbole))}
  tmp<-tryCatch(
    {getSymbols(symbole, auto.assign = TRUE)},
    error=function(e){
      return(NULL)
    }
  )
  if(is.null(tmp)){
    return(NULL)
  }
  return(get(symbole_bis))}
  


ceiling_ats<-function(x,periode){
  
  switch(periode,
         "daily" = floor_date(ceiling_date(x,"seconds"),"day"),
         "weekly"=floor_date(ceiling_date(week_start = 5,x,"weeks",change_on_boundary = FALSE),"day"),
         "monthly" =floor_date(ceiling_date(x, "month"),"day"),
         "quarterly" =floor_date(ceiling_date(x, "quarter"),"day"),
         "semiannual" = floor_date(ceiling_date(x, "6 months"),"day"),
         "annual"=floor_date(ceiling_date(x, "year"),"day"))
}



generer_graphique <- function(symbole, periode) {
  symbole_bis=symbole
  if(substr(symbole,1,1)=="^"){symbole_bis=substr(symbole,2,nchar(symbole))}
  #gestion periode
  
  data<-readRDS("temp/data.RDS")
  if(is.null(data)){
    data<-recup_symbol(symbole) |> as.data.frame()
    saveRDS(data,"temp/data.RDS")
    if(is.null(data)){return(NULL)}
    
  }
  symbole_cache<-str_replace(colnames(data)[1],".Open","")
  if(symbole_cache!=symbole_bis){
    data<-recup_symbol(symbole) |> as.data.frame()
    saveRDS(data,"temp/data.RDS")
    if(is.null(data)){return(NULL)}
    
  }  
    # Téléchargement des données
   # Préparation des données
  data |>  
    mutate(Date=row.names(data)) |> 
    rename(
      Open = paste0(symbole_bis, ".Open"),
      High = paste0(symbole_bis, ".High"),
      Low = paste0(symbole_bis, ".Low"),
      Close = paste0(symbole_bis, ".Close")
    ) |> 
    mutate(Date = as.Date(Date)) |> 
    filter(complete.cases(Open, High, Low, Close)) |> 
    select(Date,Open,High,Low,Close)->data
  
  #ajout date du jour
  data |> tail(1) ->data_last
  data_last_per<-ceiling_ats(as.Date(data_last$Date),periode)
  sys_per<-ceiling_ats(Sys.Date(),periode)
  ajout_val=0
  if(data_last_per!=sys_per){
    data_new<-data.frame(
      Date=Sys.Date(),
      Open=data_last$Close,
      High=data_last$Close,
      Low=data_last$Close,
      Close=data_last$Close)
      rbind(data,data_new)->data
      ajout_val=1
}
  
  # Conversion de période
  data_period <- data |> 
    mutate(
      Period=ceiling_ats(Date,periode)
      )|> 
    group_by(Period) |> 
    summarise(
      Open = first(Open),
      High = max(High),
      Low = min(Low),
      Close = last(Close),
      .groups = "drop"
    )
  nb_ligne<-min(nrow(data_period),30+ajout_val)
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

  data_tech|> tail(30+ajout_val)->data_tech
  data_tech <- data_tech|>
    mutate(
      color_M7 = ifelse(M7 <lag(M7),F,T ),#|> replace_na("#808080"),
      color_SAR = ifelse(SAR> Close, F,T),#|> replace_na("#808080"),
      color_M20 = ifelse(M20 <lag(M20), F, T),#|> replace_na("#808080"),
      color_BB_up = ifelse(BB_up < lag(BB_up), F, T),#|> replace_na("#808080"),
      color_BB_dn = ifelse(BB_dn < lag(BB_dn), F, T)#|> replace_na("#808080")
    )->data_tech
  data_tech <- data_tech |> 
    mutate(
      x_pos = 1:(nb_ligne),  # Position numérique du facteur
      x_open = x_pos - 0.3,        # Décalage à gauche pour Open
      x_close = x_pos + 0.3        # Décalage à droite pour Close
    )
  nb_ok=T
  if (nb_ligne<20){nb_ok=F;data_tech$BB_up=NA;data_tech$BB_dn=NA;data_tech$M20=NA}
  if (nb_ligne<7){data_tech$m7=NA}
  
  
  
  # Ajout du texte pour le tooltip
  #si devise round 4, sinon round 2
  nb_round=4
  if(grepl("\\^",symbole)==TRUE){
    nb_round=2}
  data_tech <- data_tech |> 
    mutate(
      tooltip_text = paste0(
        "<b>Date :</b> ", Period,
        "<br><b>Open :</b> ", round(Open, nb_round),
        "<br><b>Close :</b> ", round(Close, nb_round),
        "<br><b>High :</b> ", round(High, nb_round),
        "<br><b>Low :</b> ", round(Low, nb_round),
        "<br><b>M7 :</b> ", round(M7, nb_round),
        "<br><b>M20 :</b> ", round(M20, nb_round),
        "<br><b>Boll Sup :</b> ", round(BB_up, nb_round),
        "<br><b>Boll Inf :</b> ", round(BB_dn, nb_round),
        "<br><b>SAR :</b> ", round(SAR, nb_round)
      )
    )
  
  oggy <- as.factor(data_tech$Period)[22]
  jack <- as.factor(data_tech$Period)[9]
  
  saveRDS(data_tech,"temp/data_tech.RDS")
  # Création du graphique ggplot2
  p <- ggplot(data_tech,aes(text=tooltip_text))+
    # Segments pour High-Low
    geom_segment(aes(x=as.factor(Period),xend = as.factor(Period), y = Low, yend = High), color = "black",linewidth = 0.4) +
    
    # Segments Open / close
   
    geom_segment(aes(x = x_open, xend = x_open + 0.3, y = Open, yend = Open), color = "black", linewidth = 0.4) +
    geom_segment(aes(x = x_close-0.3, xend = x_close, y = Close, yend = Close), color = "black", linewidth = 0.4) +
    
    
    # indicateurs
    geom_segment(aes(y = lag(M7), yend=M7,x=x_pos-1,xend=x_pos,color=color_M7),linewidth = 0.6) +

    # # SAR avec couleurs dynamiques
    geom_point(aes(x=as.factor(Period),y = SAR,color=color_SAR),shape = 18, size = 1) +
    
   
    #oggy et jack
    geom_vline(xintercept = 23, color = "black", linetype = "solid", linewidth = 0.5,alpha=0.2) +
    geom_vline(xintercept = 10, color = "black", linetype = "solid", linewidth = 0.5,alpha=0.2) +

    labs(
      title=paste(periode),
      x=NULL,
      y=NULL
    ) +
    
    scale_x_discrete(breaks = levels(as.factor(data_tech$Period))[seq(1, length(levels(as.factor(data_tech$Period))), by = 4L)])+
    theme(axis.text.x = element_text(angle = 90, hjust = 1,size=8))+
    theme(legend.position = "none")
  if(nb_ok==T){
    p<-p+
      geom_segment(aes(y = lag(M20), yend=M20,x=x_pos-1,xend=x_pos,color=color_M20),linewidth = 0.6)+
      geom_segment(aes(y = lag(BB_up), yend=BB_up,x=x_pos-1,xend=x_pos, color = color_BB_up),linewidth = 0.6)+
   
      geom_segment(aes(y = lag(BB_dn), yend=BB_dn,x=x_pos-1,xend=x_pos,color=color_BB_dn),linewidth = 0.6)
  }
    
  
 
#  Conversion en graphique interactif avec Plotly
   ggplotly(p,tooltip =c("tooltip_text"))

}
# toCache=T
 actif="ALTHX.PA"
# # periode="semiannual"
# # # Exemple d'utilisation pour différentes périodes
generer_graphique(actif, "daily")
#generer_graphique("blabla","daily",toCache = F)
 