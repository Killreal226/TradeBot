library(httr)
library(rsconnect)
library(digest)

Couples <- function(couple1, couple2, Symbol_arr){
  Symbol_arr
  a = paste0(couple1, couple2)
  b = paste0(couple2, couple1)
  for (i in 1:length(Symbol_arr)){
    if (a == Symbol_arr[[i]]){
      a <- list(Symbol_arr[[i]], FALSE, i)
      return(a)
      break
    }
    else if (b == Symbol_arr[[i]]){
      a <- list(Symbol_arr[[i]], TRUE, i)
      return(a)
      break
    }
  }
}

profit <- function(list_ask_bid){
  fee_taker = 0.001
  if (list_ask_bid[[2]][1] == "ask"){
    profit = (as.numeric(list_ask_bid[[3]][2]) * (1-fee_taker)^3)/(as.numeric(list_ask_bid[[1]][2])*as.numeric(list_ask_bid[[2]][2]))
    coef_profit = profit - 1
    return(coef_profit)
  }else{
    profit = (as.numeric(list_ask_bid[[2]][2])*as.numeric(list_ask_bid[[3]][2])*(1-fee_taker)^3)/(as.numeric(list_ask_bid[[1]][2]))
    coef_profit = profit - 1
    return(coef_profit)
  }
}

#-----------------------------сортируем по запросу и вытаскиваем id

# all_pairs <- local(get(load("all_pairs_307.RData")))
# all_pairs[[1]][[1]]
# test <<- content(GET(
#   url=sprintf('https://api.binance.com/api/v3/ticker/bookTicker'),
#   add_headers("X-MBX-APIKEY" = "")
# ),
# "parsed"
# )
# 
# 
# sorted_pairs <- list()
# list_id <- list()
# for (i in 1:2094){
#   for (j in 1:307){
#     if (all_pairs[[1]][[j]] == test[[i]]$symbol){
#       sorted_pairs <- append(sorted_pairs, all_pairs[[1]][[j]])
#       list_id <- append(list_id, i)
#       break
#     }
#   }
# 
# }
#-----------------------------------------------
#save(all_pairs, file="all_pairs.RData")  вроде нахуй не надо

#save(sorted_pairs, file="sorted_pairs.RData") вроде универсально
#save(list_id, file="list_id.RData") вроде тоже универсально




#------сортируем связки по индексу
# all_pairs <- list()
# for (i in 1:307){
#   all_pairs <- append(all_pairs, test[[i]]$symbol)
# }
# 
# save(all_pairs, file="all_pairs.RData")
#------------------------------


list_chains <- local(get(load("list_chains.RData")))
all_pairs <- local(get(load("sorted_pairs.RData")))
list_id <- local(get(load("list_id.RData")))


result_list <- list()
repeat{
  result_list1 <- list()
  timestamp <- round(as.numeric(Sys.time())*1000)
  key <- ""
  
  test <<- content(GET(
    url=sprintf('https://api.binance.com/api/v3/ticker/bookTicker'),
    add_headers("X-MBX-APIKEY" = "")
  ),
  "parsed"
  )
  
  list_profits <- list()
  for (i in 1:length(list_chains)){
    bundle = strsplit(list_chains[[i]], "->")
    bundle
    list_ask_bid <- list()
    for (j in  1:3){
      Symbol <- Couples (bundle[[1]][j], bundle[[1]][j+1], all_pairs)
      if (Symbol [[2]] == FALSE){
        #cat("bid  id=", Symbol [[3]], '\n'
        k = Symbol [[3]]
        id = list_id[[k]]
        bid_price = test[[id]]$bidPrice
        list_bid <- list(c("bid", bid_price))
        list_ask_bid <- append(list_ask_bid, list_bid)
        #price = askprice - передается в buy
      } 
      else if (Symbol[[2]] == TRUE){
        #cat("ask  id=", Symbol [[3]], '\n')
        k = Symbol [[3]]
        id = list_id[[k]]
        ask_price = test[[id]]$askPrice
        list_ask <- list(c("ask",  ask_price))
        list_ask_bid <- append(list_ask_bid, list_ask)
        #price = bidprice - передается в sell
      }
    }
    
    x = profit(list_ask_bid)
    a <- list(c(x, list_chains[[i]]))
    list_profits = append(list_profits, a)
  }
  for (i in 1:length(list_chains)){             #!!!!!!!!!!!!!!!!!!!!!!!! i � i
    if (as.numeric(list_profits[[i]][1]) > 0){
      print(list_profits[[i]])
      result_list <- append(result_list, list(list_profits[[i]]))
      result_list1 <- append(result_list1, list(list_profits[[i]]))
    }
    #class(list_profits[[1]][1])
  }
  if (length(result_list1) == 0){
    print("нет профитных связок")
  }
}





