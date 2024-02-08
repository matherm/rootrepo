#!/bin/bash
#
# Script for executing commands on a remote machine.
#
# >> bash remote_command.sh [REMOTE] [COMMAND] [SSH_KEY]
#
#
HOST=$1
COMMAND=$2
RSA=$3
MNT_POINT="$HOME/.remote"
DOMAIN=".local"

echo "=============================================="
echo "Host: ${HOST}"
echo "Command: ${COMMAND}"
echo "Reverse-mount: //${HOSTNAME}${DOMAIN}${PWD}"
echo "STD-output file: //${HOSTNAME}${DOMAIN}${PWD}/${HOST}.out"
echo ""
echo ">> Uses sshfs for reverse mount"
echo "=============================================="
echo ""

helpFunction()
{
   echo ""
   echo "Usage: $0 [HOST] [COMMAND] [ID_RSA]"
   exit 1 # Exit script after printing help
}

# Print helpFunction in case parameters are empty
if [ -z "$HOST" ] || [ -z "$COMMAND" ] || [ -z "$RSA" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

echo "# Connect ${HOST}"
echo "User: $USER"
echo "Sending RSA key ${HOME}/.ssh/$RSA"
scp ${HOME}/.ssh/$RSA ${HOST}:${HOME}/.ssh/
echo ""

echo "# Check sshfs or install"
ssh -t ${HOST} "if (! command -v sshfs);then sudo apt install -y sshfs; fi"
echo ""

echo "# Reverse mount"
echo "sshfs -o nonempty ${USER}@${HOSTNAME}${DOMAIN}:${PWD} ${MNT_POINT}"
ssh ${HOST} "mkdir -p ${MNT_POINT}"
ssh ${HOST} "sshfs -o nonempty ${USER}@${HOSTNAME}${DOMAIN}:${PWD} ${MNT_POINT}"
echo ""

echo "# Edit .bashrc to enable remote bash session"
echo "sed -i '/case $- in/,+4 s/^/#/' .bashrc"
ssh ${HOST} "sed -i '/case $- in/,+4 s/^/#/' .bashrc"
echo ""

echo "# Execute command in ${MNT_POINT}"
echo "bash -c ${COMMAND} >> ${HOST}.out"
ssh -t ${HOST} bash -c "cd ${MNT_POINT};${COMMAND}"
echo ""

echo "# Cleanup remote host"
echo "umount ${MNT_POINT}"
ssh ${HOST} "umount ${MNT_POINT}"
echo "rm ${HOME}/.ssh/$RSA"
ssh ${HOST} "rm ${HOME}/.ssh/$RSA"
