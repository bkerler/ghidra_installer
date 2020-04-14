# ghidra_installer
Helper scripts to set up OpenJDK 11 and scale Ghidra for 4K on Ubuntu 16.x / 18.x / 19.x
The script will automatically detect available versions for downloading at https://ghidra-sre.org

# To install ghidra :
   ```
   ~$ sudo apt install git
   ~$ cd /tmp
   /tmp$ git clone https://github.com/bkerler/ghidra_installer
   /tmp$ cd ghidra_installer
   /tmp/ghidra_installer$ ./install-ghidra.sh
   ```

# or doing it manually :
* Grab and install ghidra from https://ghidra-sre.org or https://github.com/NationalSecurityAgency/ghidra

* Install OpenJDK 11

* To run :

   ```
   ~$ ghidra
   ```
