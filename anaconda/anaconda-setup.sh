cd /tmp
curl -O https://repo.continuum.io/archive/Anaconda3-5.0.1-Linux-x86_64.sh

bash Anaconda3-5.0.1-Linux-x86_64.sh
source ~/.bashrc
conda create --name pytorch python=3.5 anaconda pytorch torchvision

#apt-get install nvidia-384
#apt-get install nvidia-cuda-toolkit

curl -O https://developer.nvidia.com/compute/cuda/8.0/Prod2/local_installers/cuda_8.0.61_375.26_linux-run
sudo sh cuda_8.0.61_375.26_linux-run

