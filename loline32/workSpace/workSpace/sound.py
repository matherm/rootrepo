import time, gc, os
from machine import Pin, ADC
from time import sleep_ms
from ulab import numpy as np
import math
print("Free mem ", gc.mem_free())

def hann(M):
    x = np.arange(M, dtype=np.float)
    pi = np.array([2*np.pi/(M - 1)])
    a_54, b_46 = np.array([0.54]), np.array([0.46])
    return a_54 - b_46*np.cos(pi*x)
    
def hz_on_s(n, N, df):
    return df*n if n<N/2 else df*(n-N)
    
# IO
led_id = 22
sound_digital_id = 34
sound_analog_id = 33 
led = Pin(led_id  , Pin.OUT)
digi = Pin(sound_digital_id  , Pin.IN)
pot = ADC(Pin(sound_analog_id))
pot.atten(ADC.ATTN_11DB   )       #Full range: 3.3v
pot.width(ADC.WIDTH_11BIT)

# SAMPLING
HZ = 5000
SAMPLE_INTERVAL = 1./HZ # 20 kHz
TIME = 10000 # millis
N = 2048
T = SAMPLE_INTERVAL*N
df = 1/T
dw = 2*np.pi/T # =df*2*pi
ny = dw*N/2

# RUNTIME VARS
MEMORY = np.array([0] * N)
HANN = hann(len(MEMORY))
n_samples = TIME * HZ//1000

def sampling():
  gc.collect()
  print("Hz:", HZ, "T:", T, "record: ", TIME)
   
  last_sample_time, c = 0, 0
  while True:

    # SOFTWARE SAMPLING
    if time.ticks_ms() - last_sample_time >= SAMPLE_INTERVAL: 
      last_sample_time = last_sample_time + SAMPLE_INTERVAL   
      c = c + 1
      ana_val = pot.read()
      MEMORY[c % len(MEMORY)] = float(ana_val)
      

    # RING BUFFER
    if c % len(MEMORY) == 0:
      a, b = np.fft.fft(MEMORY * HANN)
      abs = np.sqrt(a**2 + b**2)[:N//2]
      freq_idx = np.argsort(abs, axis=0, )[::-1][:4]
      record = [(int(hz_on_s(n, N, df)), abs[n]) for n in freq_idx]
      print(record, gc.mem_free())
      
      detected = 0
      for freq, amp in record:
        if freq > 1500:
          detected = 1
      led.value(detected)
            
          
         
    # TIME LIMIT
    if c >= n_samples:
      break
  
  gc.collect()
  print("Free mem ", gc.mem_free())
