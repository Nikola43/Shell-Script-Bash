#!/bin/bash

sudo apt-get install git -y
git clone https://github.com/numixproject/numix-icon-theme-circle.git
cd numix-icon-theme-circle
sudo mv Numix-Circle /usr/share/icons
sudo mv Numix-Circle-Light /usr/share/icons
