analyse_opportunite<-function(periode,type){
data_tech<-readRDS("temp/data_tech.RDS") |> tail(1)
  txt=""
  px<-data_tech$Close
  ecart_m20<-px-data_tech$M20
  ecart_sar<-px-data_tech$SAR
  ecart_BB_up<-px-data_tech$BB_up
  ecart_BB_dn<-px-data_tech$BB_dn
  
  
  switch(type,
         "F"=seuil<-0.0020,
         "JPY"=seuil<-0.2,
         "A"=seuil<-0.05*(data_tech |> tail(1) |> select(Close)|> pull()),
          "I"=seuil<-50)

  for(indic in c("M7","M20","SAR","BB_up","BB_dn")){
    if(!is.na(data_tech |> select(all_of(indic)) |> pull())) {
    ecart<-px-data_tech |> select(all_of(indic)) |> pull()
    if (data_tech |> select(all_of(paste0("color_",indic))) |> pull()==F & ecart<0 & ecart>-seuil){
      txt<-paste0(txt,actif,"--",periode,"--","short possible ",indic,"<br>")
    }
    if (data_tech |> select(all_of(paste0("color_",indic))) |> pull()==T & ecart>0 & ecart<seuil){
      txt<-paste0(txt,actif,"--",periode,"--","buy possible ",indic,"<br>")
    }
      
      
  }
  }

    output<<-paste0(output,txt,"<br>")
   
    }



