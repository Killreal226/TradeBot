library(httr)
library(rsconnect)
library(digest)

key <- ""
timestamp <- round(as.numeric(Sys.time())*1000)

data_SYMBOLS_filters <<- content(GET(
  url=sprintf("https://api.binance.com/api/v3/exchangeInfo"),
  add_headers("X-MBX-APIKEY" = "")
), 
"parsed"
)


list_id <- local(get(load("list_id.RData")))
SYMBOLS_list <- local(get(load("sorted_pairs.RData")))
SYMBOLS_list_filters <- list()
abc<-list()
for (i in 1:1265){
  id = list_id[[i]]
  abc[[1]] <-list(data_SYMBOLS_filters$symbols[[id]]$symbol, data_SYMBOLS_filters$symbols[[id]]$filters[[3]]$stepSize)
  SYMBOLS_list_filters <- append(SYMBOLS_list_filters, abc)
   
}
#SYMBOLS_list_filters

save(SYMBOLS_list_filters, file="SYMBOLS_list_filters.RData")

