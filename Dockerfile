FROM debian:trixie-slim AS gucci-builder

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      golang ca-certificates

# for this to work with latest guccii version debian trixie is needed as the golang version is too old in bookworm
# Maybe change to a golang image with preinstalled go?
RUN go install github.com/noqcks/gucci@latest

FROM debian:trixie-slim AS prosody-dependencies

ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

ARG LUAROCKS_VERSION=3.11.1
ARG PROSODY_VERSION=13.0.2

ARG LUAROCKS_SHA256="c3fb3d960dffb2b2fe9de7e3cb004dc4d0b34bb3d342578af84f84325c669102"
ARG PROSODY_DOWNLOAD_SHA256="3e61bd396f37ca5245debfd6be49a47a6191332f0faa2d4ee5f00fbb040addb0"

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

COPY --from=gucci-builder /root/go/bin/gucci /usr/local/bin/gucci

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
      libevent-dev `# this is no build dependency, but needed for luaevent` \
      libicu76 \
      libidn2-0 \
      libpq-dev \
      libsqlite3-0 \
      lua5.2 \
      lua-bitop \
      lua-dbi-mysql \
      lua-dbi-postgresql \
      lua-expat \
      lua-filesystem \
      lua-ldap \
      lua-socket \
      lua-sec \
      lua-unbound \
      wget \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# TODO in build-prosody below move luarocks etc up to here and only let prosody deps + make of prosody stay
# TODO Test if it works without luarocks. server seems to start

FROM prosody-dependencies AS build-prosody

RUN buildDeps='gcc git libc6-dev libidn2-dev liblua5.2-dev libsqlite3-dev libssl-dev libicu-dev make unzip' \
 && set -x \
 && apt-get update && apt-get install -y $buildDeps --no-install-recommends \
 && rm -rf /var/lib/apt/lists/* \
 \
 && wget -O prosody.tar.gz "https://prosody.im/downloads/source/prosody-${PROSODY_VERSION}.tar.gz" \
 && echo "${PROSODY_DOWNLOAD_SHA256} *prosody.tar.gz" | sha256sum -c - \
 && mkdir -p /usr/src/prosody \
 && tar -xzf prosody.tar.gz -C /usr/src/prosody --strip-components=1 \
 && rm prosody.tar.gz \
 && cd /usr/src/prosody \
 && ./configure \
 && make \
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
 && luarocks install luadbi-sqlite3 \
 \
 && apt-get purge -y --auto-remove $buildDeps

FROM prosody-dependencies AS final-image

# copy compiled folder, so i can do make install
COPY --from=build-prosody /usr/src/prosody /usr/src/prosody

RUN apt-get update && apt-get install -y make --no-install-recommends \
 && rm -rf /var/lib/apt/lists/* \
 \
 && cd /usr/src/prosody \
 && make install \
 && rm -r /usr/src/prosody \
 \
 && apt-get purge -y --auto-remove make

EXPOSE 5000 5222 5223 5269 5347 5280 5281

RUN groupadd -r prosody \
 && useradd -r -g prosody prosody \
 && chown prosody:prosody /usr/local/var/lib/prosody

RUN mkdir -p /var/run/prosody/ \
 && chown prosody:prosody /var/run/prosody/

# https://github.com/prosody/prosody-docker/issues/25
ENV __FLUSH_LOG=yes

VOLUME ["/usr/local/var/lib/prosody"]

COPY prosody.cfg.lua.tpl /usr/local/etc/prosody/prosody.cfg.lua.tpl
COPY docker-entrypoint.bash /entrypoint.bash
COPY conf.d/01-modules.cfg.lua /usr/local/etc/prosody/conf.d/01-modules.cfg.lua
COPY conf.d/*.cfg.lua.tpl /usr/local/etc/prosody/conf.d/
RUN chown prosody:prosody -R /usr/local/etc/prosody/

COPY *.bash /usr/local/bin/

RUN download-prosody-modules.bash \
 && docker-prosody-module-install.bash \
        cloud_notify `# XEP-0357: Push Notifications` \
        e2e_policy `# require end-2-end encryption` \
        filter_chatstates `# disable "X is typing" type messages` \
        throttle_presence `# presence throttling in CSI` \
        vcard_muc `# XEP-0153: vCard-Based Avatar (MUC)` \
 && rm -rf "/usr/src/prosody-modules"

USER prosody

ENTRYPOINT ["/entrypoint.bash"]
CMD ["prosody", "-F"]
