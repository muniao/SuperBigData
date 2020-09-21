#!/bin/bash

set -e

CONSUL_VERSION="1.2.1"
CONSUL_DONWLOAD_URL="https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip"

preinstall(){
    if ! command -v unzip >/dev/null 2>&1; then 
        echo -e "\033[31mError: unzip not found!\033[0m"
        exit 1
    fi
    
    getent group consul >/dev/null || groupadd -r consul
    getent passwd consul >/dev/null || useradd -r -g consul -d /var/lib/consul -s /sbin/nologin -c "consul user" consul
    if [ ! -d /var/lib/consul ]; then 
        mkdir /var/lib/consul
        chown -R consul:consul /var/lib/consul
        chmod -R 0755 /var/lib/consul
    fi 
    if [ ! -d /etc/consul ]; then
        mkdir /etc/consul
    fi
}

postinstall(){
    # Initial installation
    systemctl --no-reload preset consul.service >/dev/null 2>&1 || :
    systemctl enable consul
    rm -f consul_${CONSUL_VERSION}_linux_amd64.zip
}

preuninstall(){
    # Package removal, not upgrade
    systemctl --no-reload disable --now consul.service > /dev/null 2>&1 || :
}

install(){
    wget ${CONSUL_DONWLOAD_URL}
	unzip consul_${CONSUL_VERSION}_linux_amd64.zip -d /usr/local/bin
    chmod +x /usr/local/bin/consul
    cat > /etc/consul/consul.json <<EOF
{
    "datacenter": "dc1",
    "data_dir": "/var/lib/consul",
    "disable_update_check": true,
    "log_level": "INFO",
    "node_name": "consul1",
    "server": true,
    "ui": true,
    "bootstrap_expect": 1,
    "bind_addr": "192.168.1.11",
    "client_addr": "192.168.1.11",
    "retry_join": ["192.168.1.12","192.168.1.13"],
    "retry_interval": "10s",
    "protocol": 3,
    "raft_protocol": 3,
    "enable_debug": false,
    "rejoin_after_leave": true,
    "enable_syslog": false
}
EOF
	cat >/lib/systemd/system/consul.service <<EOF
[Unit]
Description=Consul Server
After=network.target
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
WorkingDirectory=/var/lib/consul/
User=consul
# set GOMAXPROCS to number of processors
ExecStart=/bin/bash -c "GOMAXPROCS=$(nproc) /usr/local/bin/consul agent -config-file /etc/consul/consul.json"
Restart=on-failure
LimitNOFILE=65536

[Install]
WantedBy=multi-user.target
EOF
}

uninstall(){
    systemctl stop consul || true
    rm -rf consul_1.0.7_linux_amd64.zip \
        /usr/local/bin/consul \
        /etc/consul \
        /var/lib/consul \
        /lib/systemd/system/consul.service
    systemctl daemon-reload
    userdel consul
}

if [ "$1" == "install" ]; then
    preinstall
    install
    postinstall
elif [ "$1" == "uninstall" ]; then
    preuninstall
    uninstall
else
    echo -e "\033[31mError: command not support!\033[0m"
    exit 1
fi
