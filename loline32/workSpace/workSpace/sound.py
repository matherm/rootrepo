import time, gc, os
from machine import Pin, ADC
from time import sleep_ms
from ulab import numpy as np
import math, random

gc.collect()
print("Free mem:", gc.mem_free())

# IO
led_id = 22
sound_digital_id = 34
sound_analog_id = 33 
led = Pin(led_id  , Pin.OUT)
digi = Pin(sound_digital_id  , Pin.IN)
pot = ADC(Pin(sound_analog_id))
pot.atten(ADC.ATTN_11DB   ) 
pot.width(ADC.WIDTH_11BIT)
led.value(0)

def hann(M):
    x = np.arange(M, dtype=np.float)
    pi = np.array([2*np.pi/(M - 1)])
    a_54, b_46 = np.array([0.54]), np.array([0.46])
    return a_54 - b_46*np.cos(pi*x)
    
def hz_on_s(n, N, df):
    return df*n if n<N/2 else df*(n-N)

def led_listener(status):
  led.value(status)

class SoundDetector():
  
  def __init__(self, HZ = 5000, N = 2048, min_freq=1400, max_freq=2100, min_amp = 100):

    # SAMPLING CONSTANTS
    self.HZ = HZ
    self.SAMPLE_INTERVAL = 1./HZ # 20 kHz
    self.N = N
    self.T = self.SAMPLE_INTERVAL*N
    self.df = 1/self.T
    self.dw = 2*np.pi/self.T # =df*2*pi
    self.ny = self.dw*N/2
    
    # DETECTION CONSTANTS
    self.min_freq = min_freq
    self.max_freq = max_freq
    self.min_amp = min_amp

    # RUNTIME VARS
    self.MEMORY = np.array([0] * N)
    self.HANN = hann(N)
    self.last_sample_time, self.ticks, self.max_ticks, self.start_ticks = 0, 0, 0, 0
    self.ana_val, self.detected, self.dc = 0, 0, 0
    
  def _detect(self, record):
    self.detected = 0
    for freq, amp in record:
      if freq > self.min_freq and freq < self.max_freq and amp > self.min_amp:
        self.detected = 1

  def listen(self, record_length=10000, listener = [led_listener], early_stop=False):
    gc.collect()
    print("Hz:", self.HZ, "T:", self.T, "record_length: ", record_length, "Free mem:", gc.mem_free())
    
    #max_ticks = record_length * HZ//1000
    self.start_ticks  = time.ticks_ms()
    self.last_sample_time, self.ticks = 0, 0
    while True:

      # SOFTWARE SAMPLING
      if time.ticks_ms() - self.last_sample_time >= self.SAMPLE_INTERVAL: 
        self.last_sample_time = self.last_sample_time + self.SAMPLE_INTERVAL   
        self.ticks = self.ticks + 1
        self.ana_val = float(pot.read())
        self.MEMORY[self.ticks % self.N] = self.ana_val
        
      # RING BUFFER
      if self.ticks % self.N == 0:
        try: 
          self.dc = np.mean(self.MEMORY)
          RE, IM = np.fft.fft((self.MEMORY - self.dc) * self.HANN)
          ABS = np.sqrt(RE**2 + IM**2)[:self.N//2]
          freq_idx = np.argsort(ABS, axis=0, )[::-1][:4]
          record = [(int(hz_on_s(n, self.N, self.df)), ABS[n]) for n in freq_idx]
          
          # DETECTION
          self._detect(record)
          if listener is not None:
            for l in listener:
              l(self.detected)
                  
          # LOG 'N' CLEAN UP
          print(time.ticks_ms() - self.start_ticks, "ms -", record[:2], "- memory", gc.mem_free() // 1000, "Kb", "- status", self.detected)
          del RE, IM, ABS, freq_idx, record
                
        except Exception as exc:
          print("ERROR", exc.args[0])
          
        # SLEEP TO BREAK SYMMETRIC SAMPLING
        sleep_ms(random.randint(1, 2) * 100)
           
      # TIME LIMIT
      if time.ticks_ms() >= self.start_ticks + record_length:
        break
      
      # EARLY STOP
      if self.detected and early_stop:
        break
    
    gc.collect()
    print("Free mem:", gc.mem_free())
 
 
################################################################
# MAIN
################################################################
#s = SoundDetector()
#s.listen()
#del s




