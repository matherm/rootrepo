
from machine import Pin
from time import sleep_ms

pin = Pin(12  , Pin.IN, Pin.PULL_UP)

while(True):
  print(pin.value())
  sleep_ms(1000) 
