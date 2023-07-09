#!/bin/zsh

update_luarocks() {
  # Get latest luarocks version and calculate sha256 hash of the tarball
  local LUAROCKS_VER=$(wget -q -O - 'https://api.github.com/repos/luarocks/luarocks/tags' | jq -r ".[0].name")
  local LUAROCKS_VER=${LUAROCKS_VER#v}
  local LUAROCKS_SHA256_HASH=$(wget -q -O - "https://luarocks.org/releases/luarocks-$LUAROCKS_VER.tar.gz" | sha256sum --zero | perl -lane 'print $F[0]')

  # Update Dockerfile
  perl -pi -e "s/LUAROCKS_VERSION=\K.*/$LUAROCKS_VER/" Dockerfile
  perl -pi -e "s/LUAROCKS_SHA256=\K.*/\"$LUAROCKS_SHA256_HASH\"/" Dockerfile
}

update_luarocks
