#!/bin/sh
echo "Downloading ghidra"
wget https://ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip
unzip ghidra_9.0_PUBLIC_20190228.zip
./install-jdk.sh
./install-scaling.sh
cp ghidra ghidra_9.0/
cp ghidra4K ghidra_9.0/
cp run_scaled ghidra_9.0/
sudo rm -rf /opt/ghidra_9.0
sudo mv ghidra_9.0 /opt/ghidra_9.0
cp ghidra.desktop ~/Desktop/ghidra.desktop
cp ghidra.desktop ~/Schreibtisch/ghidra.desktop
sudo ln -s /opt/ghidra_9.0/ghidra /usr/bin/ghidra
sudo ln -s /opt/ghidra_9.0/ghidra4K /usr/bin/ghidra4K
patch -p0 -i patch.diff /opt/ghidra_9.0/support/launch.sh
rm ghidra_9.0_PUBLIC_20190228.zip
echo "Successfully installed Ghidra 9.0 to /opt/ghidra_9.0."
echo "Run using: ghidra or ghidra4K"
echo "Edit /opt/ghidra_9.0/ghidra4K for other scaling factors than 1.4."

