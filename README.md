# DataCollection
send data to server using wifi

- 将iphone中的 加速度传感器、陀螺仪、磁力计收集到的 9d 数据通过wifi传送到Server端
- 局域网（校园网）中实现，在空白栏中填写Server端的ip，按发送即可。

## Server端代码如下：
``` python
#!/usr/bin/env python
# coding=utf-8

import random,sys,struct
import SocketServer
import json
import base64 as b64
import os
import hmac
from hashlib import sha512,sha1
from time import time

def writeToHbase(dataReceived):
    print dataReceived
    # data = json.loads(dataReceived.decode('utf-8'))
    # print data

class Checkin(SocketServer.BaseRequestHandler):
    def handle(self):
        while 1:
            dataReceived = self.request.recv(1024)
            if not dataReceived: break
            writeToHbase(dataReceived)
        print 'break'

class ThreadedServer(SocketServer.ThreadingMixIn, SocketServer.TCPServer):
    pass

if __name__ == "__main__":
    HOST, PORT = '0.0.0.0', 23333
    print HOST
    print PORT 
    server = ThreadedServer((HOST, PORT), Checkin)
    server.allow_reuse_address = True
    server.serve_forever()


