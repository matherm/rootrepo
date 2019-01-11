#!/bin/bash

declare -a TESLATOKENS=('15f8' 'Tesla')
declare -a GEDORCETOKENS=('1080' '2080' 'GeForce')
declare -a GEFORCEDRIVERS=('410.73' '384.130')
declare -a TESLADRIVERS=('410.72' '384.66' '396.44')

#
# Identify current configuration
#
export graphics_card=$(lspci | grep NVIDIA)
echo Detected NVIDIA Graphics card
echo $graphics_card

#
# Find matching driver
#
for t in "${TESLATOKENS[@]}"
do
        if [[ $graphics_card =~ $t ]]
        then
                driver_version=${TESLADRIVERS[0]}
		is_tesla=true
	fi
done

for t in "${GEFORCETOKENS[@]}"
do
        if [[ $graphics_card =~ $t ]]
        then
        	driver_version=${GEFORCEDRIVERS[0]}
		is_tesla=false
	fi
done

#
# Go-on with installation
#
echo Installing driver...
echo $driver_version

sudo rm /var/cache/apt/archives/lock-frontend
sudo rm /var/lib/dpkg/lock-frontend
sudo rm /var/lib/apt/lists/lock-frontend
#
# Add repo
#
if [[ $is_tesla == true ]]
then
	sudo add-apt-repository --remove ppa:graphics-drivers
	sudo apt-key adv --fetch-keys  http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub
	sudo bash -c 'echo "deb http://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64 /" > /etc/apt/sources.list.d/cuda.list'
	sudo apt-get update
else
	sudo add-apt-repository ppa:graphics-drivers
	sudo rm /etc/apt/sources.list.d/cuda.list
	sudo apt-get update
fi

#
# Remove old drivers

sudo systemctl stop lightdm
sudo apt -y remove nvidia-* 
sudo apt -y purge nvidia-*
sudo apt -y purge cuda-*
sudo apt-get -y autoremove --purge

#
# Download new driver
#
URL_GEFORCE=http://us.download.nvidia.com/XFree86/Linux-x86_64/410.73/NVIDIA-Linux-x86_64-410.73.run
URL=http://us.download.nvidia.com/tesla/410.72/NVIDIA-Linux-x86_64-410.72.run
#URL=https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1604/x86_64
#fName=nvidia-${driver_version:0:3}_${driver_version}-0ubuntu1_amd64.deb
#if [ ! -f $fName ]; then
#	wget $URL/$fName
#fi

#
# Install#
#sudo apt -y install nvidia-410
#sudo apt -y install cuda-10-0
#sudo dpkg -i $fName
#sudo apt-get -y install cuda-drivers
#sudo apt-get -y install nvidia-cuda-toolkit

# Restart lightdm
#sudo systemctl start lightdm

# set PATH for cuda 10.0 installation
#echo "if [ -d "/usr/local/cuda-10.0/bin/" ]; then" >> ~/.bashrc
#echo "   export PATH=/usr/local/cuda-10.0/bin${PATH:+:${PATH}}" >> ~/.bashrc
#echo "   export LD_LIBRARY_PATH=/usr/local/cuda-10.0/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}" >> ~/.bashrc
#echo "fi" >> ~/.bashrc
