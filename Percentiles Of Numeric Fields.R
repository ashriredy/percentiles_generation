library("data.table")
library("dplyr")
rm(list=ls()); cat("\014");
dataset = fread("C:/Users/Ashrith Reddy/Documents/GitHub/dressbarn_price_elasticity/code/Adhoc/08_returns_data/returns_data_stage1.csv",nrows = -1) %>% 
  select_if(is.numeric)
gc()

for(column_name in names(dataset)){
  data_vector = dataset[[column_name]]
  cat(column_name)
  percentiles = c(0,seq(0.000,0.010,by=0.001),seq(0,1,0.01),25,50,75,90:99,seq(99,100,0.01),seq(99.99,100,by=0.001),100) %>% unique %>% sort
  a = sapply(percentiles ,FUN = function(x){print(x);quantile(data_vector,x/100,na.rm = TRUE) %>% unname}) %>% 
    as.data.frame() %>% setnames("value")  %>% cbind(percentiles) %>% select(2,1) 
  a %>% xlsx::write.xlsx("Percentiles Of Numeric Fields.xlsx",sheetName = column_name,append = TRUE)
  gc()
}

