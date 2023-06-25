import multiprocessing
import json
import websocket
import profit
import gzip

with open ('list_chains.txt', 'r') as list_ch:
    _list = json.load (list_ch)

with open ('dict.txt', 'r') as a:
    _dict = json.load (a)

def transfer (_dict):
    global queue_flag, queue_dict
    queue_flag.get ()
    queue_dict.put (_dict)


def on_data(wsapp, message, data_type, flag):
    message = json.loads(gzip.decompress(message))
    if "ping" in message:
        wsapp.send(json.dumps({
            "pong": message['ping'],
        })
        )
        print("pong sent")
    elif 'ch' in message:
        symb = message['ch'].replace("market.", "").replace(".ticker", "")
        _dict[symb] = [message['tick']["ask"], message['tick']["bid"], message['tick']["askSize"], message['tick']["bidSize"]] 
    elif "subbed" in message:
        print(f"подписался на {message['subbed']}")
    if queue_flag.qsize () != 0:
        transfer (_dict)

def on_ping(wsapp, message):
        print("Got a ping! A pong reply has already been automatically sent.")

def on_pong(wsapp, message):
        print("Got a pong! No need to respond")

def on_error(wsapp, error):
        print(error)

def on_close(wsapp, close_status_code, close_msg):
        print("### closed ###", close_status_code, ' ', close_msg)

def on_open(wsapp):
    for symbol in _dict:
        wsapp.send(json.dumps({
        "sub": f"market.{symbol}.ticker",
        })
        )
    print("connection opened")

def run():     
    #try:
    wsapp = websocket.WebSocketApp("wss://api.huobi.pro/ws",
                                    on_open=on_open,
                                    on_ping=on_ping,
                                    on_data=on_data,
                                    on_error=on_error,
                                    on_close=on_close)

    # while True:
    wsapp.run_forever()

    # finally:
    #     wsapp.close()
    #     #print(len(dict))
    #     with open ('dict_new.txt', 'w') as updated:
    #         json.dump(_dict , updated)






if __name__ == "__main__":
    queue_flag = multiprocessing.Queue(1)
    queue_dict = multiprocessing.Queue (1)
    web_process = multiprocessing.Process(target=profit.run, args=(queue_flag, queue_dict,))
    web_process.start()
    run()



    # while queue.qsize() > 0:
    # a = [-1, -1]
    # while queue.qsize() >= 0:
    #     b = queue.get()["APEAUD"]
    #     if b != a:
    #         print(b)
    #         a = b


    # time.sleep (30)
    # profit_process = multiprocessing.Process(target=profit.profit, args=(_list, queue))
    # profit_process.start ()