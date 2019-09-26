#!/bin/sh
INSTALL_DIR=/opt

echo "Downloading ghidra and installing to $INSTALL_DIR"
export WGET=`which wget`
export SUDO=`which sudo 2> /dev/null`
test -e ./install-ghidra.sh || { echo Error: you must run the script from the ./install_ghidra/ directory ; exit 1 ; }
test -z "$WGET" && { echo Error: wget not found ; exit 1 ; }

export GHIDRA=`$WGET -O - --quiet https://www.ghidra-sre.org | grep 'Download Ghidra' | sed 's/.*href=.//' | sed 's/".*//'`
test -z "$GHIDRA" && { echo Error: could not find ghidra to download ; exit 1 ; }
export GHIDRAVER=`echo $GHIDRA | sed 's/_PUBLIC_.*//'`
echo " $GHIDRA" | egrep -q '/' && { echo Error: invalid ghidra filename ; exit 1 ; }
echo " $GHIDRA" | egrep -q '.zip' || { echo Error: invalid ghidra filename ; exit 1 ; }
test -d "$INSTALL_DIR" || { echo Error: install directory $INSTALL_DIR does not exist ; exit 1 ; }
test -e $INSTALL_DIR/$GHIDRAVER && { echo Error: $GHIDRAVER is already installed ; exit 1 ; }

echo Downloading $GHIDRA with version $GHIDRAVER
echo
wget -c https://ghidra-sre.org/$GHIDRA || exit 1
echo
echo Unpacking Ghidra ...
unzip $GHIDRA > /dev/null || exit 1

./install-jdk.sh
./install-scaling.sh

cp -f ghidra $GHIDRAVER/
cp -f ghidra4K $GHIDRAVER/
cp -f run_scaled $GHIDRAVER/
$SUDO rm -rf $INSTALL_DIR/ghidra
$SUDO mv $GHIDRAVER $INSTALL_DIR/ || exit 1
rm $GHIDRA

for dir in Desktop Schreibtisch; do
  test -d ~/$dir && {
    cp ghidra.desktop ~/$dir/ghidra.desktop
    cp ghidra4K.desktop ~/$dir/ghidra4K.desktop
  }
done
rm -f /usr/bin/ghidra /usr/bin/ghidra4K /usr/local/bin/ghidra /usr/local/bin/ghidra4K
$SUDO ln -s $INSTALL_DIR/ghidra/ghidraRun /usr/local/bin/ghidra
$SUDO ln -s $INSTALL_DIR/ghidra/ghidra4K /usr/local/bin/ghidra4K

cd $INSTALL_DIR || exit 1
$SUDO ln -s $GHIDRAVER ghidra
DIR=
ls -td ghidra_*.* | while read dir; do
  test '!' -L "$dir" -a -d "$dir" -a -z "$DIR" -a '!' "$dir" = "$GHIDRAVER" && {
     DIR=$dir
     echo Copying customized scripts from $DIR to $GHIDRAVER
     for dir in Ghidra/*/*/ghidra_scripts/; do
       cp -nrv "$DIR/$dir"/* "$GHIDRAVER/$dir/" 2> /dev/null
     done
  }
done

GHIDRACFG=`echo .$GHIDRAVER | tr _ -`
cd ~/.ghidra && {
  DIR=
  rm -rf $GHIDRACFG
  ls -td .ghidra-* | while read dir; do
    test '!' -L "$dir" -a -d "$dir" -a -z "$DIR" && {
      DIR=$dir
      ln -s $dir $GHIDRACFG
      echo Symlinking ~/.ghidra/$dir to ~/.ghidra/$GHIDRACFG
    }
  done
}

echo
echo "Successfully installed Ghidra to $INSTALL_DIR/$GHIDRAVER"
echo "Run using: ghidra or ghidra4K"
echo "Edit $INSTALL_DIR/ghidra/ghidra4K for other scaling factors than 1.4."
