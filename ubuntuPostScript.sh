#!/bin/bash
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install aptitude -y

sudo add-apt-repository ppa:tsvetko.tsvetkov/cinnamon -y
sudo add-apt-repository ppa:webupd8team/tor-browser -y
sudo add-apt-repository ppa:ubuntu-wine/ppa -y
sudo add-apt-repository ppa:noobslab/apps -y
sudo add-apt-repository ppa:tualatrix/ppa -y
sudo add-apt-repository ppa:xorg-edgers/ppa -y

sudo apt-get update
sudo apt-get dist-upgrade -y

sudo apt-get install libserial-dev ubuntu-restricted-extras torsocks libdvdread4 nautilus-open-terminal cinnamon tor-browser indicator-synapse indicator-* arduino vim aptitude audacity cmake make build-essential geda indicator-synapse bumblebee bumblebee-nvidia primus linux-headers-generic ubuntu-tweak rar unace p7zip-full p7zip-rar sharutils mpack lha arj synaptic gdebi ttf-mscorefonts-installer compizconfig-settings-manager lm-sensors hddtemp psensor k3b shutter kde-l10n-es dconf-tools libavcodec-extra -y
sudo /usr/share/doc/libdvdread4/install-css.sh
sudo aptitude update

if [ $? -eq 0 ]; then
    echo "OK"
else
    echo "ERROR!"
fi
