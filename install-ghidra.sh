#!/bin/sh
echo "Downloading ghidra"
wget https://ghidra-sre.org/ghidra_9.0_PUBLIC_20190228.zip
unzip ghidra_9.0_PUBLIC_20190228.zip
./install-jdk.sh
./install-scaling.sh
cp ghidraRun ghidra_9.0/
cp run_scaled ghidra_9.0/
mv ghidra_9.0 ~/ghidra_9.0
rm ghidra_9.0_PUBLIC_20190228.zip
echo "Successfully installed Ghidra 9.0 to ~/ghirda_9.0."
echo "cd to ~/ghidra_9.0 and run as: ./run_scaled --scale=1.4 ./ghidraRun"

