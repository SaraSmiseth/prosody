#!/bin/bash

set -e

# generate certs for testing

generateCert() {
    local DOMAIN="$1"
    if [[ ! -d certs/"$DOMAIN" ]] ; then
        mkdir -p certs/"$DOMAIN"
        cd certs/"$DOMAIN"
        openssl req -x509 -newkey rsa:4096 -keyout privkey.pem -out fullchain.pem -days 365 -subj "/CN=$DOMAIN" -nodes
        chmod 777 *.pem
        cd ../../
    fi
}

registerTestUser() {
    local userName="$1"
    local containerName="$2"
    echo "Registering TestUser '$userName' in container '$containerName'"
    sudo docker compose exec "$containerName" /bin/bash -c "/entrypoint.bash register $userName example.com 12345678"
}

registerTestUsers() {
    local containerName="$1"
    registerTestUser admin "$containerName"
    registerTestUser user1 "$containerName"
    registerTestUser user2 "$containerName"
    registerTestUser user3 "$containerName"
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
    && export batsContainerName="$containerName" \
    && ./bats/bats-core/bin/bats tests.bats \
    && ./bats/bats-core/bin/bats tests-"$containerName".bats
}

generateCert "example.com"
generateCert "conference.example.com"
generateCert "proxy.example.com"
generateCert "pubsub.example.com"
generateCert "upload.example.com"

# Run tests for first container with postgres
# Start postgres first and wait for 10 seconds before starting prosody.
sudo docker-compose down
sudo docker-compose up -d postgres
sleep 10
sudo docker-compose up -d prosody_postgres

registerTestUsers prosody_postgres
runTests prosody_postgres
sudo docker-compose down

# Run tests for second container with SQLite
sudo docker-compose up -d prosody
registerTestUsers prosody
runTests prosody
sudo docker-compose down

# Run tests for prosody with ldap
sudo docker-compose up -d prosody_ldap
runTests prosody_ldap
sudo docker-compose down
