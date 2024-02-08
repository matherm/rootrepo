import numpy as np
import matplotlib.pyplot as plt
from .plots import *

def p2r(radii, angle, deg=True):
    angle = angle * np.pi/180 if deg else angle
    return radii * np.exp(1j*angle)

def r2p(x, deg=True):
    angle = np.angle(x)
    return np.abs(x), angle * 180/np.pi if deg else angle

def cart2sph(x,y,z):
    azimuth = np.arctan2(y,x)
    elevation = np.arctan2(z,np.sqrt(x**2 + y**2))
    r = np.sqrt(x**2 + y**2 + z**2)
    return azimuth, elevation, r

def sph2cart(azimuth,elevation,r):
    x = r * np.cos(elevation) * np.cos(azimuth)
    y = r * np.cos(elevation) * np.sin(azimuth)
    z = r * np.sin(elevation)
    return x, y, z
