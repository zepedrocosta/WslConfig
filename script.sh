#!/bin/bash

: '
	@Author: Gonçalo Condeço - https://github.com/GoncaloAC

	Credits - As I wrote this file, some installers were taken from tutorials.

	MySQL - https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-mysql
	PostgresSQL - https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-postgresql
	SQLite - https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-sqlite
	Apache Cassandra - https://www.varunsrivatsa.dev/blog/cassandra-installation/how-to-install-cassandra-4-on-windows/
	MongoDB - https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-mongodb
	Redis - https://docs.microsoft.com/en-us/windows/wsl/tutorials/wsl-database#install-redis
	Neo4j - https://github.com/lqst/neo4j-wsl2

    https://www.vultr.com/docs/install-apache-cassandra-on-ubuntu-20-04/
    https://github.com/redhat-developer/vscode-java/issues/689
    https://gist.github.com/Nathan-Nesbitt/97e2c466cfdb74f4322c2678551eb93e
    https://stackoverflow.com/questions/36433835/getting-cassandra-to-use-an-alternate-java-install
'

RED="\033[0;31m"
YELLOW="\033[1;33m"
GREEN="\033[0;32m"
CYAN="\033[0;36m"
ORANGE="\033[0;33m"
NONE="\033[0m"

CONT="Continuing installation in"
INST="Installing now"
WARN="This needs further configuration. Check the tutorial README."
RUN=" is now running."
STOP=" is now stopped."
NOP=" is not installed."

me=$USER

update() {
    info "Updating Ubuntu..."
    sudo -i apt-get update > /dev/null 2>&1
    sudo apt-get upgrade -y > /dev/null 2>&1
    success "Ubuntu Updated Successfully!" & sleep 2
}

success() {
    echo -e "${GREEN}$1${NONE}"
}

error() {
    echo -e "${RED}$1${NONE}"
}

warn() {
    echo -e "${YELLOW}$1${NONE}"
}

info() {
    echo -e "${CYAN}$1${NONE}"
}

help() {
    echo "test"
}

timer() {
    secs=4
    while [ $secs -gt 0 ]; do
        echo -ne "${CYAN}$1 ${ORANGE}$secs\033[O\r${NONE}" && sleep 1
        ((secs--))
    done
    echo -e "${CYAN}$1 ${ORANGE}0\033[0K\r${NONE}" && echo -e "${GREEN}$2${NONE}"
}

missing() {
    dpkg -s $1 &> /dev/null
    if [ $? -eq 0 ]; then
        return 1
    else
        return 0
    fi
}

run() {
    if missing "$1"; then 
        error "$2$3"
    else
        $5 > /dev/null 2>&1 && info "$2$4"
    fi
}

