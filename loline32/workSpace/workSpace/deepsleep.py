import machine
import esp32
from machine import Pin
from time import sleep_ms

wake1 = Pin(12  , Pin.IN, Pin.PULL_DOWN)
 
#level parameter can be: esp32.WAKEUP_ANY_HIGH or esp32.WAKEUP_ALL_LOW
esp32.wake_on_ext0(pin = wake1, level = esp32.WAKEUP_ANY_HIGH)
print('Im awake. Going to sleep in 5 seconds')
sleep_ms(5000)
print('Going to sleep now')
machine.deepsleep()
#your main code goes here to perform a task
#for i in range(2):
print(wake1.value())

