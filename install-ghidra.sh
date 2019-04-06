#!/bin/sh
echo "Downloading ghidra and installing to /opt"
WGET=`which wget`
test -z "$WGET" && { echo Error: wget not found ; exit 1 ; }
export GHIDRA=`$WGET -O - --quiet https://www.ghidra-sre.org | grep 'Download Ghidra' | sed 's/.*href=.//' | sed 's/".*//'`
test -z "$GHIDRA" && { echo Error: could not find ghidra to download ; exit 1 ; }
export GHIDRAVER=`echo $GHIDRA | sed 's/_PUBLIC_.*//'`
echo " $GHIDRA" | egrep -q '/' && { echo Error: invalid ghidra filename ; exit 1 ; }
echo " $GHIDRA" | egrep -q '_PUBLIC_' || { echo Error: invalid ghidra filename ; exit 1 ; }
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
sudo rm -rf /opt/ghidra
sudo rm -rf /opt/$GHIDRAVER
sudo mv $GHIDRAVER /opt/ || exit 1
rm $GHIDRA

for dir in Desktop Schreibtisch; do
  test -d ~/$dir && {
    cp ghidra.desktop ~/$dir/ghidra.desktop
    cp ghidra4K.desktop ~/$dir/ghidra4K.desktop
  }
done
rm -f /usr/bin/ghidra /usr/bin/ghidra4K /usr/local/bin/ghidra /usr/local/bin/ghidra4K
sudo ln -s /opt/ghidra/ghidraRun /usr/local/bin/ghidra
sudo ln -s /opt/ghidra/ghidra4K /usr/local/bin/ghidra4K

cd /opt || exit 1
sudo ln -s $GHIDRAVER ghidra
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

GHIDRACFG=`echo $GHIDRAVER | tr _ -`
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
echo "Successfully installed Ghidra to /opt/$GHIDRAVER"
echo "Run using: ghidra or ghidra4K"
echo "Edit /opt/ghidra/ghidra4K for other scaling factors than 1.4."
