library(httr)
library(rsconnect)
library(digest)

SYMBOLS_list_filters <- local(get(load("SYMBOLS_list_filters.RData")))

buy <- function(Symbol, amount){
  # for (i in 1:153){
  #   if (is.null(SYMBOLS_list_filters[[i]][[1]]) == FALSE){
  #     if (Symbol == SYMBOLS_list_filters[[i]][[1]]){
  #       a = as.numeric(SYMBOLS_list_filters[[140]][[2]])
  #       k = 0
  #       while(a != 1){
  #         a = a * 10
  #         k = k+1
  #       }
  #       x = as.numeric(0.00760000)
  #       x = floor(x*(10**k))/(10**k)
  #       amount = x  
  #       amount
  #     }
  #   }
  # }
  timestamp <- round(as.numeric(Sys.time())*1000)
  
  key <- ""
  object <<- sprintf("symbol=%s&side=BUY&type=MARKET&quoteOrderQty=%s&timestamp=%s", Symbol, amount, timestamp)
  
  
  secret_key_hmac <<- hmac(key, object, "sha256")
  secret_key_hmac
  
  
  data_XXX <<- content(POST(
    url=sprintf("https://api.binance.com/api/v3/order?symbol=%s&side=BUY&type=MARKET&quoteOrderQty=%s&timestamp=%s&signature=%s", Symbol, amount, timestamp, secret_key_hmac),
    add_headers("X-MBX-APIKEY" = "")
  ),
  "parsed"
  )
  data_XXX
  return(data_XXX$executedQty) # возвращает кол-во купленного актива
}


# response <- buy("BTCUSDT")
# response



sell <- function(Symbol, amount){
  for (i in 1:1265){
    if (is.null(SYMBOLS_list_filters[[i]][[1]]) == FALSE){
      if (Symbol == SYMBOLS_list_filters[[i]][[1]]){
        a = as.numeric(SYMBOLS_list_filters[[i]][[2]])
        k = 0
        while(a != 1){
          a = a * 10
          k = k+1
        }
        x = as.numeric(amount)
        x = floor(x*(10**k))/(10**k)
        amount = x
        break
      }
    }
  }
  timestamp <- round(as.numeric(Sys.time())*1000)
  
  key <- ""
  object1 <<- sprintf("symbol=%s&side=SELL&type=MARKET&quantity=%s&timestamp=%s", Symbol, amount, timestamp)
  
  secret_key_hmac <<- hmac(key, object1, "sha256")
  secret_key_hmac
  
  data_XXX <<- content(POST(
    url=sprintf("https://api.binance.com/api/v3/order?symbol=%s&side=SELL&type=MARKET&quantity=%s&timestamp=%s&signature=%s", Symbol, amount, timestamp, secret_key_hmac),
    add_headers("X-MBX-APIKEY" = "")
  ),
  "parsed"
  )
  data_XXX
  return(data_XXX$cummulativeQuoteQty) #возвращает кол-во полученного после продажи актива
}


# response_sell <- sell("BTCUSDT")
# response_sell
