#!/bin/bash

set -u

# Detect OS / distribution
OS="$(uname -s)"
DISTRO="unknown"
if [ "$OS" = "Linux" ] && [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO="$ID"
elif [ "$OS" = "Darwin" ]; then
    DISTRO="macos"
fi

# Install prefix
if [ "$OS" = "Darwin" ]; then
    INSTALL_DIR=/Applications
else
    INSTALL_DIR=/opt
fi

# sudo handling (allow running as root without sudo)
if [ "$(id -u)" -eq 0 ]; then
    SUDO=""
elif command -v sudo >/dev/null 2>&1; then
    SUDO="sudo"
else
    echo "Error: sudo is required but not installed."
    exit 1
fi

echo "Detected OS: $OS ($DISTRO)"
echo "Installing Ghidra to $INSTALL_DIR"

test -e ./install-ghidra.sh || { echo "Error: you must run the script from the ghidra_installer directory"; exit 1; }

function install_tools {
    case "$DISTRO" in
        ubuntu|debian)
            $SUDO apt update
            $SUDO apt install -y curl unzip
            ;;
        fedora)
            $SUDO dnf install -y curl unzip
            ;;
        macos)
            if ! command -v brew >/dev/null 2>&1; then
                echo "Error: Homebrew not found. Please install Homebrew first: https://brew.sh"
                exit 1
            fi
            if ! command -v unzip >/dev/null 2>&1; then
                brew install unzip
            fi
            ;;
        *)
            echo "Error: Unsupported distribution: $DISTRO"
            exit 1
            ;;
    esac
}

# Make sure curl and unzip are available
command -v curl >/dev/null 2>&1 || command -v unzip >/dev/null 2>&1 || install_tools
command -v curl >/dev/null 2>&1 || { echo "Error: curl not found"; exit 1; }
command -v unzip >/dev/null 2>&1 || { echo "Error: unzip not found"; exit 1; }

function install_java {
    echo "Checking to see if Java is installed..."
    if command -v java >/dev/null 2>&1; then
        echo "Java found: $(java -version 2>&1 | head -n 1)"
        return
    fi

    echo "Installing JDK ... please wait..."
    case "$DISTRO" in
        ubuntu|debian)
            $SUDO add-apt-repository ppa:openjdk-r/ppa -y >/dev/null 2>&1
            $SUDO apt update
            $SUDO apt install -y openjdk-21-jdk
            ;;
        fedora)
            $SUDO dnf install -y java-21-openjdk-devel
            ;;
        macos)
            if ! command -v brew >/dev/null 2>&1; then
                echo "Error: Homebrew not found. Please install Homebrew first: https://brew.sh"
                exit 1
            fi
            brew install openjdk@21
            BREW_PREFIX=$(brew --prefix)
            JDK_PATH="$BREW_PREFIX/opt/openjdk@21/libexec/openjdk.jdk"
            if [ -d "$JDK_PATH" ]; then
                $SUDO mkdir -p /Library/Java/JavaVirtualMachines
                $SUDO ln -sfn "$JDK_PATH" /Library/Java/JavaVirtualMachines/openjdk-21.jdk
            fi
            ;;
        *)
            echo "Error: Unsupported distribution: $DISTRO"
            exit 1
            ;;
    esac
}

function derive_names {
    local filename="$1"
    GHIDRADIR=$(echo "$filename" | sed 's/\.zip$//' | sed 's/_20[12][0-9].*//')
    GHIDRAVER=$(echo "$filename" | sed 's/\.zip$//' | sed 's/_PUBLIC_.*//' | sed 's/_DEV_.*//' | sed 's/-BETA_.*//')
}

install_java

# Look for an existing Ghidra zip in the current directory
EXISTING_ZIP=$(find . -maxdepth 1 -name 'ghidra_*.zip' -print -quit 2>/dev/null)
if [ -n "$EXISTING_ZIP" ]; then
    GHIDRA=$(basename "$EXISTING_ZIP")
    echo "Found existing Ghidra zip in current directory: $GHIDRA"
    derive_names "$GHIDRA"
