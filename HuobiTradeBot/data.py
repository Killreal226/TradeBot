import requests
import json
import numpy as np

class request:
    def __init__(self):
        pass

    def get_exchangeInfo(self, url):
        data_SYMBOLS = requests.get(url)
        data_SYMBOLS = data_SYMBOLS.json()
        return(data_SYMBOLS)


class all_pairs():
    def __init__(self):
        self.data_SYMBOLS = request()
        self.Symbols_list = []
        self.list_USDT = []
        self.alt_list = []
        self.Symbol_end = []
        self.list = []
        self.dict = {}
        self.all_pairs = []
        self.SYMBOLS_filters = {}

    def exchangeInfo(self):
        url = 'https://api.huobi.pro/v2/settings/common/symbols'
        self.data_SYMBOLS = self.data_SYMBOLS.get_exchangeInfo(url)
        return self.data_SYMBOLS
        

    def get_trading_symbols(self):
        data_SYMBOLS = self.exchangeInfo ()
        for i in range(len(data_SYMBOLS['data'])):
            if data_SYMBOLS['data'][i]['state'] == "online":
                self.Symbols_list.append(data_SYMBOLS['data'][i]['sc'])
        return self.Symbols_list
        

    def get_list_USDT(self):
        USDT = "usdt"
        Symbols_list = self.get_trading_symbols ()
        for i in range(len(Symbols_list)):
            if Symbols_list[i][-4:] == "usdt":
                self.list_USDT.append(Symbols_list[i])
        return self.list_USDT
            
    def get_list_alt(self):
        list_USDT = self.get_list_USDT ()
        for i in range(len(list_USDT)):
            result = list_USDT[i][:-4]  # изменить -4
            self.alt_list.append(result)
        return self.alt_list
    
    def get_alt_alt_list (self):
        alt_list = self.get_list_alt ()
        for i in range(len (alt_list) - 1):
            for j in range(i+1, len(alt_list)):  # 150 - сколько берем пар к usdt
                for k in range(len(self.Symbols_list)):
                    if alt_list[i] + alt_list[j] == self.Symbols_list[k] and self.Symbols_list[k] !="tusdt":
                        self.Symbol_end.append(alt_list[i] + alt_list[j])
                    elif alt_list[j] + alt_list[i] == self.Symbols_list[k] and self.Symbols_list[k] !="tusdt":
                        self.Symbol_end.append(alt_list[j] + alt_list[i])
        return self.Symbol_end  #Получилось 918

    def get_list_chains(self):
        self.Symbol_end #= self.get_alt_alt_list()
        for i in range (len(self.alt_list)-1):
            for j in range (i+1, len(self.alt_list)):
                for k in range (len(self.Symbol_end)):
                    if self.alt_list[i] + self.alt_list[j] == self.Symbol_end[k]:
                        # self.list.append ([[f'{self.alt_list[i]}USDT', 'ask'],[self.alt_list[i] + self.alt_list[j], 'ask'],[f'{self.alt_list[j]}USDT', 'bid']])
                        # self.list.append ([[f'{self.alt_list[j]}USDT', 'ask'],[self.alt_list[i] + self.alt_list[j], 'bid'],[f'{self.alt_list[i]}USDT', 'bid']])
                        self.list.append ([[f'{self.alt_list[i]}usdt', 'ask'],[self.Symbol_end[k], 'bid'],[f'{self.alt_list[j]}usdt', 'bid']])
                        self.list.append ([[f'{self.alt_list[j]}usdt', 'ask'],[self.Symbol_end[k], 'ask'],[f'{self.alt_list[i]}usdt', 'bid']])
                        
                        break
                    elif self.alt_list[j] + self.alt_list[i] == self.Symbol_end[k]:
                        # self.list.append ([[f'{self.alt_list[j]}USDT', 'ask'],[self.alt_list[j] + self.alt_list[i], 'ask'],[f'{self.alt_list[i]}USDT', 'bid']])
                        # self.list.append ([[f'{self.alt_list[i]}USDT', 'ask'],[self.alt_list[j] + self.alt_list[i], 'bid'],[f'{self.alt_list[j]}USDT', 'bid']])
                        self.list.append ([[f'{self.alt_list[j]}usdt', 'ask'],[self.Symbol_end[k], 'bid'],[f'{self.alt_list[i]}usdt', 'bid']])
                        self.list.append ([[f'{self.alt_list[i]}usdt', 'ask'],[self.Symbol_end[k], 'ask'],[f'{self.alt_list[j]}usdt', 'bid']])
                        break 
        return self.list #1834

    def get_all_pairs (self):
        Symbol_end = self.get_alt_alt_list ()
        self.all_pairs = self.list_USDT + Symbol_end
        return self.all_pairs #1263
    
    def get_dict (self):
        all_pairs = self.get_all_pairs ()
        for i in all_pairs:
            self.dict [i] = [-1,-1] 
        return self.dict #1263 (Правильно)

    def get_filters(self):
        #self.exchangeInfo()
        #self.get_all_pairs()
        for i in range(len(self.data_SYMBOLS['symbols'])):
            for j in self.all_pairs:
                if j == self.data_SYMBOLS['symbols'][i]['symbol']:
                    self.SYMBOLS_filters[j] = self.data_SYMBOLS['symbols'][i]['filters'][2]['stepSize']

data = all_pairs()
data.get_dict()
data.get_list_chains()
print(len(data.list),len(data.dict),len(data.all_pairs), len(data.Symbol_end))
# data.get_filters()
# print(len(data.dict), '---', len(data.list), '---', len(data.SYMBOLS_filters))



with open('list_chains.txt', 'w') as f:
        json.dump(data.list, f)

with open('dict.txt', 'w') as f1:
        json.dump(data.dict, f1)

# with open('SYMBOLS_list_filters.txt', 'w') as f2:
#         json.dump(data.SYMBOLS_filters, f2)
