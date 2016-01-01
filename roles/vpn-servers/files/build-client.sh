#!/bin/bash

if [ -z ${2:+x} ]; then
    echo "Usage: $0 vpn-server client-name"
    exit 1
fi

VPN_HOST="$1"
CLIENT_NAME="$2"

# the `pwd` is important as the easy-rsa scripts
# look for the vars directory in `pwd`
cd /etc/openvpn/easy-rsa
source ./vars

if [ ! -f "keys/${CLIENT_NAME}.key" ]; then
    ./pkitool "${CLIENT_NAME}"
fi

cd keys
mkdir "${CLIENT_NAME}.tblk"
cp "${CLIENT_NAME}".{crt,key} ca.crt "${CLIENT_NAME}.tblk"
cat <<TXT >"${CLIENT_NAME}.tblk/config.ovpn"
client
dev tun
proto tcp
remote ${VPN_HOST} 1194
resolv-retry infinite
nobind
persist-key
persist-tun
comp-lzo
verb 3
ca ca.crt
cert ${CLIENT_NAME}.crt
key ${CLIENT_NAME}.key
TXT
tar czf "/root/${CLIENT_NAME}.tblk.tar.gz" "${CLIENT_NAME}.tblk"
rm -rf "${CLIENT_NAME}.tblk"
