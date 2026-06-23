# ghidra_installer
Helper scripts to set up OpenJDK 21 and scale Ghidra for 4K on Ubuntu, Fedora and macOS.
The script will automatically detect available versions for downloading at https://ghidra-sre.org.

If a Ghidra zip file (`ghidra_*.zip`) is already present in the current directory, the script will use that local archive instead of downloading the latest release.

# Supported platforms
* Ubuntu / Debian
* Fedora
* macOS (Homebrew)

# To install ghidra :
   ```
   ~$ git clone https://github.com/bkerler/ghidra_installer
   ~$ cd ghidra_installer
   ~/ghidra_installer$ ./install-ghidra.sh
   ```

# or doing it manually :
* Grab and install ghidra from https://ghidra-sre.org or https://github.com/NationalSecurityAgency/ghidra

* Install OpenJDK 21

* To run :

   ```
   ~$ ghidra
   ```
