import time, gc, os
from machine import Pin, ADC, Timer
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
pot.atten(ADC.ATTN_11DB) 
pot.width(ADC.WIDTH_11BIT)
led.value(0)

def hamm(M):
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
    self.SAMPLE_INTERVAL = 1./HZ # s
    self.SAMPLE_INTERVAL_US = int(self.SAMPLE_INTERVAL * 1000 * 1000)
    self.N = N
    self.T = self.SAMPLE_INTERVAL*N
    self.df = HZ / N #1/self.T
    self.dw = 2*np.pi/self.T # =df*2*pi
    self.ny = self.dw*N/2
    
    # DETECTION CONSTANTS
    self.min_freq = min_freq
    self.max_freq = max_freq
    self.min_amp = min_amp

    # RUNTIME VARS
    self.MEMORY = []
    self.HANN = hamm(N)
    self.last_sample_time, self.ticks, self.max_ticks, self.start_ticks = 0, 0, 0, 0
    self.ana_val, self.detected, self.dc = 0, 0, 0
    self.iamp = 0
    self.ticks = 0
    
  def _detect(self, record):
    self.iamp = 0
    for freq, amp in record:
      if freq > self.min_freq and freq < self.max_freq:
         self.iamp = self.iamp + amp
    self.detected = 0
    if self.iamp > self.min_amp:
      self.detected = 1
      
  def _analyze(self, samples, listener, cycle_us):
    try:
      self.dc = np.mean(samples)
      RE, IM = np.fft.fft((samples - self.dc) * self.HANN) # 16 kB
      ABS = np.sqrt(RE**2 + IM**2)[:self.N//2] # OOM
      freq_idx = np.argsort(ABS, axis=0)[::-1][:4]
      Hz = 1000*1000*self.N/cycle_us 
      df = Hz / self.N
      record = [(int(hz_on_s(n, self.N, df)), ABS[n]) for n in freq_idx]
      
      # DETECTION
      self._detect(record)
              
      # LOG 'N' CLEAN UP
      if self.ticks % 5 == 0 or self.detected:
        print(time.ticks_ms() - self.start_ticks, "ms -", Hz, "Hz", record, "- memory", gc.mem_free() // 1000, "kB", "- status", self.detected, "(", self.iamp, ")")
      del RE, IM, ABS, freq_idx, record
      
      # LISTENER      
      if self.detected:
        if listener is not None:
          for l in listener:
            l(self.detected)
            
    except Exception as exc:
      print("ERROR", exc.args[0])
    
    
  def listen(self, record_length=10000, listener = [led_listener], early_stop=False):
    gc.collect()
    print("Hz:", self.HZ, "T:", self.T, "record_length: ", record_length, "min_freq:", self.min_freq, "max_freq:", self.max_freq, "min_amp:", self.min_amp, "Free mem:", gc.mem_free())
    
    self.start_ticks  = time.ticks_ms()
    self.last_sample_time, self.ticks = 0, 0
    t0 = time.ticks_us()
    while True:
 
      # SOFTWARE SAMPLING
      if time.ticks_us() - self.last_sample_time >= self.SAMPLE_INTERVAL_US: 
        self.last_sample_time = self.last_sample_time +  self.SAMPLE_INTERVAL_US
        
        self.ticks = self.ticks + 1
        self.MEMORY.append(pot.read())
        
        if self.ticks % self.N == 0:
          # COPY BUFFERS
          samples = np.array(self.MEMORY)
          del self.MEMORY[:]
                    
          # ANALYZE
          self._analyze(samples, listener, time.ticks_us() - t0)
          
          # SLEEP TO BREAK SYMMETRIC SAMPLING
          self.MEMORY = []
          gc.collect()
          t0 = time.ticks_us()
                                       
        # TIME LIMIT
        if (time.ticks_ms() >= self.start_ticks + record_length) or (self.detected and early_stop):
          break
        
    gc.collect()
    print("Free mem:", gc.mem_free())
 
 
################################################################
# MAIN
################################################################
#s = SoundDetector()
#s.listen()
#del s
