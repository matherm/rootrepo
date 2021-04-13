import time, gc, os
from ulab import numpy as np

TIMING = [0] * 50
ticks = 0
while True:
    ticks = ticks + 1
    TIMING[ticks % len(TIMING)] = time.ticks_us()
    
    if time.ticks_us() - ticks >= 0: 
      pass
     
a = 1000*1000*len(TIMING)/((np.max(TIMING) - np.min(TIMING)))
