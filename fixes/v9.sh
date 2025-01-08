#!bin/zsh

# Entropy v9 FIX
echo "Uncommenting MX repos"
sudo sed -i -E 's/^# ?deb/deb/' /etc/apt/sources.list.d/mx.list
echo "Adding i386 support back"
sudo dpkg --add-architecture i386
sudo nala update
nala list --upgradeable
echo "Your v9 is fixed, and those are packages you can upgrade with sudo apt upgrade"
sleep 1
exit
