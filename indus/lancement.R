library(quarto)
library(tidyverse)
library(glue)
library(purrr)
library(stringr)
# Liste des actifs
symbols <- c("^FCHI", "^IXIC","^GDAXI",  "GC=F","SI=F","CL=F","EURUSD=X","USDJPY=X","GBPUSD=X","AUDUSD=X","USDCAD=X","USDCNY=X","USDCHF=X")


symbols="GC=F"
for (actif in symbols) {
  quarto_render(
    input = "indus/quarto_ind.qmd",
    output_file = "temp.html",
    execute_params = list(actif = actif)
  )
  
  dest<- paste0(str_replace(actif,"[^A-Za-z0-9]",""),".html")
  file.rename(from="~/ATS/temp.html",to=file.path("~/ATS/indus",dest))
}


              