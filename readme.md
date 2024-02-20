# Prosody XMPP Docker image

![Docker](https://github.com/SaraSmiseth/prosody/workflows/Docker/badge.svg?branch=dev)
![Git repository size](https://img.shields.io/github/repo-size/SaraSmiseth/prosody)
[![Docker pulls](https://img.shields.io/docker/pulls/sarasmiseth/prosody.svg)](https://hub.docker.com/r/sarasmiseth/prosody/)
[![Docker stars](https://img.shields.io/docker/stars/sarasmiseth/prosody.svg)](https://hub.docker.com/r/sarasmiseth/prosody/)
[![Github open issues](https://img.shields.io/github/issues-raw/SaraSmiseth/prosody)](https://github.com/SaraSmiseth/prosody/issues)
[![Github open pull requests](https://img.shields.io/github/issues-pr-raw/SaraSmiseth/prosody)](https://github.com/SaraSmiseth/prosody/pulls)

This docker image provides you with a configured [Prosody](https://prosody.im/) XMPP server. The image is based on `debian:bookworm-slim`.
The server was tested using the Android App [Conversations](https://conversations.im/) and the Desktop client [Gajim](https://gajim.org).
Multiple [architectures](https://hub.docker.com/r/sarasmiseth/prosody/tags) are supported. I use it on my raspberry pi 4.

While Conversations got everything set-up out-of-the-box, Gajim was used with the following extensions:

* HttpUpload
* Off-The-Record Encryption
* OMEMO (requires _python-axolotl_ to be installed)
* Url Image preview

## Table of Contents

- [Prosody XMPP Docker image](#prosody-xmpp-docker-image)
  - [Table of Contents](#table-of-contents)
  - [Features](#features)
  - [Requirements](#requirements)
  - [Image Details](#image-details)
    - [Ports](#ports)
    - [Directories](#directories)
      - [Data](#data)
      - [Bundled modules](#bundled-modules)
      - [Additionally installed prosody modules](#additionally-installed-prosody-modules)
      - [Config](#config)
      - [SSL certificates](#ssl-certificates)
        - [Folder structure](#folder-structure)
        - [Symlinks](#symlinks)
        - [Permissions](#permissions)
    - [Run](#run)
    - [Volumes permissions](#volumes-permissions)
    - [Docker tags](#docker-tags)
    - [Configuration](#configuration)
      - [Environment variables](#environment-variables)
      - [DNS](#dns)
    - [Extend](#extend)
    - [Upgrade](#upgrade)
  - [Test your server](#test-your-server)

## Features

* Secure by default
  * SSL certificate required
  * End-to-end encryption required (using [OMEMO](https://conversations.im/omemo/) or [OTR](https://en.wikipedia.org/wiki/Off-the-Record_Messaging))
* Data storage
  * SQLite message store
  * Configured file upload and image sharing
* Multi-user chat (MUC)

## Requirements

* You need a SSL certificate. I recommend [LetsEncrypt](https://letsencrypt.org/) for that.

## Image Details

### Ports

The following ports are exposed:

* 5000: proxy65 port used for file sharing
* 5222: c2s port (client to server)
* 5223: c2s legacy ssl port (client to server)
* 5269: s2s port (server to server)
* 5347: XMPP component port
* 5280: BOSH / websocket port
* 5281: Secure BOSH / websocket port

### Directories

#### Data

Path: ```/usr/local/var/lib/prosody/```.

* used for SQLite file
* used for HTTP uploads
* this is exposed as docker volume
  
#### Bundled modules

Path: ```/usr/local/lib/prosody/modules/```.

#### Additionally installed prosody modules

Path: ```/usr/local/lib/prosody/custom-modules/```.

#### Config

Path: ```/usr/local/etc/prosody/```.

* containing the main config file called ```prosody.cfg.lua```
* containing additional config files within ```conf.d/```

#### SSL certificates

Path: ```/usr/local/etc/prosody/certs/```.

Uses [automatic location](https://prosody.im/doc/certificates#automatic_location) to find your certs.

The http_upload module and the legacy_ssl module do not use the same search algorithm for the certificates. See [service certificates](https://prosody.im/doc/certificates#service_certificates).

The settings https_ssl and legacy_ssl_ssl in [05-vhost.cfg.lua](./conf.d/05-vhost.cfg.lua) configures the certificates to ```certs/domain.tld/fullchain.pem``` and ```certs/domain.tld/privkey.pem``` for legacy_ssl and to ```certs/DOMAIN_HTTP_UPLOAD/fullchain.pem``` and ```certs/DOMAIN_HTTP_UPLOAD/privkey.pem``` for http_upload where DOMAIN_HTTP_UPLOAD is an environtment variable.

##### Folder structure

An example certificate folder structure could look like this:

``` zsh
certs
├── conference.domain.tld
│   ├── fullchain.pem
│   └── privkey.pem
├── proxy.domain.tld
│   ├── fullchain.pem
│   └── privkey.pem
├── upload.domain.tld
│   ├── fullchain.pem
│   └── privkey.pem
└── domain.tld
    ├── fullchain.pem
    └── privkey.pem
```

Thats how Let's encrypt certbot does it out of the box.

##### Symlinks

certbot creates the structure and uses symlinks to the actual certificates.
If you mount them like that prosody somehow does not find them.
I copied them to a folder named ```certs``` next to my ```docker-compose.yml``` and made sure to use the ```-L``` flag of ```cp```.
This makes cp follow symbolic links when copying from them.
For example ```cp -L src dest```.

##### Permissions

See official [documentation](https://prosody.im/doc/certificates#permissions) for more information.
Check [Volumes permissions](#volumes-permissions) as well.

### Run

I recommend using a ```docker-compose.yml``` file:

```yaml
version: '3.7'

services:
  server:
    image: sarasmiseth/prosody:latest
    restart: unless-stopped
    ports:
      - "5000:5000"
      - "5222:5222"
      - "5223:5223"
      - "5269:5269"
      - "5281:5281"
    environment:
      DOMAIN: domain.tld
    volumes:
      - ./certs:/usr/local/etc/prosody/certs
      - ./data:/usr/local/var/lib/prosody
```

Boot it via: ```docker-compose up -d```.

Inspect logs: ```docker-compose logs -f```.

### Volumes permissions

The prosody user inside the container has the `uid=999` and `gid=999`. If you use the example `docker-compose.yml` from above make sure, that the `./data` folder and the `./certs` folder have the correct permissions.

``` shell
sudo chown 999:999 ./certs
sudo chown 999:999 ./data
```

### Docker tags

<https://hub.docker.com/r/sarasmiseth/prosody/tags>

| Tag      | Description                                                                                                                                                              |
| -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| edge     | This tag points to the latest version build from the newest [commit](https://github.com/SaraSmiseth/prosody/commits/dev) in the dev branch.                              |
| nightly  | This tag points to the latest version build from the newest [commit](https://github.com/SaraSmiseth/prosody/commits/dev) in the dev branch. It gets rebuild every night. |
| latest   | This tag points to the latest version build from the latest commit that is tagged in git. See [releases](https://github.com/SaraSmiseth/prosody/releases).               |
| *vX.Y.Z* | There is a tag for each [release](https://github.com/SaraSmiseth/prosody/releases).                                                                                      |

### Configuration

#### Environment variables

| Variable                         | Description                                                                                                          | Type                                         | Default value              |
| -------------------------------- | -------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- | -------------------------- |
| **ALLOW_REGISTRATION**           | Whether to allow registration of new accounts via Jabber clients                                                     | *optional*                                   | true                       |
| **DOMAIN**                       | domain                                                                                                               | **required**                                 | null                       |
| **DOMAIN_HTTP_UPLOAD**           | Domain which lets clients upload files over HTTP                                                                     | *optional*                                   | upload.**DOMAIN**          |
| **DOMAIN_MUC**                   | Domain for Multi-user chat (MUC) for allowing you to create hosted chatrooms/conferences for XMPP users              | *optional*                                   | conference.**DOMAIN**      |
| **DOMAIN_PROXY**                 | Domain for SOCKS5 bytestream proxy for server-proxied file transfers                                                 | *optional*                                   | proxy.**DOMAIN**           |
| **DOMAIN_PUBSUB**                | Domain for a XEP-0060 pubsub service                                                                                 | *optional*                                   | pubsub.**DOMAIN**          |
| **AUTHENTICATION**               | authentication                                                                                                       | *optional*                                   | "internal_hashed"          |
| **LDAP_BASE**                    | LDAP base directory which stores user accounts                                                                       | **required** if **AUTHENTICATION** is "ldap" |                            |
| **LDAP_SERVER**                  | Space-separated list of hostnames or IPs, optionally with port numbers (e.g. “localhost:8389”)                       | *optional*                                   | "localhost"                |
| **LDAP_ROOTDN**                  | The distinguished name to auth against                                                                               | *optional*                                   | ""                         |
| **LDAP_PASSWORD**                | Password for rootdn                                                                                                  | *optional*                                   | ""                         |
| **LDAP_FILTER**                  | Search filter, with $user and $host substituted for user- and hostname                                               | *optional*                                   | "(uid=$user)"              |
| **LDAP_SCOPE**                   | Search scope. other values: “base” and “onelevel”                                                                    | *optional*                                   | "subtree"                  |
| **LDAP_TLS**                     | Enable TLS (StartTLS) to connect to LDAP (can be true or false). The non-standard ‘LDAPS’ protocol is not supported. | *optional*                                   | "false"                    |
| **LDAP_MODE**                    | How passwords are validated.                                                                                         | *optional*                                   | "bind"                     |
| **LDAP_ADMIN_FILTER**            | Search filter to match admins, works like ldap_filter                                                                | *optional*                                   | ""                         |
| **DB_DRIVER**                    | May also be "PostgreSQL" or "MySQL" or "SQLite3" (case sensitive!)                                                   | *optional*                                   | SQLite3                    |
| **DB_DATABASE**                  | The database name to use. For SQLite3 this the database filename (relative to the data storage directory).           | *optional*                                   | prosody.sqlite             |
| **DB_HOST**                      | The address of the database server                                                                                   | *optional*                                   |                            |
| **DB_PORT**                      | Port on which the database is listening                                                                              | *optional*                                   |                            |
| **DB_USERNAME**                  | The username to authenticate to the database                                                                         | *optional*                                   |                            |
| **DB_PASSWORD**                  | The password to authenticate to the database                                                                         | *optional*                                   |                            |
| **HTTP_MAX_CONTENT_SIZE**        | Max http content size in bytes                                                                                       | *optional*                                   | 10485760                   |
| **HTTP_FILE_SHARE_SIZE_LIMIT**   | Max http file share size in bytes                                                                                    | *optional*                                   | 10485760                       |
| **HTTP_FILE_SHARE_DAILY_QUOTA**  | Daily quota in bytes                                                                                                 | *optional*                                   | 10 times share size limit  |
| **E2E_POLICY_CHAT**              | Policy for chat messages. Possible values: "none", "optional" and "required".                                        | *optional*                                   | "required"                 |
| **E2E_POLICY_MUC**               | Policy for MUC messages. Possible values: "none", "optional" and "required".                                         | *optional*                                   | "required"                 |
| **E2E_POLICY_WHITELIST**         | Make this module ignore messages sent to and from this JIDs or MUCs.                                                 | *optional*                                   | ""                         |
| **LOG_LEVEL**                    | Min log level. Change to debug for more information                                                                  | *optional*                                   | info                       |
| **C2S_REQUIRE_ENCRYPTION**       | Whether to force all client-to-server connections to be encrypted or not                                             | *optional*                                   | true                       |
| **S2S_REQUIRE_ENCRYPTION**       | Whether to force all server-to-server connections to be encrypted or not                                             | *optional*                                   | true                       |
| **S2S_SECURE_AUTH**              | Require encryption and certificate authentication                                                                    | *optional*                                   | true                       |
| **SERVER_CONTACT_INFO_ABUSE**    | A list of strings. Each string should be an URI. See [here](https://prosody.im/doc/modules/mod_server_contact_info). | *optional*                                   | "xmpp:abuse@**DOMAIN**"    |
| **SERVER_CONTACT_INFO_ADMIN**    | A list of strings. Each string should be an URI. See [here](https://prosody.im/doc/modules/mod_server_contact_info). | *optional*                                   | "xmpp:admin@**DOMAIN**"    |
| **SERVER_CONTACT_INFO_FEEDBACK** | A list of strings. Each string should be an URI. See [here](https://prosody.im/doc/modules/mod_server_contact_info). | *optional*                                   | "xmpp:feedback@**DOMAIN**" |
| **SERVER_CONTACT_INFO_SALES**    | A list of strings. Each string should be an URI. See [here](https://prosody.im/doc/modules/mod_server_contact_info). | *optional*                                   | "xmpp:sales@**DOMAIN**"    |
| **SERVER_CONTACT_INFO_SECURITY** | A list of strings. Each string should be an URI. See [here](https://prosody.im/doc/modules/mod_server_contact_info). | *optional*                                   | "xmpp:security@**DOMAIN**" |
| **SERVER_CONTACT_INFO_SUPPORT**  | A list of strings. Each string should be an URI. See [here](https://prosody.im/doc/modules/mod_server_contact_info). | *optional*                                   | "xmpp:support@**DOMAIN**"  |
| **PROSODY_ADMINS**               | Specify who is an administrator. List of adresses. Eg. "me@example.com", "admin@example.net"                         | *optional*                                   | ""                         |

#### DNS

You need these DNS record pointing to your server:

* domain.tld
* conference.domain.tld
* proxy.domain.tld
* pubsub.domain.tld
* upload.domain.tld
* A SRV record for _xmpps-client._tcp.domain.tld for port 5223.

where domain.tld is the environment variable DOMAIN.

### Extend

There is a helper script that eases installing additional prosody modules: ```docker-prosody-module-install```

It downloads the current [prosody-modules](https://hg.prosody.im/prosody-modules/) repository. The specified modules are copied and its name is added to the ```modules_enabled``` variable within ```conf.d/01-modules.cfg.lua```.

There is also ```docker-prosody-module-copy``` which copies the specified modules but does not add them to the ```modules_enabled``` variable within ```conf.d/01-modules.cfg.lua```.

If you need additional configuration just overwrite the respective _cfg.lua_ file or add new ones.

### Upgrade

When migrating from prosody 0.10, you need to update the database once:

```bash
docker-compose exec server bash
prosodyctl mod_storage_sql upgrade
```

## Test your server

You can test your server with these websites:

* [IM Observatory](https://www.xmpp.net/)
* [XMPP Compliance Tester](https://compliance.conversations.im/)
