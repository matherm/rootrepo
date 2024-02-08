import time, gc, os
from ulab import numpy as np
from machine import Pin, ADC, Timer


digi = Pin(33  , Pin.IN)
pot = ADC(Pin(32))
pot.atten(ADC.ATTN_11DB) 
pot.width(ADC.WIDTH_11BIT)
print(gc.mem_free())

TIMING = [0] * 50
vals = [0] * 50
ticks = 0
while True:
    ticks = ticks + 1
    TIMING[ticks % len(TIMING)] = time.ticks_us()
    vals[ticks % len(TIMING)] = pot.read()
    
    if time.ticks_us() - ticks >= 0: 
        pass

    if ticks > 100000:
        break
     
a = 1000*1000*len(TIMING)/((np.max(TIMING) - np.min(TIMING)))

