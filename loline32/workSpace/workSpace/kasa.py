import urequest as urequests
from credentials import *

class Kasa():
  
  def __init__(self, UUID=UUID, USER=USER, PW=PW):
    print("Hello Kasa!")
    self.UUID = UUID
    self.USER = USER
    self.PW   = PW
    
    self.token = self._token()
    print(self.token)
    self.device = self._device()
    print(self.device)
    
  def _token(self):
    params = {}
    params["appType"] = "Kasa_Android"
    params["cloudUserName"] = self.USER
    params["cloudPassword"] = self.PW
    params["terminalUUID"] = self.UUID
    body = {}
    body["method"] = "login"
    body["params"] = params
    response = urequests.post("https://wap.tplinkcloud.com", data = ujson.dumps(body))
    #print(response.json())
    token = response.json()["result"]["token"]
    response.close()
    return token
  
  def _device(self, id=0):
    token = self.token
    body = {}
    body["method"] = "getDeviceList"
    response = urequests.post("https://wap.tplinkcloud.com/?token=" + token, data = ujson.dumps(body))
    #print(response.json())
    device = response.json()["result"]["deviceList"][id]["deviceId"]
    response.close()
    return device
    
  def set(self, the_state=1):
    print("Switching", PLUGSTATES[the_state])
    token, device  = self.token, self.device
    params = {}
    params["deviceId"] = device
    params["requestData"] = "{\"system\":{\"set_relay_state\":{\"state\":%state} } }".replace("%state", str(the_state))
    body = {}
    body["method"] = "passthrough"
    body["params"] = params
    response = urequests.post("https://eu-wap.tplinkcloud.com/?token=" + token, data = ujson.dumps(body))
    res = response.json()
    response.close()
    return res
    
  def get(self):
    token, device  = self.token, self.device
    params = {}
    params["deviceId"] = device
    params["requestData"] = "{\"system\":{\"get_sysinfo\":null},\"emeter\":{\"get_realtime\":null}}"
    body = {}
    body["method"] = "passthrough"
    body["params"] = params
    response = urequests.post("https://eu-wap.tplinkcloud.com/?token=" + token, data = ujson.dumps(body))
    res = response.json()
    relay_state = int(res["result"]["responseData"].split("relay_state\":")[1][0]) 
    response.close()
    return relay_state
    
  def on(self):
    self.set(1)
    
  def off(self):
    self.set(0)
  
  def switch(self):
    new_state = self.get() + 1
    self.set(new_state  % 2)
