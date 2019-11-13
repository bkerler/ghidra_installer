#!/bin/sh
echo "Downloading JDK .. please wait..."

#@bernd: I dont have this on Debian/Kali ... fails
sudo add-apt-repository ppa:openjdk-r/ppa -y > /dev/null 2>&1

sudo apt update
sudo apt install openjdk-11-jdk -y
