#!/bin/bash
sudo apt install preload wget nano git mercurial make pulseaudio libcanberra-pulse mpg123 libldap-2.4-2 libpulse0 libxml2 giflib-tools libpng3 libc6 gtk2-engines gcc gcc-multilib g++ g++-multilib cmake gtk+2.0 gtk+3.0 lm-sensors hddtemp -y

sudo apt install rar unrar p7zip p7zip-full p7zip-rar unace zip unzip bzip2 arj lhasa lzip xz-utils -y

sudo apt install fonts-cantarell fonts-liberation fonts-noto ttf-mscorefonts-installer ttf-dejavu fonts-stix otf-stix fonts-oflb-asana-math fonts-mathjax -y

sudo dpkg --add-architecture i386
sudo apt update

sudo apt install binutils-multiarch libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386 libcanberra-pulse:i386 libldap-2.4-2:i386 libpulse0:i386 libxml2:i386 libpng3:i386 -y

sudo apt-get install vim aptitude -y
sudo apt-get install menulibre -y
