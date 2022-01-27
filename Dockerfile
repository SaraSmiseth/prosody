FROM debian:bullseye-slim

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ARG LUAROCKS_VERSION=3.8.0
ARG PROSODY_VERSION=0.11.13

ARG LUAROCKS_SHA256=56ab9b90f5acbc42eb7a94cf482e6c058a63e8a1effdf572b8b2a6323a06d923
ARG PROSODY_DOWNLOAD_SHA256=39c61b346a09b5125b604cb969e14206cbbcb86c81156ffc6ba2d62527cf0432

LABEL luarocks.version="${LUAROCKS_VERSION}"
LABEL org.opencontainers.image.authors="Sara Smiseth"
LABEL org.opencontainers.image.created="${BUILD_DATE}"
LABEL org.opencontainers.image.description="This docker image provides you with a configured Prosody XMPP server."
LABEL org.opencontainers.image.documentation="https://github.com/SaraSmiseth/prosody/blob/dev/readme.md"
LABEL org.opencontainers.image.revision="${VCS_REF}"
LABEL org.opencontainers.image.source="https://github.com/SaraSmiseth/prosody/archive/dev.zip"
LABEL org.opencontainers.image.title="prosody"
LABEL org.opencontainers.image.url="https://github.com/SaraSmiseth/prosody"
LABEL org.opencontainers.image.vendor="Sara Smiseth"
LABEL org.opencontainers.image.version="${VERSION}"
LABEL prosody.version="${PROSODY_VERSION}"

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      libevent-dev `# this is no build dependency, but needed for luaevent` \
      libidn11 \
      libpq-dev \
      libsqlite3-0 \
      lua5.2 \
      lua-bitop \
      lua-dbi-mysql \
      lua-expat \
      lua-filesystem \
      lua-socket \
      lua-sec \
      wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN buildDeps='gcc git libc6-dev libidn11-dev liblua5.2-dev libsqlite3-dev libssl-dev make unzip' \
 && set -x \
 && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
 && rm -rf /var/lib/apt/lists/* \
 \
 && wget -O prosody.tar.gz "https://prosody.im/downloads/source/prosody-${PROSODY_VERSION}.tar.gz" \
 && echo "${PROSODY_DOWNLOAD_SHA256} *prosody.tar.gz" | sha256sum -c - \
 && mkdir -p /usr/src/prosody \
 && tar -xzf prosody.tar.gz -C /usr/src/prosody --strip-components=1 \
 && rm prosody.tar.gz \
 && cd /usr/src/prosody && ./configure \
 && make \
 && make install \
 && cd / && rm -r /usr/src/prosody \
 \
 && mkdir /usr/src/luarocks \
 && cd /usr/src/luarocks \
 && wget https://luarocks.org/releases/luarocks-${LUAROCKS_VERSION}.tar.gz \
 && echo "${LUAROCKS_SHA256} luarocks-${LUAROCKS_VERSION}.tar.gz" | sha256sum -c - \
 && tar zxpf luarocks-${LUAROCKS_VERSION}.tar.gz \
 && cd luarocks-${LUAROCKS_VERSION} \
 && ./configure \
 && make bootstrap \
 && cd / && rm -r /usr/src/luarocks \
 \
 && luarocks install luaevent \
 && luarocks install luadbi \
 `#&& luarocks install luadbi-mysql MYSQL_INCDIR=/usr/include/mariadb/` \
 && luarocks install luadbi-postgresql POSTGRES_INCDIR=/usr/include/postgresql/ \
 && luarocks install luadbi-sqlite3 \
 && luarocks install stringy \
 \
 && apt-get purge -y --auto-remove $buildDeps

EXPOSE 5000 5222 5223 5269 5347 5280 5281

RUN groupadd -r prosody \
 && useradd -r -g prosody prosody \
 && chown prosody:prosody /usr/local/var/lib/prosody

RUN mkdir -p /var/run/prosody/ \
 && chown prosody:prosody /var/run/prosody/

# https://github.com/prosody/prosody-docker/issues/25
ENV __FLUSH_LOG yes

VOLUME ["/usr/local/var/lib/prosody"]

COPY prosody.cfg.lua /usr/local/etc/prosody/prosody.cfg.lua
COPY docker-entrypoint.bash /entrypoint.bash
COPY conf.d/*.cfg.lua /usr/local/etc/prosody/conf.d/

COPY *.bash /usr/local/bin/

RUN download-prosody-modules.bash \
 && docker-prosody-module-install.bash \
        bookmarks `# XEP-0411: Bookmarks Conversion` \
        carbons `# message carbons (XEP-0280)` \
        cloud_notify `# XEP-0357: Push Notifications` \
        csi `# client state indication (XEP-0352)` \
        e2e_policy `# require end-2-end encryption` \
        filter_chatstates `# disable "X is typing" type messages` \
        smacks `# stream management (XEP-0198)` \
        throttle_presence `# presence throttling in CSI` \
        http_upload `# file sharing (XEP-0363)` \
        vcard_muc `# XEP-0153: vCard-Based Avatar (MUC)` \
 && rm -rf "/usr/src/prosody-modules"

USER prosody

ENTRYPOINT ["/entrypoint.bash"]
CMD ["prosody", "-F"]

