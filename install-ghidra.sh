#!/bin/bash
INSTALL_DIR=/opt

echo "Downloading Ghidra and installing to $INSTALL_DIR"
export WGET=`which wget`
export SUDO=`which sudo 2> /dev/null`
test -e ./install-ghidra.sh || { echo Error: you must run the script from the ./install_ghidra/ directory ; exit 1 ; }
test -z "$WGET" && { echo Error: wget not found ; exit 1 ; }

#Checking to see if Java JDK is installed if not Install it first

function install_java {
  echo "Checking to see if Java is installed..."
  PKG_OK=$(dpkg-query -W --showformat='${Status}\n' openjdk-11-jdk | grep "install ok installed")

  if [ "" == "$PKG_OK" ]; then
    echo "Downloading JDK .. please wait..."
    sudo add-apt-repository ppa:openjdk-r/ppa -y > /dev/null 2>&1
    sudo apt update
    sudo apt install openjdk-17-jdk -y
  fi
}

function 4k_scaling {
  read -p "Shall I change scaling to factor 2 for 4K [Y/N]? " -n 1 -r
  echo    # (optional) move to a new line
  if [[ $REPLY =~ ^[Yy]$ ]]
  then
      sed -i 's/VMARGS_LINUX=-Dsun.java2d.uiScale=1/VMARGS_LINUX=-Dsun.java2d.uiScale=2/g' /opt/ghidra/support/launch.properties
  fi
}

install_java

#Link where to find Ghidra
export GHIDRALINK=`curl -s https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest | grep "browser_download_url.*zip" | cut -d : -f 2,3 | tr -d \" | tr -d " "`
test -z "$GHIDRALINK" && { echo Error: could not find ghidra to download ; exit 1 ; }

#Strip the link parts to just keep the zip file name
export GHIDRA=`echo $GHIDRALINK | sed 's/^.*\(ghidra.*\).*$/\1/' `

# This should result in the unpack directory in the ZIP
export GHIDRADIR=`echo $GHIDRA | sed 's/_20[12][0-9].*//' `

# This should be the Ghidra Version
export GHIDRAVER=`echo $GHIDRA | sed 's/_PUBLIC_.*//' | sed 's/_DEV_.*//' | sed 's/-BETA_.*//'`

echo " $GHIDRA" | sed 's/^.*\(ghidra.*\).*$/\1/' | egrep -q '/' && { echo Error: invalid ghidra filename ; exit 1 ; }
echo " $GHIDRA" | sed 's/^.*\(ghidra.*\).*$/\1/' | egrep -q '.zip' || { echo Error: invalid ghidra filename ; exit 1 ; }
test -d "$INSTALL_DIR" || { echo Error: install directory $INSTALL_DIR does not exist ; exit 1 ; }
echo "$GHIDRAVER"
test -e $INSTALL_DIR/$GHIDRAVER && { echo Error: $GHIDRAVER is already installed ; exit 1 ; }

echo "Downloading $GHIDRA with version $GHIDRAVER"
echo
wget -c "$GHIDRALINK" || exit 1

echo
echo Unpacking Ghidra ...
unzip "$GHIDRA" > /dev/null || exit 1
mv "$GHIDRADIR" "$GHIDRAVER"

cp -f ghidra $GHIDRAVER/
cp -f ghidra.png $GHIDRAVER/

$SUDO rm -rf $INSTALL_DIR/ghidra
$SUDO mv $GHIDRAVER $INSTALL_DIR/ || exit 1
rm $GHIDRA

for dir in Desktop Schreibtisch; do
  test -d $HOME/$dir && {
    cp ghidra.desktop $HOME/$dir/ghidra.desktop
    chown $USER:$USER $HOME/$dir/ghidra.desktop
  }
done

cp ghidra.desktop $HOME/.local/share/applications/ghidra.desktop
$SUDO rm -f /usr/bin/ghidra /usr/local/bin/ghidra 
$SUDO ln -s $INSTALL_DIR/ghidra/ghidraRun /usr/local/bin/ghidra


cd $INSTALL_DIR || exit 1
OLD_DIR=`readlink ghidra`
$SUDO ln -sf $GHIDRAVER ghidra

test -n "$OLD_DIR" && {
  echo Syncing from previous ghidra direcory: $OLD_DIR
  RSYNC=`command -v rsync 2> /dev/null`
  test -n "$RSYNC" && {
    echo Running $RSYNC to synchronize custom scripts to the new installation
    rsync -v -r --ignore-existing --exclude='*/jython*' "$DIR/Ghidra/" "$GHIDRAVER/Ghidra/"
  }
  test -z "$RSYNC" && {
    echo Warning: rsync not found, using old and incomplete copy process ...
    echo Copying customized scripts from $DIR to $GHIDRAVER
    for dir in $OLD_DIR/Ghidra/*/*/ghidra_scripts/; do
      cp -nrv "$DIR/$dir"/* "$GHIDRAVER/$dir/" 2> /dev/null
    done
  }
}

GHIDRACFG=`echo .$GHIDRAVER | tr _ -`
cd $HOME/.ghidra && {
  DIR=
  rm -rf $GHIDRACFG
  ls -td .ghidra-* | while read dir; do
    test '!' -L "$dir" -a -d "$dir" -a -z "$DIR" && {
      DIR=$dir
      ln -s $dir $GHIDRACFG
      echo Symlinking $HOME/.ghidra/$dir to $HOME/.ghidra/$GHIDRACFG
    }
  done
}

#Turning off 4K scaling
4k_scaling

echo
echo "Successfully installed Ghidra version $GHIDRAVER to $INSTALL_DIR/$GHIDRADIR"
echo "Run using: ghidra"
