#!/bin/bash
# 
# Builds and runs ´Dockerfile´ and starts IPython.
# 
# Don't forget ´git submodule update --init --recursive`
#
# Example usage:
#	´ps dockerrun.sh $HOME/.ssh/id_rsa´    
#    >> [1] ...
# 
# @author matthias hermann <matthias.hermann@htwg.konstanz.de>
# param(
# 	[string]$gitkey
# )

# # Get GIT-Credentials for cloning repos   
# if ($gitkey.length -eq 0 ) { 
# 	$user = Read-Host -Prompt "Username for 'https://git.ios.htwg-konstanz.de'"
# 	[System.Security.SecureString]$SecurePassword = Read-Host -Prompt "Password for 'https://git.ios.htwg-konstanz.de'" -AsSecureString
# 	$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($SecurePassword)
# 	$password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
# }else{
# 	$raw_gitkey = $(gc $gitkey)
# }
# docker build --build-arg USER="$user" --build-arg PASSWORD="$password" --build-arg SSH_PRIVATE_KEY="$raw_gitkey" -t box -f Dockerfile .

# Update submodules
#git submodule update --init --recursive

# Build docker container
docker -D build -t box -f Dockerfile .

# Kill any running container
docker kill box
docker rm box

# Test if nvidia-docker is available by calling nvidia-smi 
$runtime = ""
if ($(Get-Command nvidia-smi -EA SilentlyContinue).name.length -gt 0){
	$runtime = "--runtime=nvidia"
}

# Run the docker
docker -D run $runtime `
			-d --name box `
			-v ${PWD}:/home `
			-v ${EXTDATA}:/ext `
			-p 40105:40105 -p 40106:40106 -p 40102:40102 -p 40103:40103 -p 40104:40104 -p 3000:3000 -p 5678:5678 `
			box:latest 

# Copy the environment file
rm environment.yml
rm requirements.txt
docker exec -i box conda env export > environment.yml
docker exec -i box pip freeze > requirements.txt

# Finally... Start ipython
docker exec -it box sh -c "cd /home && ipython"     	    # start ipython inside of docker
#jupyter qtconsole --existing kernel-1.json--ssh localhost  # start ipython locally via ssh