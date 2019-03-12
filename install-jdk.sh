#!/bin/sh
echo "Downloading JDK .. please wait..."
sudo add-apt-repository ppa:openjdk-r/ppa -y
sudo apt update
sudo apt install openjdk-11-jdk -y
