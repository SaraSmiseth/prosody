#!/bin/bash

set -e

# generate certs for testing

generateCert() {
    DOMAIN="$1"
    if [[ ! -d certs/"$DOMAIN" ]] ; then
        mkdir -p certs/"$DOMAIN"
        cd certs/"$DOMAIN"
        openssl req -x509 -newkey rsa:4096 -keyout privkey.pem -out fullchain.pem -days 365 -subj "/CN=$DOMAIN" -nodes
        chmod 777 *.pem
        cd ../../
    fi
}

generateCert "localhost"
generateCert "conference.localhost"
generateCert "proxy.localhost"
generateCert "pubsub.localhost"
generateCert "upload.localhost"

sudo docker-compose down \
&& sudo docker-compose up -d \
\
&& sudo docker exec tests_prosody_1 /bin/bash -c "/entrypoint.sh register admin localhost 12345678" \
&& sudo docker exec tests_prosody_1 /bin/bash -c "/entrypoint.sh register user1 localhost 12345678" \
&& sudo docker exec tests_prosody_1 /bin/bash -c "/entrypoint.sh register user2 localhost 12345678" \
&& sudo docker exec tests_prosody_1 /bin/bash -c "/entrypoint.sh register user3 localhost 12345678" \
\
&& python --version \
&& python3 --version \
&& python3 -m venv venv \
&& source venv/bin/activate \
&& python --version \
&& pip --version \
&& pip install -r requirements.txt \
&& pytest \
&& deactivate \
&& sleep 5 \
&& sudo docker-compose logs \
&& ./bats/bats-core/bin/bats tests.bats

sudo docker-compose down
