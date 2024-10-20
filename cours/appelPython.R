python_path <- "C:/Users/Gilles/AppData/Local/Programs/Python/Python311/python"
python_script <- "C:/Users/Gilles/Documents/BOURSE/PyATS/pyats.py"
setwd(dir= "C:/Users/Gilles/Documents/BOURSE/PyATS/")


listticker1<-c("eurusd=X",
              'gpbusd=X',
              'usdchf=X',
              'usdjpy=X',
              'usdcad=X',
              'audusd=X',
              'eurgbp=X',
              'euraud=X',
              'eurchf=X',
              'eurjpy=X',
              'gbpchf=X',
              'cadjpy=X',
              'gbpjpy=X',
              'audnzd=X',
              'audcad=X',
              'audchf=X',
              'audjpy=X',
              'chfjpy=X',
              'eurnzd=X',
              'eurcad=X',
              'cadchf=X',
              'nzdjpy=X',
              'nzdusd=X',
              'GBPAUD=X',
              'EURCNY=X',
              'CNY=X',
              'GC=F',
              'SI=F',
              '^FCHI',
              '^SPX',
              '^NDX',
              'CL=F')
  
command <- paste(python_path, python_script,"-t ","CNY=X", sep=" ")  
system(command)


            
 for (k in listticker1){
  command <- paste(python_path, python_script,"-t ",k, sep=" ")  
  system(command)
  
}
  



