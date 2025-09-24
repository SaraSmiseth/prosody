#!/bin/bash
set -e

# Use gucci on templates
if [ ! -f /usr/local/etc/prosody/prosody.cfg.lua ]; then
  gucci -o missingkey=default /usr/local/etc/prosody/prosody.cfg.lua.tpl > /usr/local/etc/prosody/prosody.cfg.lua
fi
if [ ! -f /usr/local/etc/prosody/conf.d/02-storage.cfg.lua ]; then
  gucci -o missingkey=default /usr/local/etc/prosody/conf.d/02-storage.cfg.lua.tpl > /usr/local/etc/prosody/conf.d/02-storage.cfg.lua
fi
if [ ! -f /usr/local/etc/prosody/conf.d/03-e2e-policy.cfg.lua ]; then
  gucci -o missingkey=default /usr/local/etc/prosody/conf.d/03-e2e-policy.cfg.lua.tpl > /usr/local/etc/prosody/conf.d/03-e2e-policy.cfg.lua
fi
if [ ! -f /usr/local/etc/prosody/conf.d/04-server_contact_info.cfg.lua ]; then
  gucci -o missingkey=default /usr/local/etc/prosody/conf.d/04-server_contact_info.cfg.lua.tpl > /usr/local/etc/prosody/conf.d/04-server_contact_info.cfg.lua
fi
if [ ! -f /usr/local/etc/prosody/conf.d/05-vhost.cfg.lua ]; then
  gucci -o missingkey=default /usr/local/etc/prosody/conf.d/05-vhost.cfg.lua.tpl > /usr/local/etc/prosody/conf.d/05-vhost.cfg.lua
fi

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
