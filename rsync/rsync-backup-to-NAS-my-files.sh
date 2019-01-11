#!/bin/bash
rsync -ahPruvz --chmod 775 /home/matthias/Dropbox/dokumente/_data /mnt/NAS/dokumente/
rsync -ahPruvz --chmod 775 /home/matthias/Dropbox/dokumente/Apps /mnt/NAS/dokumente/
rsync -ahPruvz --chmod 775 /home/matthias/Dropbox/dokumente/v_latexvorlage /mnt/NAS/dokumente/
rsync -ahPruvz --chmod 775 /home/matthias/Dropbox/dokumente/v_ppvorlage /mnt/NAS/dokumente/
rsync -ahPruvz --chmod 775 /home/matthias/Dropbox/dokumente/v_wordvorlage /mnt/NAS/dokumente/
rsync -ahPruvz --chmod 775 /home/matthias/Dropbox/dokumente/v_pmvorlage /mnt/NAS/dokumente/


rsync -ahPruvz --chmod 775 /home/matthias/Dropbox/Pics /mnt/NAS/
rsync -ahPruvz --chmod 775 /home/matthias/Dropbox/Kamera-Uploads /mnt/NAS/
rsync -ahPruvz --chmod 775 /home/matthias/Gdrive/e_books /mnt/NAS/
rsync -ahPruvz --chmod 775 /home/matthias/OneDrive/Promotion /mnt/NAS/
rsync -ahPruvz --chmod 775 --exclude-from exclude-list.txt /home/matthias/data/workspace /mnt/NAS/
rsync -ahPruvz --chmod 775 /home/matthias/data/Masterthesis /mnt/NAS/
