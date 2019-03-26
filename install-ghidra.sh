#!/bin/sh
echo "Downloading ghidra"
wget https://ghidra-sre.org/ghidra_9.0.1_PUBLIC_20190325.zip
unzip ghidra_9.0.1_PUBLIC_20190325.zip
./install-jdk.sh
./install-scaling.sh
cp ghidra ghidra/
cp ghidra4K ghidra/
cp run_scaled ghidra/
sudo rm -rf /opt/ghidra
sudo mv ghidra /opt/ghidra
cp ghidra.desktop ~/Desktop/ghidra.desktop
cp ghidra.desktop ~/Schreibtisch/ghidra.desktop
sudo ln -s /opt/ghidra/ghidra /usr/bin/ghidra
sudo ln -s /opt/ghidra/ghidra4K /usr/bin/ghidra4K
patch -p0 -i patch.diff /opt/ghidra/support/launch.sh
rm ghidra_9.0.1_PUBLIC_20190325.zip
echo "Successfully installed Ghidra 9.0.1 to /opt/ghidra."
echo "Run using: ghidra or ghidra4K"
echo "Edit /opt/ghidra/ghidra4K for other scaling factors than 1.4."

