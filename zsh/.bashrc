#
# ~/.bashrc
#


# Shell navigation
alias ls='ls -F --color=auto'
alias ..='cd ..'
alias l.='ls -Fd .* --color=auto'
alias ll='ls -Flh'
alias la='LC_COLLATE=C ls -Flha'
alias lst="ls -FlAtr --color=auto"
alias cd..='cd ..' 
alias ..='cd ..' 
alias ...='cd ../../../' 
alias ....='cd ../../../../' 
alias .....='cd ../../../../' 
alias .4='cd ../../../../' 
alias .5='cd ../../../../..'
alias ~='cd ~'
alias etc='cd /etc'
alias work='cd /home/matthias/Desktop/workspace'
alias scripts='cd /data/workspace/rootrepo/BashscriptsClient/'

# Basic operations
alias mkdir='mkdir -pv'
alias mv='mv -i' 
alias cp='cp -i' 
alias ln='ln -i'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias df='df -H'
alias du='du -ch'
alias find='find . -iname'
alias search='grep -rnwi . -e'

# GIT
alias git-commit-all='git add -A && git commit'
alias git-reset='git reset --hard'
alias git-fix-line-endings='\find . -type f -exec dos2unix -k -s -o {} ";"'
alias git-remote-url='git config --get remote.origin.url'
alias git-set-remote-url='git remote set-url origin' 
alias git-commit-all-amend='git add -A && git commit --amend'
alias git-commit-amend='git commit --amend'
alias git-lg1='git log --graph --abbrev-commit --decorate --format=format:"C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)"--all'
alias git-lg2='git log --graph --abbrev-commit --decorate --format=format:"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)" --all'
alias git-lg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'


# Backup
bu() { cp $@ $@.backup-`date +%y%m%d`; }

# Colorize the grep command output for ease of use (good for log files)##
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'

# Apps
alias calc='qalculate-gtk'
alias diff='colordiff'
alias wget='wget -c'
alias curl='curl -O'
alias tar='tar -czvf'
alias untar='tar -xzvf'
alias archey='archey3'
alias vi='vim'
alias watchtail='watch -n .5 tail -n 20'
alias watchdir='watch -n .5 ls -la'
alias watchsize='watch -n .5 du -h –max-depth=1'
alias teamviewer-start-service='systemctl start teamviewerd.service'
alias nas-connect='sudo mount -t cifs -o username=mhermann,password=###! //141.37.176.190/3D /mnt/NAS -o vers=1.0'
alias nas-disconnect='sudo umount /mnt/NAS'
alias files='lsof -a -p'

# Shortcuts
alias path='echo -e ${PATH//:/\\n}'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'
alias ipp='ifconfig | grep inet'

# Networking
alias ports='netstat -tulanp'
alias connections='sudo lsof -n -P -i +c 15'
alias trace='mtr --report-wide --curses $1'
geoip() { \curl ipinfo.io/$@ ;}
alias iptables-list='sudo iptables --list'
alias iptables-disable='sudo sh /data/workspace/rootrepo/BashscriptsClient/disable_firewall.sh'
alias iptables-set='sudo sh /data/workspace/rootrepo/BashscriptsClient/set_firewall.sh'
alias iptables-chromecast='sudo sh /data/workspace/rootrepo/BashscriptsClient/set_firewall_chromecast.sh'
alias iptables-logging='sudo sh /data/workspace/rootrepo/BashscriptsClient/set_firewall_logging.sh'

# Arch Packag Management
alias install='yaourt -S'
alias update='yaourt -Sy'
alias upgrade='yaourt -Syu --aur --ignore anaconda'
alias remove='yaourt -R'
alias lookup='yaourt -Ss'
alias remove-dependencies='yaourt -Qdt'
alias pkg-info='yaourt -Si'
alias fetch='yaourt -G'
alias list-files='yaourt -Ql'
alias group-install='sudo pacman -S'
alias install-local='sudo pacman -U'


export VISUAL=vim
export EDITOR="$VISUAL"
export GIT_EDITOR=vim
export PATH="${PATH}:/opt/anaconda/bin"
