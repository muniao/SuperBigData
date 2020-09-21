
set -e

VERSION="${1}"

if [ -z "${VERSION}" ]; then
    VERSION="1.6.9"
    echo "No CoreDNS version specified, use default version: ${VERSION}!"
fi

COREDNS_URL="https://github.com/coredns/coredns/releases/download/v${VERSION}/coredns_${VERSION}_linux_amd64.tgz"
COREDNS_CONF="https://raw.githubusercontent.com/mritd/config/master/coredns/Corefile"
SYSUSERS_CONF="https://raw.githubusercontent.com/coredns/deployment/master/systemd/coredns-sysusers.conf"
TEMPFILES_CONF="https://raw.githubusercontent.com/coredns/deployment/master/systemd/coredns-tmpfiles.conf"
SERVICE_CONF="https://raw.githubusercontent.com/coredns/deployment/master/systemd/coredns.service"

curl -sSL ${COREDNS_URL} > coredns.tar.gz
curl -sSL ${SYSUSERS_CONF} > /usr/lib/sysusers.d/coredns-sysusers.conf
curl -sSL ${TEMPFILES_CONF} > /usr/lib/tmpfiles.d/coredns-tmpfiles.conf
curl -sSL ${SERVICE_CONF} > /lib/systemd/system/coredns.service

#tar -zxf coredns.tar.gz --strip-components=1 -C /usr/bin
tar -zxf coredns.tar.gz -C /usr/bin
systemd-sysusers
systemd-tmpfiles --create
systemctl daemon-reload

if [ ! -d "/etc/coredns" ]; then
    mkdir -p /etc/coredns
fi

curl -sSL ${COREDNS_CONF} > /etc/coredns/Corefile
touch /etc/coredns/hosts

rm -f coredns.tar.gz
