#!/bin/sh

echo "--> Updating System"
sudo apt-get update
sudo apt-get dist-upgrade

echo "--> Installing Software (System)"
sudo apt-get install build-essential git subversion python3 ccache graphviz gnuplot valgrind cifs-utils htop unzip wget curl

echo "--> Installing C++ Libraries (System)"
sudo apt-get install libboost-all-dev cython3 libeigen3-dev libmagick++-dev swig python3-dev

echo "--> Installing Python Libraries (System)"
sudo apt-get install python3-matplotlib python3-nose python3-numpy python3-pandas python3-pip python3-skimage python3-sklearn python3-scipy python3-setuptools python3-sphinx python3-sympy python3-pyfits

echo "--> Installing Python Libraries (Local User)"
pip3 install --upgrade --user pillow imread theano
