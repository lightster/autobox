#!/bin/bash

cp -rf /usr/share/easy-rsa/2.0/* /etc/openvpn/easy-rsa
cp /etc/openvpn/easy-rsa.vars /etc/openvpn/easy-rsa/vars

# the `pwd` is important as the easy-rsa scripts
# look for the vars directory in `pwd`
cd /etc/openvpn/easy-rsa

source ./vars >/dev/null

if [ ! -f keys/index.txt ]; then
    touch keys/index.txt
    echo 01 >keys/serial
fi

if [ ! -f keys/ca.crt ]; then
    ./pkitool --initca
fi

if [ ! -f keys/server.crt ]; then
    ./pkitool --server server
fi

if [ ! -f keys/dh2048.pem ]; then
    ./build-dh
fi
