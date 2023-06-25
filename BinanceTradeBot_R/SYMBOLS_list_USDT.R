library(httr)
library(rsconnect)
library(digest)
library(stringr)

key <- ""

timestamp <- round(as.numeric(Sys.time())*1000)

data_SYMBOLS <<- content(GET(
  url=sprintf('https://api.binance.com/api/v3/exchangeInfo'),
  add_headers("X-MBX-APIKEY" = "")
),
"parsed"
)


Symbols_list <- list()



for(i in 1:2094){
  if (data_SYMBOLS$symbols[[i]]$status == "TRADING"){
    Symbols_list<-append(Symbols_list, list(data_SYMBOLS$symbols[[i]]$symbol))
  }
}

#save(Symbols_list, file="Symbols_Trading_list.RData")

USDT = "USDT"
list_USDT <- list ()

for (i in 1:1470){
  a = str_length(Symbols_list[[i]]) - 3 # если USDT то исправить на - 3(если ETH, то -2)
  b = str_length(Symbols_list[[i]])
  if ((grepl(USDT, Symbols_list[[i]]) == TRUE)&(first_Symb = substring (Symbols_list[[i]],1,3) != "USDT")&(last_Symb = substring (Symbols_list[[i]],a,b) == "USDT")){
    list_USDT <- append(list_USDT, Symbols_list[[i]])
  }
}


list_USDT_75 <- list()
for (i in 1:345){
  list_USDT_75 <- append(list_USDT_75, list_USDT[[i]])
}

length(list_USDT)
#save(list_USDT_75, file="list_USDT_75.RData")

#list_USDT <- local(get(load("list_USDT.RData")))

ALT_list <- list()

for (i in 1:length(list_USDT)){
  result = substring(list_USDT[[i]], 1, nchar(list_USDT[[i]])-4)# изменить -4
  ALT_list <- append(ALT_list, result)
}

#save(ALT_list, file="ALT_list.RData")

#Symbols_Pairs_Clean_232 <- local(get(load("Symbols_Pairs_clean_232.RData")))

Symbol_us <- ALT_list
Symbol_all <- Symbols_list
Symbol_end <-list()
for (i in 1:344){
  for (j in (i+1):345){
    a = paste0(Symbol_us[[i]], Symbol_us [[j]])
    b = paste0(Symbol_us[[j]],Symbol_us[[i]])
    for (k in 1:1470){
      if (a == Symbol_all[[k]]){
        Symbol_end <- append(Symbol_end, a)
      }
      else if (b == Symbol_all[[k]]){
        Symbol_end <- append(Symbol_end, b)
      }
      
      
    }
  }
}


Symbols_Pairs_clean = Symbol_end


list_chains <- list ()
for (i in 1:344){
  for (j in (i+1):345){
    symbol_1 = paste0(ALT_list[[i]],ALT_list[[j]])
    symbol_2 = paste0(ALT_list[[j]],ALT_list[[i]])
    for (k in 1:length(Symbols_Pairs_clean)){
      if (symbol_1 == Symbols_Pairs_clean[[k]]){
        a = sprintf("%s->%s->%s->%s", USDT, ALT_list[[i]], ALT_list[[j]], USDT)
        b = sprintf("%s->%s->%s->%s",USDT, ALT_list[[j]], ALT_list[[i]], USDT)
        list_chains = append(list_chains, a)
        list_chains = append(list_chains, b)
      }
      else if (symbol_2 == Symbols_Pairs_clean[[k]]){
        a = sprintf("%s->%s->%s->%s",USDT, ALT_list[[i]], ALT_list[[j]], USDT)
        b = sprintf("%s->%s->%s->%s",USDT,  ALT_list[[j]], ALT_list[[i]], USDT)
        list_chains = append(list_chains, a)
        list_chains = append(list_chains, b)
      }
    }
  }
}


all_pairs <- list(c(list_USDT_75, Symbols_Pairs_clean))

#all_pairs <- local(get(load("all_pairs_307.RData")))
all_pairs[[1]][[1]]
test <<- content(GET(
  url=sprintf('https://api.binance.com/api/v3/ticker/bookTicker'),
  add_headers("X-MBX-APIKEY" = "")
),
"parsed"
)


sorted_pairs <- list()
list_id <- list()
for (i in 1:2094){
  for (j in 1:length(all_pairs[[1]])){
    if (all_pairs[[1]][[j]] == test[[i]]$symbol){
      sorted_pairs <- append(sorted_pairs, all_pairs[[1]][[j]])
      list_id <- append(list_id, i)
      break
    }
  }

}


# list_chainss = list_chains
# list_chains <- list()
# list_chainss[[1111]] = 0
# list_chainss[[1112]] = 0
# for (i in 1:1842){
#   if (list_chainss[[i]] != 0){
#     list_chains <- append(list_chains, list_chainss[[i]])
#   }
# }


save(sorted_pairs, file="sorted_pairs.RData")
save(list_chains, file="list_chains.RData")
save(list_id, file="list_id.RData")