case $1 in
    install)
        update
        if missing "dialog"; then
            info "Installing Dialog" && sudo -i apt install dialog > /dev/null 2>&1
        fi
        cmd=(dialog --separate-output --checklist "Please Select Software you want to install:" 22 76 16)
        options=(
            1 "Java 17" off
            2 "Java 17 Sources" off
            3 "Maven" off
            4 "Node Version Manager (nvm)" off
            5 "Gcc" off
            6 "Makefile" off
            7 "uv (multiple versions of python)" off
            8 "Mysql" off
            9 "PostgresSQL" off
            10 "SQLite" off
            11 "Apache Cassandra" off
            12 "MongoDB" off
            13 "Redis" off
            14 "Neo4j" off
            15 "TeX Live" off
        )
        choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        clear
        for choice in $choices
        do
            case "${choice}" in
                1)
                    update && timer "$CONT" "$INST Java 17"
                    sudo apt-get install openjdk-17-jdk -y
                    echo >> ~/.bashrc
                    echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
                    success "Java 17 installed successfully!"
			        ;;
                2)
                    update && timer "$CONT" "$INST Java 17 sources"
                    sudo apt-get install openjdk-17-source -y
                    success "Java 17 sources installed successfully!"
                    ;;
                3)
                    update && timer "$CONT" "$INST Maven"
                    sudo apt install maven
                    success "Maven installed successfully!"
                    ;;
                4)
                    update && timer "$CONT" "$INST Node Version Manager (nvm)"
                    sudo apt-get install curl
                    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
                    warn "$WARN" && success "NVM installed successfully!"
                    ;;
                5) 
                    update && timer "$CONT" "$INST Gcc"
                    sudo apt install gcc -y
                    success "Gcc installed successfully!"
                    ;;
                6)
                    update && timer "$CONT" "$INST Make"
                    sudo apt install make
                    success "Make installed successfully!"
                    ;;
                7)
                    # uv (https://github.com/astral-sh/uv) 
                    update && timer "$CONT" "$INST uv"
                    success "uv installed successfully!"
                    ;;
                8)
                    update && timer "$CONT" "$INST MySQL"
                    sudo apt install mysql-server -y
                    warn "$WARN" && success "MySQL installed successfully!"
                    ;;
		        9)
                    update && timer "$CONT" "$INST PostgresSQL"
                    sudo apt install postgresql postgresql-contrib -y
                    warn "$WARN" && success "PostgresSQL installed successfully!"
                    ;;
                10)
                    update && timer "$CONT" "$INST SQLite"
                    sudo apt install sqlite3
                    success "SQLite installed successfully!"
                    ;;
		        11)
                    update && timer "$CONT" "$INST Apache Cassandra"
                    sudo apt install openjdk-8-jre
                    sudo apt install apt-transport-https gnupg2 -y
                    sudo wget -q -O - https://www.apache.org/dist/cassandra/KEYS | sudo apt-key add -
                    sudo sh -c 'echo "deb http://www.apache.org/dist/cassandra/debian 311x main" > /etc/apt/sources.list.d/cassandra.list'
                    sudo apt update
                    sudo apt install cassandra -y
                    echo 'JAVA_HOME=usr/lib/jvm/java-8-openjdk-amd64' >> ~/usr/share/cassandra/cassandra.in.sh
                    success "Apache Cassandra installed successfully!"
                    ;;
                12)
                    update && timer "$CONT" "$INST MongoDB"
                    wget -qO - https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
                    echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
                    sudo apt-get update && sudo apt-get install mongodb-org -y && mkdir -p ~/data/db
                    curl https://raw.githubusercontent.com/mongodb/mongo/master/debian/init.d | sudo tee /etc/init.d/mongodb >/dev/null
                    sudo chmod +x /etc/init.d/mongodb
                    success "MongoDB installed successfully!"
                    ;;
                13) 
                    update && timer "$CONT" "$INST Redis"
                    sudo apt install redis-server -y
                    success "Redis installed successfully!"
                    ;;
		        14)
                    update && timer "$CONT" "$INST Neo4j"
                    wget -O - https://debian.neo4j.com/neotechnology.gpg.key | sudo apt-key add -
                    echo 'deb https://debian.neo4j.com stable latest' | sudo tee -a /etc/apt/sources.list.d/neo4j.list
                    sudo apt-get update
                    sudo apt-get install neo4j-enterprise -y
                    success "Neo4j installed successfully!"
                    ;;
                # TeX Live
                15)
                    update && timer "$CONT" "$INST TeX Live"
                    sudo apt install texlive
                    success "TeX Live installed successfully!"
                    info "Run 'system latex-deps' to install LaTeX dependencies"
                    ;;
            esac
        done
        success "Installation finished successfully!"
        ;;
    config) 
        update
        if missing "dialog"; then 
            info "Installing Dialog" && sudo -i apt install dialog > /dev/null 2>&1
        fi
        cmd=(dialog --separate-output --checklist "Please Select Software you want to configure:" 22 76 16)
        options=(
            1 "Install latest stable npm with nvm" off
            2 "Configure MySQL for WSL" off
            3 "Configure PostgresSQL for WSL" off
        )
        choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        for choice in $choices
        do
            case "${choice}" in
                1)
                    clear && timer "$CONT" "$INST NPM"
                    source ~/.nvm/nvm.sh && nvm install --lts
                    success "NPM configured successfully!"
                    ;;
                2)
                    clear && timer "$CONT" "$INST MySQL"
                    sudo /etc/init.d/mysql start
                    sudo mysql_secure_installation && sudo mysql
                    success "MySQL configured successfully!"
                    ;;
                3)
                    clear && timer "$CONT" "$INST PostgresSQL"
                    sudo passwd postgres
                    success "PostgresSQL configured successfully!"
                    ;;
            esac
        done
        success "Configuration finished successfully!"
        ;;
    start)
        run "mysql-server" "MySQL" "${NOP}" "${RUN}" "sudo /etc/init.d/mysql start"
        run "postgresql" "PostgresSQL" "${NOP}" "${RUN}" "sudo service postgresql start"
        run "mongodb-org" "MongoDB" "${NOP}" "${RUN}" "sudo service mongodb start"
        run "cassandra" "Apache Cassandra" "${NOP}" "${RUN}" "sudo service cassandra start"
        run "redis-server" "Redis" "${NOP}" "${RUN}" "sudo service redis-server start"
        run "neo4j-enterprise" "Neo4j" "${NOP}" "${RUN}" "sudo service neo4j start"
        ;;
    stop)
        run "mysql-server" "MySQL" "${NOP}" "${STOP}" "sudo /etc/init.d/mysql stop"
        run "postgresql" "PostgresSQL" "${NOP}" "${STOP}" "sudo service postgresql stop"
        run "mongodb-org" "MongoDB" "${NOP}" "${STOP}" "sudo service mongodb stop"
        run "cassandra" "Apache Cassandra" "${NOP}" "${STOP}" "sudo service cassandra stop"
        run "redis-server" "Redis" "${NOP}" "${STOP}" "sudo service redis-server stop"
        run "neo4j-enterprise" "Neo4j" "${NOP}" "${STOP}" "sudo service neo4j stop"
        ;;
    react-deps)
        npm i react-router
        npm i react-router-dom
        npm i react-redux
        npm i @types/react-redux
        npm i @reduxjs/toolkit
        npm i axios
        npm i react-icons --save
        npm i recharts
        ;;
    # https://tex.stackexchange.com/questions/245982/differences-between-texlive-packages-in-linux
    latex-deps)
        update
        if missing "dialog"; then 
            info "Installing Dialog" && sudo -i apt install dialog > /dev/null 2>&1
        fi
        cmd=(dialog --radiolist "Please select which LaTeX package you want to install" 22 76 16)
        options=(
            1 "Base version (~216MB)" OFF
            2 "Extra version (~452MB)" OFF
            3 "Full version (~5358MB)" OFF
        )
        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        case "$choice" in
            1)
                clear && timer "$CONT" "$INST Base version"
                sudo apt-get install texlive-base
                ;;
            2)
                clear && timer "$CONT" "$INST Extra version"
                sudo apt-get install texlive-latex-extra
                ;;
            3)
                clear && timer "$CONT" "$INST Full version"
                sudo apt-get install texlive-full
                ;;
        esac
        success "LaTeX dependencies installed successfully!"
        ;;
    *)
        echo "error"
esac
