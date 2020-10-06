#!/bin/zsh

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
generateCert "pubsub.localhost"
generateCert "proxy.localhost"
generateCert "upload.localhost"

 # If updates are available --> update and create new version with 'pip-chill > requirements.txt'

sudo docker-compose down \
&& sudo docker-compose up -d \
\
&& sudo docker exec tests_prosody_1 /bin/bash -c "/entrypoint.sh register admin localhost 12345678" \
&& sudo docker exec tests_prosody_1 /bin/bash -c "/entrypoint.sh register user1 localhost 12345678" \
&& sudo docker exec tests_prosody_1 /bin/bash -c "/entrypoint.sh register user2 localhost 12345678" \
&& sudo docker exec tests_prosody_1 /bin/bash -c "/entrypoint.sh register user3 localhost 12345678" \
\
&& python -m venv venv \
&& source venv/bin/activate \
&& pip install -r requirements.txt \
&& pytest \
&& deactivate \
&& sleep 1 \
&& sudo docker-compose logs | grep "message to" \
&& sudo docker-compose logs | grep "type='error'"

# Received[c2s]: <message to='*@localhost' * type='chat'>
# Should be five times in log

# TODO Call bats and create tests to check log output

sudo docker-compose down
