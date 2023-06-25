import json
from re import X
import time
#from turtle import st
import numpy as np
#import BUY_SELL


with open ('list_chains.txt', 'r') as list_ch:
        list_chains = json.load (list_ch)

# with open ('dict_new.txt', 'r') as dict_:
#         _dict = json.load (dict_)

_list = np.array (list_chains)

def profit (_dict):
    fee_taker = 0.002
    amount = 12
    for i in range (len(_list)):
        if  _dict[_list[i,0,0]] != [-1,-1] and  _dict[_list[i,1,0]] != [-1,-1] and _dict[_list[i,2,0]] != [-1,-1]:   
            if _list [i,1,1] == "ask":                       
                profit = (float(_dict[_list[i,2,0]][1]) * (1-fee_taker)**3)/(float(_dict[_list[i,0,0]][0])*float(_dict[_list[i,1,0]][0]))
                coef_profit = profit - 1
                if coef_profit > 0:
                    # amount = BUY_SELL.buy(_list[i,0,0], amount)
                    # amount = BUY_SELL.buy(_list[i,1,0], amount)
                    # amount = BUY_SELL.sell(_list[i,2,0], amount)
                    print (coef_profit, '',
                     _list[i,0,0], float(_dict[_list[i,0,0]][2]) * float(_dict[_list[i,0,0]][0]), 
                     _list[i,1,0], float(_dict[_list[i,1,0]][2]) * float(_dict[_list[i,1,0]][0]) * float(_dict[_list[i,0,0]][0]),
                     _list[i,2,0], float(_dict[_list[i,2,0]][3]) * float(_dict[_list[i,2,0]][1])
                    )
                    # break
                #return (coef_profit)
            else:
                profit = (float(_dict[_list[i,1,0]][1])*float(_dict[_list[i,2,0]][1])*(1-fee_taker)**3)/(float(_dict[_list[i,0,0]][0]))
                coef_profit = profit - 1
                if coef_profit > 0:
                    # amount = BUY_SELL.buy(_list[i,0,0], amount)
                    # amount = BUY_SELL.sell(_list[i,1,0], amount)
                    # amount = BUY_SELL.sell(_list[i,2,0], amount)
                    print (coef_profit, '',
                     _list[i,0,0], float(_dict[_list[i,0,0]][2]) * float(_dict[_list[i,0,0]][0]), 
                     _list[i,1,0], float(_dict[_list[i,1,0]][3]) * float(_dict[_list[i,0,0]][1]),
                     _list[i,2,0], float(_dict[_list[i,2,0]][3]) * float(_dict[_list[i,2,0]][1])
                    )
                    # break
                #return (coef_profit)
    # if x != 0:
    #     print(x)



def run (queue_flag, queue_dict):
    #time.sleep(10)
    queue_flag.put(True)
    while True:
        _dict = queue_dict.get()
        profit(_dict)
        queue_flag.put (True)
