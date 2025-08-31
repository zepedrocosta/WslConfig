#!/bin/bash

: '
	@Author: José Costa      - https://github.com/zepedrocosta
'

GREEN="\033[0;32m"
CYAN="\033[0;36m"
ORANGE="\033[0;33m"
NONE="\033[0m"

me=$USER

timer() {
    secs=4
    while [ $secs -gt 0 ]; do
        echo -ne "${CYAN}$1 ${ORANGE}$secs\033[O\r${NONE}" && sleep 1
        ((secs--))
    done
    echo -e "${CYAN}$1 ${ORANGE}0\033[0K\r${NONE}" && echo -e "${GREEN}$2${NONE}"
}

success() {
    echo -e "${GREEN}$1${NONE}"
}

timer "Installing the script now..."

mkdir -p ~/.script/
cp ./script.sh ~/.script/script.sh

success "Script copied successfully!"

chmod u+x ~/.script/script.sh

sed -i 's/\r$//' ~/.script/script.sh

success "Executable permissions assigned to script!"

echo >>~/.bashrc
echo "alias system='~/.script/script.sh'" >>~/.bashrc
source ~/.bashrc

success "Script successfully configured!"
