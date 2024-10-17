#!/bin/bash
# Critical fix 1
# Fixes Entropy v7 bug of not saving browser cache

clear
echo "Press 'Y' if script asks to use maintainer version"
sleep 3
sudo apt install ntp -y 
chmod 700 ~/.config
chmod 700 ~/.cache
sudo chown -R $(whoami):$(whoami) ~/.config
sudo chown -R $(whoami):$(whoami) ~/.cache

clear && echo "Complete"
