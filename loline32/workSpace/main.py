import os
import ujson
import machine
import esp32
from machine import Pin
from time import sleep_ms
import urequest as urequests
from credentials import *
#  import upip
#  upip.help()
#  upip.install(pckgs)  

SSID = WIFI
WIFIPW = WPAKEY
ifconfig = ('192.168.0.101', '255.255.255.0', '192.168.0.1', '192.168.0.1')
PLUGSTATES = ["OFF", "ON"]
 
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
     
def do_connect():
  import network
  wlan = network.WLAN(network.STA_IF)
  wlan.active(True)
    
  if not wlan.isconnected():
      print('connecting to network...')
      wlan.connect(SSID, WIFIPW)
      while not wlan.isconnected():
          pass
  print('network config:', wlan.ifconfig())

def test_dns(host="google.de"):
  import usocket as socket
  addr = socket.getaddrinfo(host, 80)[0][-1]
  print('DNS test:', addr)


################################################################
# MAIN
################################################################

wakeup_reason_candidates = ['PIN', 'PWRON', 'RTC', 'ULP', 'WLAN' ]
reset_cause_candidates = ['PWRON', 'HARD', 'SOFT', 'WDT', 'DEEPSLEEP', 'BROWN_OUT']
wake = wakeup_reason_candidates[machine.wake_reason()]
reset = reset_cause_candidates[machine.reset_cause()]
print(wake, reset)

if reset == "DEEPSLEEP":
  do_connect()
  # test_dns()
  # http_get()
  kasa = Kasa()
  kasa.switch()
  
wake1 = Pin(12  , Pin.IN, Pin.PULL_DOWN)
esp32.wake_on_ext0(pin = wake1, level = esp32.WAKEUP_ANY_HIGH) #level parameter can be: esp32.WAKEUP_ANY_HIGH or esp32.WAKEUP_ALL_LOW
print('Im awake. Going to sleep in 2 seconds')
sleep_ms(2000)
print('Going to sleep now')
machine.deepsleep()