# ghidra_installer
Helper scripts to set up OpenJDK 11 and scale Ghidra for 4K on Ubuntu 16.x / 18.04 / 18.10
The script will automatically detect available versions for downloading at https://ghidra-sre.org

# To install ghidra :
```
~$ ./install-ghidra.sh
```

# or doing it manually :
* Grab and install ghidra from https://ghidra-sre.org or https://github.com/NationalSecurityAgency/ghidra

* Install OpenJDK 11:
```
~$ ./install-jdk.sh
```

* Install Tools needed for proper 4k scaling:
```
~$ ./install-scaling.sh
```

* To run :

For HD resolution:
```
~$ ghidra
```

For 4K resolution:
```
~$ ghidra4K
```

Sometimes in order for the 4K version to work, you need to start the regular ghidra version at least once.
For other scales like factor 2, replace 1.45 with your desired scaling factor in the ghidra4K script
