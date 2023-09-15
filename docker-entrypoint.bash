#!/bin/bash
set -e

export DOMAIN_HTTP_UPLOAD=${DOMAIN_HTTP_UPLOAD:-"upload.$DOMAIN"}
export DOMAIN_MUC=${DOMAIN_MUC:-"conference.$DOMAIN"}
export DOMAIN_PROXY=${DOMAIN_PROXY:-"proxy.$DOMAIN"}
export DOMAIN_PUBSUB=${DOMAIN_PUBSUB:-"pubsub.$DOMAIN"}
export E2E_POLICY_WHITELIST=${E2E_POLICY_WHITELIST:-""}
export SERVER_CONTACT_INFO_ABUSE=${SERVER_CONTACT_INFO_ABUSE:-"xmpp:abuse@$DOMAIN"}
export SERVER_CONTACT_INFO_ADMIN=${SERVER_CONTACT_INFO_ADMIN:-"xmpp:admin@$DOMAIN"}
export SERVER_CONTACT_INFO_FEEDBACK=${SERVER_CONTACT_INFO_FEEDBACK:-"xmpp:feedback@$DOMAIN"}
export SERVER_CONTACT_INFO_SALES=${SERVER_CONTACT_INFO_SALES:-"xmpp:sales@$DOMAIN"}
export SERVER_CONTACT_INFO_SECURITY=${SERVER_CONTACT_INFO_SECURITY:-"xmpp:security@$DOMAIN"}
export SERVER_CONTACT_INFO_SUPPORT=${SERVER_CONTACT_INFO_SUPPORT:-"xmpp:support@$DOMAIN"}
export PROSODY_ADMINS=${PROSODY_ADMINS:-""}

if [[ "$1" != "prosody" ]]; then
    exec prosodyctl $*
    exit 0;
fi

if [ "$LOCAL" -a "$PASSWORD" -a "$DOMAIN" ] ; then
    prosodyctl register $LOCAL $DOMAIN $PASSWORD
fi

if [ -z "$DOMAIN" ]; then
  echo "[ERROR] DOMAIN must be set!"
  exit 1
fi

exec "$@"
