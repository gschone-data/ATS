analyse_opportunite<-function(data_tech_tail,periode,symbole_bis){
  px<-data_tech_tail$Close
  ecart_m20<-px-data_tech_tail$M20
  ecart_sar<-px-data_tech_tail$SAR
  ecart_BB_up<-px-data_tech_tail$BB_up
  ecart_BB_dn<-px-data_tech_tail$BB_dn
  
  
  rouge="#FF0000"  
  bleu="#0000FF"
  
  seuil=0.05
  
  for(type in c("M7","M20","SAR","BB_up","BB_dn")){
    ecart<-px-data_tech_tail |> select(all_of(type)) |> pull()
    if (data_tech_tail |> select(all_of(paste0("color_",type))) |> pull()==rouge & ecart<0 & ecart>-seuil){
      txt<-paste0(symbole_bis,"--",periode,"--","short possible ",type)
    }
    if (data_tech_tail |> select(all_of(paste0("color_",type))) |> pull()==bleu & ecart>0 & ecart<-seuil){
      txt<-paste0(symbole_bis,"--",periode,"--","short possible ",type)
    }
      
      
    }
  
  if (nb_round==4){
  

  output<<-paste0(output,"","\\n")
  }
}
data_tech_tail<-data_tech |> tail(1)
output<-""
