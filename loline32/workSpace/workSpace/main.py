import os
import ujson
import machine
import esp32
from machine import Pin
from time import sleep_ms
import urequest as urequests
from credentials import *
from sound import *
from kasa import *
import gc
#  import upip
#  upip.help()
#  upip.install(pckgs)  
gc.collect()
print("Free mem:", gc.mem_free())

# IO
SLEEP_PIN = 12
SSID = WIFI
WIFIPW = WPAKEY
ifconfig = ('192.168.0.101', '255.255.255.0', '192.168.0.1', '192.168.0.1')
PLUGSTATES = ["OFF", "ON"]

def go_to_sleep():
  wake1 = Pin(SLEEP_PIN  , Pin.IN, Pin.PULL_DOWN)
  esp32.wake_on_ext0(pin = wake1, level = esp32.WAKEUP_ANY_HIGH) #level parameter can be: esp32.WAKEUP_ANY_HIGH or esp32.WAKEUP_ALL_LOW
  print('Im awake. Going to sleep in 1 seconds')
  sleep_ms(1000)
  print('Going to sleep now')
  machine.deepsleep()
  
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

def kasa_listener(status):
  if status:
    do_connect()
    test_dns()
    # http_get()
    #kasa = Kasa()
    #kasa.on()

################################################################
# MAIN
################################################################

wakeup_reason_candidates = ['PIN', 'PWRON', 'RTC', 'ULP', 'WLAN' ]
reset_cause_candidates = ['PWRON', 'HARD', 'SOFT', 'WDT', 'DEEPSLEEP', 'BROWN_OUT']
wake = wakeup_reason_candidates[machine.wake_reason()]
reset = reset_cause_candidates[machine.reset_cause()]
print(wake, reset)

if reset == "DEEPSLEEP":
  try:
    machine.freq(240000000)
    sd = SoundDetector(HZ = 7500, min_freq=3000, max_freq=3200, min_amp = 150)
    sd.listen(60 * 1000, [led_listener, kasa_listener], early_stop=True)
    del sd
  except Exception as exc:
    print("ERROR", exc.args[0])

go_to_sleep()



