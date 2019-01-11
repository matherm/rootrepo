#!/bin/bash
# Dokumente
mkdir -p -- "/volumeUSB1/usbshare/dokumente/_data" ; touch "/volumeUSB1/usbshare/dokumente/_data/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/dokumente/_data /volumeUSB1/usbshare/dokumente/_data

mkdir -p -- "/volumeUSB1/usbshare/dokumente/Apps" ; touch "/volumeUSB1/usbshare/dokumente/Apps/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/dokumente/Apps /volumeUSB1/usbshare/dokumente/Apps

mkdir -p -- "/volumeUSB1/usbshare/dokumente/Belege" ; touch "/volumeUSB1/usbshare/dokumente/Belege/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/dokumente/Belege /volumeUSB1/usbshare/dokumente/Belege

mkdir -p -- "/volumeUSB1/usbshare/dokumente/Bewerbung_Promotion" ; touch "/volumeUSB1/usbshare/dokumente/Bewerbung_Promotion/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/dokumente/Bewerbung_Promotion /volumeUSB1/usbshare/dokumente/Bewerbung_Promotion

mkdir -p -- "/volumeUSB1/usbshare/dokumente/FH" ; touch "/volumeUSB1/usbshare/dokumente/FH/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/dokumente/FH /volumeUSB1/usbshare/dokumente/FH

mkdir -p -- "/volumeUSB1/usbshare/dokumente/v_latexvorlage" ; touch "/volumeUSB1/usbshare/dokumente/v_latexvorlage/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/dokumente/v_latexvorlage /volumeUSB1/usbshare/dokumente/v_latexvorlage

mkdir -p -- "/volumeUSB1/usbshare/dokumente/v_ppvorlage" ; touch "/volumeUSB1/usbshare/dokumente/v_ppvorlage/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/dokumente/v_ppvorlage /volumeUSB1/usbshare/dokumente/v_ppvorlage

mkdir -p -- "/volumeUSB1/usbshare/dokumente/v_wordvorlage" ; touch "/volumeUSB1/usbshare/dokumente/v_wordvorlage/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/dokumente/v_wordvorlage /volumeUSB1/usbshare/dokumente/v_wordvorlage

mkdir -p -- "/volumeUSB1/usbshare/dokumente/v_pmvorlage" ; touch "/volumeUSB1/usbshare/dokumente/v_pmvorlage/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/dokumente/v_pmvorlage /volumeUSB1/usbshare/dokumente/v_pmvorlage

mkdir -p -- "/volumeUSB1/usbshare/dokumente/Zerts" ; touch "/volumeUSB1/usbshare/dokumente/Zerts/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/dokumente/Zerts /volumeUSB1/usbshare/dokumente/Zerts

# E-Books
mkdir -p -- "/volumeUSB1/usbshare/e_books" ; touch "/volumeUSB1/usbshare/e_books/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/e_books /volumeUSB1/usbshare/e_books

# Git-Auth
mkdir -p -- "/volumeUSB1/usbshare/Git_auth" ; touch "/volumeUSB1/usbshare/Git_auth/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/Git_auth /volumeUSB1/usbshare/Git_auth

# Pics
mkdir -p -- "/volumeUSB1/usbshare/Pics" ; touch "/volumeUSB1/usbshare/Pics/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/Pics /volumeUSB1/usbshare/Pics

mkdir -p -- "/volumeUSB1/usbshare/Pictures" ; touch "/volumeUSB1/usbshare/Pictures/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/Pictures /volumeUSB1/usbshare/Pictures

mkdir -p -- "/volumeUSB1/usbshare/Kamera-Uploads" ; touch "/volumeUSB1/usbshare/Kamera-Uploads/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/Kamera-Uploads /volumeUSB1/usbshare/Kamera-Uploads

# Promotion
mkdir -p -- "/volumeUSB1/usbshare/Promotion" ; touch "/volumeUSB1/usbshare/Promotion/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/Promotion /volumeUSB1/usbshare/Promotion

# Workspace
mkdir -p -- "/volumeUSB1/usbshare/workspace" ; touch "/volumeUSB1/usbshare/workspace/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/workspace /volumeUSB1/usbshare/workspace /volume1/NAS/exclude-list.txt

# Masterthesis
mkdir -p -- "/volumeUSB1/usbshare/Masterthesis" ; touch "/volumeUSB1/usbshare/Masterthesis/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/Masterthesis /volumeUSB1/usbshare/Masterthesis

# Bachelor
mkdir -p -- "/volumeUSB1/usbshare/dokumente/BA/data" ; touch "/volumeUSB1/usbshare/dokumente/BA/data/backup.marker"
sh /volume1/NAS/rsync-time-backup.sh /volume1/NAS/dokumente/BA/data /volumeUSB1/usbshare/dokumente/BA/data

