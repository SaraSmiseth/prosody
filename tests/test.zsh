#!/bin/zsh

# generate certs for testing

generateCert() {
    DOMAIN="$1"
    mkdir -p certs/"$DOMAIN"
    cd certs/"$DOMAIN"
    openssl req -x509 -newkey rsa:4096 -keyout privkey.pem -out fullchain.pem -days 365 -subj "/CN=$DOMAIN" -nodes
    chmod 777 *.pem
    cd ../../
}

generateCert "prosody"
generateCert "conference.prosody"
generateCert "pubsub.prosody"
generateCert "proxy.prosody"
generateCert "upload.prosody"
