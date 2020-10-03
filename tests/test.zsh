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

generateCert "localhost"
generateCert "conference.localhost"
generateCert "pubsub.localhost"
generateCert "proxy.localhost"
generateCert "upload.localhost"

sudo docker-compose up -d

sudo docker exec tests_prosody_1 /bin/bash -c "/entrypoint.sh register admin localhost 12345678"

python test.py

sudo docker-compose down
