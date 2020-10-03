FROM debian:buster-slim

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      libevent-dev `# this is no build dependency, but needed for luaevent` \
      libidn11 \
      lua5.2 \
      lua-bitop \
      lua-expat \
      lua-filesystem \
      lua-socket \
      lua-sec \
      sqlite3 \
      wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV PROSODY_VERSION 0.11.7
ENV PROSODY_DOWNLOAD_URL https://prosody.im/downloads/source/prosody-${PROSODY_VERSION}.tar.gz
ENV PROSODY_DOWNLOAD_SHA256 28ffc07653485cb63e22b387d3ea4825ee2baaee0c5827de4d6053a35b1c8747
ENV LUAROCKS_VERSION 3.4.0
ENV LUAROCKS_SHA256 62ce5826f0eeeb760d884ea8330cd1552b5d432138b8bade0fa72f35badd02d0

RUN buildDeps='gcc git libc6-dev libidn11-dev liblua5.2-dev libsqlite3-dev libssl-dev make unzip' \
 && set -x \
 && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
 && rm -rf /var/lib/apt/lists/* \
 \
 && wget -O prosody.tar.gz "${PROSODY_DOWNLOAD_URL}" \
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
COPY docker-entrypoint.sh /entrypoint.sh
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

ENTRYPOINT ["/entrypoint.sh"]
CMD ["prosody", "-F"]

