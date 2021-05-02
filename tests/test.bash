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

registerTestUsers() {
    local containerName="$1"
    sudo docker exec "$containerName" /bin/bash -c "/entrypoint.bash register admin localhost 12345678" \
    && sudo docker exec "$containerName" /bin/bash -c "/entrypoint.bash register user1 localhost 12345678" \
    && sudo docker exec "$containerName" /bin/bash -c "/entrypoint.bash register user2 localhost 12345678" \
    && sudo docker exec "$containerName" /bin/bash -c "/entrypoint.bash register user3 localhost 12345678"
}

runTests() {
    local containerName="$1"
    python --version \
    && python3 --version \
    && python3 -m venv venv \
    && source venv/bin/activate \
    && python --version \
    && pip --version \
    && pip install -r requirements.txt \
    && pytest \
    && deactivate \
    && sleep 5 \
    && sudo docker-compose logs "$containerName" \
    && ./bats/bats-core/bin/bats tests.bats
}

generateCert "localhost"
generateCert "conference.localhost"
generateCert "proxy.localhost"
generateCert "pubsub.localhost"
generateCert "upload.localhost"

# Start postgres first and wait for 10 seconds before starting prosody.
sudo docker-compose down \
&& sudo docker-compose up -d postgres \
&& sleep 10 \
&& sudo docker-compose up -d prosody_postgres

registerTestUsers tests_prosody_postgres_1
runTests prosody_postgres

sudo docker-compose down
