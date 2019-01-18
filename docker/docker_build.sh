#!/bin/bash
# 
# Builds and runs ´Dockerfile´ and starts IPython.
# 
# Don't forget ´git submodule update --init --recursive`
#
# Example usage:
#	´sh docker_build.sh ~/.ssh/id_rsa´    
#    >> [1] ...
# 
# @author matthias hermann <matthias.hermann@htwg.konstanz.de>
# Get GIT-Credentials for cloning repos    
# gitkey=$1
# if [ ${#gitkey} == 0 ] ; then  
# 	 read -p    "Username for 'https://git.ios.htwg-konstanz.de'" user
#    read -s -p "Password for 'https://git.ios.htwg-konstanz.de'" password ;
# fi
# docker -D build --build-arg USER=${user} --build-arg PASSWORD=${password} --build-arg SSH_PRIVATE_KEY="$(cat ${gitkey})"  -t box -f Dockerfile .

# Update submodules
echo "(1/6) Updating submodules.."
git submodule update --init --recursive

# Build docker container
echo "(2/6) Building docker image.."
docker build -t box -f Dockerfile .

# Kill any running container
echo "(3/6) Kill existing container.."
docker kill box && docker rm box

# Test if nvidia-docker is available by calling nvidia-smi 
if which nvidia-smi > /dev/null 2>&1; then runtime="--runtime=nvidia" ; else  runtime=""; fi;

# Run the docker
echo "(4/6) Run container.."
docker -D run ${runtime} \
			-d --name box \
			-v $PWD:/home \
			-v $EXTDATA:/ext \
			-p 40105:40105 -p 40106:40106 -p 40102:40102 -p 40103:40103 -p 40104:40104 -p 3000:3000 -p 5678:5678\
			box:latest 

# Copy the environment file
echo "(5/6) Get environment.yml and requirements.txt from docker environment.."
rm environment.yml
rm requirements.txt
docker exec -i box conda env export > environment.yml
docker exec -i box pip freeze > requirements.txt

# Finally... Start bash
echo "(6/6) Exec bash.."
docker exec -it box bash