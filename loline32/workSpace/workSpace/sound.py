import time, gc, os, array
from machine import Pin, ADC, Timer
from time import sleep_ms
from ulab import numpy as np
from ulab import utils
import math, random

gc.collect()
print("Free mem:", gc.mem_free())

# IO
sound_digital_id = 34
sound_analog_id = 33 
digi = Pin(sound_digital_id  , Pin.IN)
pot = ADC(Pin(sound_analog_id))
pot.atten(ADC.ATTN_11DB) 
pot.width(ADC.WIDTH_11BIT)

def hamm(M):
    x = np.arange(M, dtype=np.float)
    pi = np.array([2*np.pi/(M - 1)])
    a_54, b_46 = np.array([0.54]), np.array([0.46])
    return a_54 - b_46*np.cos(pi*x)
    
def hz_on_s(n, N, df):
    return df*n if n<N/2 else df*(n-N)

class SoundDetector():
  
  def __init__(self, HZ = 5000, N = 2048, min_freq=1400, max_freq=2100, min_amp = 5000, led=None , led_amp=3000):

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
    self.min_led_amp = led_amp

    # RUNTIME VARS
    self.MEMORY = [0] * N
    self.HANN = hamm(N)
    self.last_sample_time, self.ticks, self.max_ticks, self.start_ticks = 0, 0, 0, 0
    self.ana_val, self.detected, self.dc = 0, 0, 0
    self.iamp = 0
    self.ticks = 0
    self.el_ticks = 0
    self.led = led.value if led is not None else lambda x : x
    self.error_count = 0
    
  def _detect(self, ABS, df):
    self.iamp = 0
    for n, amp in enumerate(ABS):
      freq = hz_on_s(n, self.N, df)
      if freq > self.min_freq and freq < self.max_freq:
         self.iamp = self.iamp + amp
    self.detected = 0
    if self.iamp > self.min_amp:
      self.detected = 1
      
  def _analyze(self, samples, listener, cycle_us):
    Hz = 1000*1000*self.N/cycle_us 
    df = Hz / self.N
    try:
      dc = np.mean(samples)
      RE, IM = np.fft.fft((samples - dc) * self.HANN)
      RE2 = RE**2
      del RE
      IM2 = IM**2
      del IM
      RM = RE2 + IM2
      del RE2, IM2
      ABS = np.sqrt(RM)[:self.N//2] 
          
      # DETECTION
      self._detect(ABS, df)
      
      # LOG 'N' CLEAN UP
      record = [(int(hz_on_s(n, self.N, df)), ABS[n]) for n in np.argsort(ABS, axis=0)[::-1][:4]]
      if self.ticks % 5 == 0 or self.detected or self.iamp > self.min_led_amp:
        print(time.ticks_ms() - self.start_ticks, "ms -", Hz, "Hz", record, "- memory", gc.mem_free() // 1000, "kB", "- status", self.detected, "(", self.iamp, ")")
      del ABS, record
      
      # LISTENER      
      if self.detected:
        if listener is not None:
          for l in listener:
            l(self.detected)
      
      # RESET ERROR COUNTER
      self.error_count = 0
    except Exception as exc:
      self.error_count = self.error_count + 1
      print("ERROR", exc.args[0])
    
    
  def listen(self, record_length=10000, listener = [], early_stop=False):
    gc.collect()
    print("Hz:", self.HZ, "T:", self.T, "record_length: ", record_length, "min_freq:", self.min_freq, "max_freq:", self.max_freq, "min_amp:", self.min_amp, "Free mem:", gc.mem_free())
    
    self.start_ticks  = time.ticks_ms()
    self.last_sample_time, self.ticks = 0, 0
    t0 = time.ticks_us()
    self.el_ticks = 0
    self.error_count = 0
    while True:
 
      # SOFTWARE SAMPLING
      if time.ticks_us() - self.last_sample_time >= self.SAMPLE_INTERVAL_US: 
        self.last_sample_time = self.last_sample_time +  self.SAMPLE_INTERVAL_US
        
        self.MEMORY[  self.el_ticks ] = pot.read()
        self.el_ticks =  self.el_ticks + 1
        
        if self.el_ticks % self.N == 0:
          
          # COPY
          samples = np.array(self.MEMORY)
        
        # ANALYZE
          self._analyze(samples, listener, time.ticks_us() - t0)
          
          # BLINK
          self.led(self.iamp > self.min_led_amp)
          
          # Free
          gc.collect()
          t0 = time.ticks_us()
          self.ticks = self.ticks +  self.el_ticks 
          self.el_ticks = 0
        
                                       
        # TIME LIMIT
        if (time.ticks_ms() >= self.start_ticks + record_length) or (self.detected and early_stop) or (self.error_count > 10):
          break
    
    gc.collect()
    print("Free mem:", gc.mem_free())
 
 
################################################################
# MAIN
################################################################
#s = SoundDetector()
#s.listen()
#del s


