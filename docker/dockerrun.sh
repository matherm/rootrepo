#!/bin/bash
# 
# Builds and runs ´Dockerfile´ and starts IPython.
#
# Example usage:
#	´sh dockerrun.sh ~/.ssh/id_rsa´    
#    >> [1] ...
# 
# @author matthias hermann <matthias.hermann@htwg.konstanz.de>

# Update submodules
git submodule update --init --recursive

# Get GIT-Credentials for cloning repos    
gitkey=$1
if [ ${#gitkey} == 0 ] ; then  
	read -p    "Username for 'https://git.ios.htwg-konstanz.de'" user
	read -s -p "Password for 'https://git.ios.htwg-konstanz.de'" password ;
fi

# Build docker container
docker build --build-arg user=${user} --build-arg password=${password} --build-arg SSH_PRIVATE_KEY="$(cat ${gitkey})"  -t box -f Dockerfile .

# Kill any running container
docker kill box
docker rm box

# Test if nvidia-docker is available by calling nvidia-smi 
if which nvidia-smi > /dev/null 2>&1; then runtime="--runtime=nvidia" ; else  runtime=""; fi;

# Run the docker
docker -D run ${runtime} \
			-d --name box \
			-v $PWD:/home \
			-v /ext:/ext \
			-p 40105:40105 -p 40106:40106 -p 40102:40102 -p 40103:40103 -p 40104:40104 \
			box:latest 

# Copy the environment file
rm environment.yml
rm requirements.txt
docker exec -i box conda env export > environment.yml
docker exec -i box pip freeze > requirements.txt

# Finally... Start ipython
docker exec -it box sh -c "cd /home && ipython"     	    # start ipython inside of docker
#jupyter qtconsole --existing kernel-1.json--ssh localhost  # start ipython locally via ssh