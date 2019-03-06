# ghidra_installer
Helper scripts to set up OpenJDK 11 and scale Ghidra for 4K on Ubuntu 18.04 / 18.10

# !!! Copy files to the ghidra install directory !!!

* Install OpenJDK 11:
```
./install-jdk.sh
```

* Install Tools needed for proper 4k scaling:
```
./install-scaling.sh
```

* To run :
```
./run_scaled --scale=1.45 ./ghidraRun
```
For other scales like factor 2, replace 1.45 with your desired scaling factor
