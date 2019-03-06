#!/bin/sh
echo "Downloading ghidra"
wget https://ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip
unzip ghidra_9.0_PUBLIC_20190228.zip
./install-jdk.sh
./install-scaling.sh
cp ghidra ghidra_9.0/
cp run_scaled ghidra_9.0/
sudo rm -rf /opt/ghidra_9.0
sudo mv ghidra_9.0 /opt/ghidra_9.0
cp ghidra.desktop ~/Desktop/ghidra.desktop
cp ghidra.desktop ~/Schreibtisch/ghidra.desktop
sudo ln -s /opt/ghidra_9.0/ghidra /usr/bin/ghidra
rm ghidra_9.0_PUBLIC_20190228.zip
echo "Successfully installed Ghidra 9.0 to /opt/ghirda_9.0."
echo "Run using: ghidra"
echo "Edit /opt/ghirda_9.0/ghidra for other scaling factors than 1.4."

