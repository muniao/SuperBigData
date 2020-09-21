#!/bin/bash

set -e

TZ='Asia/Shanghai'
OS_RELEASE="$(lsb_release -cs)"
SOURCES_LIST_URL='https://git.io/fhQ6B'
DOCKER_LIST_URL='https://git.io/fhQ68'
OZ_DOWNLOAD_URL='https://github.com/robbyrussell/oh-my-zsh.git'
OZ_CONFIG_DOWNLOAD_URL='https://git.io/fh9U2'
OZ_SYNTAX_HIGHLIGHTING_DOWNLOAD_URL='https://github.com/zsh-users/zsh-syntax-highlighting.git'
VIM_CONFIG_DOWNLOAD_URL='https://git.io/fh9rI'
VIM_PLUGINS_DOWNLOAD_URL='https://git.io/fh9r3'
DOCKER_CONFIG_DOWNLOAD_URL='https://git.io/fh9Ui'
CTOP_DOWNLOAD_URL='https://github.com/bcicen/ctop/releases/download/v0.7.2/ctop-0.7.2-linux-amd64'
DOCKER_COMPOSE_DOWNLOAD_URL="https://github.com/docker/compose/releases/download/1.23.2/docker-compose-Linux-x86_64"
HEY_DOWNLOAD_URL="https://storage.googleapis.com/hey-release/hey_linux_amd64"
BAT_DOWNLOAD_URL="https://github.com/sharkdp/bat/releases/download/v0.12.1/bat-v0.12.1-x86_64-unknown-linux-gnu.tar.gz"
PERF_TOOLS_DOWNLOAD_URL="https://github.com/brendangregg/perf-tools"
TERMSHARK_DOWNLOAD_URL="https://github.com/gcla/termshark/releases/download/v2.1.1/termshark_2.1.1_linux_x64.tar.gz"

function setlocale(){
    if [ ! -f /etc/locale.gen.bak ]; then
        cp /etc/locale.gen /etc/locale.gen.bak
        echo 'en_US.UTF-8 UTF-8' > /etc/locale.gen
        echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen
    fi
    locale-gen --purge
    localectl set-locale LANG=en_US.UTF-8
}

function sysupdate(){
    if [ ! -f /etc/apt/sources.list.bak ]; then
        cp /etc/apt/sources.list /etc/apt/sources.list.old
        curl -fsSL ${SOURCES_LIST_URL} | sed "s@{{OS_RELEASE}}@${OS_RELEASE}@gi" > /etc/apt/sources.list
    fi
    apt update -y
    apt upgrade -y
    apt install -y apt-transport-https ca-certificates software-properties-common \
        wget vim zsh git htop tzdata conntrack ipvsadm ipset stress sysstat axel
    apt autoremove -y
    apt autoclean -y
}

function settimezone(){
    timedatectl set-timezone ${TZ}
}

function install_ohmyzsh(){
    if [ ! -d ~/.oh-my-zsh ]; then
        git clone --depth=1 ${OZ_DOWNLOAD_URL} ~/.oh-my-zsh
        git clone ${OZ_SYNTAX_HIGHLIGHTING_DOWNLOAD_URL} ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
        curl -fsSL ${OZ_CONFIG_DOWNLOAD_URL} > ~/.zshrc
        chsh -s $(grep /zsh$ /etc/shells | tail -1)
    fi
}

function config_vim(){
    curl -fsSL ${VIM_CONFIG_DOWNLOAD_URL} > ~/.vimrc
    mkdir -p ~/.vim/pack/plugins/{start,opt}
    cd ~/.vim/pack/plugins/start
    for addr in `curl -fsSL ${VIM_PLUGINS_DOWNLOAD_URL}`; do
        git clone ${addr}
    done
}

function install_docker(){
    if [ "${OS_RELEASE}" == "focal" ]; then
        apt install docker.io -y
        apt-mark hold docker.io
    else
        curl -fsSL ${DOCKER_LIST_URL} | sed "s@{{OS_RELEASE}}@${OS_RELEASE}@gi" > /etc/apt/sources.list.d/docker.list
        curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | apt-key add -
        apt update -y
        apt install docker-ce -y
        apt-mark hold docker-ce
    fi
    
    curl -fsSL ${DOCKER_CONFIG_DOWNLOAD_URL} > docker.service
    SYSTEMD_EDITOR="mv docker.service" systemctl edit docker
    systemctl daemon-reload && systemctl restart docker
}

function install_ctop(){
    curl -fsSL ${CTOP_DOWNLOAD_URL} > /usr/local/bin/ctop
    chmod +x /usr/local/bin/ctop
}

function install_dc(){
    curl -fsSL ${DOCKER_COMPOSE_DOWNLOAD_URL} > /usr/local/bin/docker-compose
    chmod +x /usr/local/bin/docker-compose
}

function install_hey(){
    curl -fsSL ${HEY_DOWNLOAD_URL} > /usr/local/bin/hey
    chmod +x /usr/local/bin/hey
}

function install_bat(){
    curl -fsSL ${BAT_DOWNLOAD_URL} > bat.tar.gz
    tar -zxf bat.tar.gz
    mv bat-*/bat /usr/local/bin/bat
    rm -rf bat*
}

function install_pert-tools(){
    git clone --depth 1 ${PERF_TOOLS_DOWNLOAD_URL} /usr/local/perf-tools
}

function install_termshark(){
    curl -fsSL ${TERMSHARK_DOWNLOAD_URL} > termshark.tar.gz
    tar -zxf termshark.tar.gz
    mv termshark*/termshark /usr/local/bin/termshark
    rm -rf termshark*
    apt install tshark -y
}

function install_osquery(){
    OSQUERY_KEY=1484120AC4E9F8A1A577AEEE97A80C63C9D8B80B
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ${OSQUERY_KEY}
    add-apt-repository 'deb [arch=amd64] https://pkg.osquery.io/deb deb main' -y
    apt-get update -y
    apt-get install osquery -y
}

setlocale
sysupdate
settimezone
config_vim
install_ohmyzsh
install_docker
install_dc
#install_ctop
#install_hey
#install_bat
#install_termshark
#install_osquery
