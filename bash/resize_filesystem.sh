#!/bin/sh
sudo umount -l /dev/vdb1
sudo fdisk /dev/vdb > d > p > w
sudo fdisk /dev/vdb > n > ... > w
sudo e2fsck -f /dev/vdb1
sudo resize2fs /dev/vdb1 
sudo mount /dev/vdb1 /home_ext