else
    # Link where to find Ghidra
    GHIDRALINK=$(curl -s https://api.github.com/repos/NationalSecurityAgency/ghidra/releases/latest | grep "browser_download_url.*zip" | cut -d : -f 2,3 | tr -d '"' | tr -d " " | head -n 1)
    test -z "$GHIDRALINK" && { echo "Error: could not find ghidra to download"; exit 1; }

    # Strip the link parts to just keep the zip file name
    GHIDRA=$(basename "$GHIDRALINK")
    derive_names "$GHIDRA"
fi

# Validate the resulting filename
echo " $GHIDRA" | sed 's/^.*\(ghidra.*\).*$/\1/' | grep -qE '/' && { echo "Error: invalid ghidra filename"; exit 1; }
echo " $GHIDRA" | sed 's/^.*\(ghidra.*\).*$/\1/' | grep -qE '\.zip' || { echo "Error: invalid ghidra filename"; exit 1; }

echo "$GHIDRAVER"

# Ensure install directory exists
test -d "$INSTALL_DIR" || $SUDO mkdir -p "$INSTALL_DIR" || { echo "Error: install directory $INSTALL_DIR does not exist and could not be created"; exit 1; }

test -e "$INSTALL_DIR/$GHIDRAVER" && { echo "Error: $GHIDRAVER is already installed"; exit 1; }

if [ -n "$EXISTING_ZIP" ]; then
    echo "Using local $GHIDRA (version $GHIDRAVER)"
else
    echo "Downloading $GHIDRA (version $GHIDRAVER)"
    echo
    curl -L -o "$GHIDRA" "$GHIDRALINK" || exit 1
fi

echo
echo "Unpacking Ghidra ..."
unzip -q "$GHIDRA" || exit 1
mv "$GHIDRADIR" "$GHIDRAVER"

cp -f ghidra "$GHIDRAVER/"
cp -f ghidra.png "$GHIDRAVER/"

$SUDO rm -rf "$INSTALL_DIR/ghidra"
$SUDO mv "$GHIDRAVER" "$INSTALL_DIR/" || exit 1

# Only remove the zip if we downloaded it; leave a user-provided zip in place
if [ -z "$EXISTING_ZIP" ]; then
    rm -f "$GHIDRA"
fi

# Linux desktop integration
if [ "$OS" = "Linux" ]; then
    for dir in Desktop Schreibtisch; do
        test -d "$HOME/$dir" && {
            cp ghidra.desktop "$HOME/$dir/ghidra.desktop"
            chown "$USER:$USER" "$HOME/$dir/ghidra.desktop"
        }
    done
    mkdir -p "$HOME/.local/share/applications"
    cp ghidra.desktop "$HOME/.local/share/applications/ghidra.desktop"
fi

$SUDO rm -f /usr/bin/ghidra /usr/local/bin/ghidra
$SUDO mkdir -p /usr/local/bin
$SUDO ln -s "$INSTALL_DIR/ghidra/ghidraRun" /usr/local/bin/ghidra

cd "$INSTALL_DIR" || exit 1
OLD_DIR=$(readlink ghidra)
$SUDO ln -sf "$GHIDRAVER" ghidra

test -n "$OLD_DIR" && {
    echo "Syncing from previous ghidra directory: $OLD_DIR"
    RSYNC=$(command -v rsync 2>/dev/null)
    test -n "$RSYNC" && {
        echo "Running $RSYNC to synchronize custom scripts to the new installation"
        rsync -v -r --ignore-existing --exclude='*/jython*' "$OLD_DIR/Ghidra/" "$GHIDRAVER/Ghidra/"
    }
    test -z "$RSYNC" && {
        echo "Warning: rsync not found, using old and incomplete copy process ..."
        echo "Copying customized scripts from $OLD_DIR to $GHIDRAVER"
        for dir in "$OLD_DIR"/Ghidra/*/*/ghidra_scripts/; do
            cp -nrv "$dir"/* "$GHIDRAVER/$dir/" 2>/dev/null
        done
    }
}

GHIDRACFG=$(echo ".$GHIDRAVER" | tr _ -)
if [ -d "$HOME/.ghidra" ]; then
    cd "$HOME/.ghidra" || exit 1
    DIR=
    rm -rf "$GHIDRACFG"
    ls -td .ghidra-* 2>/dev/null | while read dir; do
        test '!' -L "$dir" -a -d "$dir" -a -z "$DIR" && {
            DIR=$dir
            ln -s "$dir" "$GHIDRACFG"
            echo "Symlinking $HOME/.ghidra/$dir to $HOME/.ghidra/$GHIDRACFG"
        }
    done
fi

function update_bashrc {
    local bashrc="$HOME/.bashrc"
    local install_path="$INSTALL_DIR/ghidra"
    local line="export GHIDRA_INSTALL_DIR=\"$install_path\""

    if [ -f "$bashrc" ]; then
        if grep -q "GHIDRA_INSTALL_DIR=" "$bashrc"; then
            sed -i.bak "s|export GHIDRA_INSTALL_DIR=.*|$line|" "$bashrc"
            rm -f "$bashrc.bak"
        else
            echo "$line" >> "$bashrc"
        fi
    else
        echo "$line" > "$bashrc"
    fi
    echo "Updated $bashrc: GHIDRA_INSTALL_DIR=$install_path"
}

update_bashrc

# 4K scaling (Linux only)
function 4k_scaling {
    if [ "$OS" != "Linux" ]; then
        return
    fi
    read -p "Shall I change scaling to factor 2 for 4K [Y/N]? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        $SUDO sed -i 's/VMARGS_LINUX=-Dsun.java2d.uiScale=1/VMARGS_LINUX=-Dsun.java2d.uiScale=2/g' "$INSTALL_DIR/ghidra/support/launch.properties"
    fi
}

4k_scaling

echo
echo "Successfully installed Ghidra version $GHIDRAVER to $INSTALL_DIR/$GHIDRADIR"
echo "Run using: ghidra"
echo "Environment variable GHIDRA_INSTALL_DIR has been set in ~/.bashrc"
