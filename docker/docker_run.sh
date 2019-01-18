#!/bin/bash
# Kill any running container
docker kill box && docker rm box

# Test if nvidia-docker is available by calling nvidia-smi 
if which nvidia-smi > /dev/null 2>&1; then runtime="--runtime=nvidia" ; else  runtime=""; fi;

# Run the docker
docker -D run ${runtime} \
			-d --name box \
			-v $PWD:/home \
			-p 40105:40105 -p 40106:40106 -p 40102:40102 -p 40103:40103 -p 40104:40104 -p 3000:3000 -p 5678:5678\
			box:latest 

# Finally... Start ipython
docker exec -it box sh -c "cd /home && ipython"