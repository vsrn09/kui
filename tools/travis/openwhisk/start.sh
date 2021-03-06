#!/usr/bin/env bash

SCRIPTDIR=$(cd $(dirname "$0") && pwd)
OPENWHISK_CLI_VERSION=${OPENWHISK_CLI_VERSION-1.1.0}

EXT=tgz
PLATFORM=`uname -s`
if [[ $PLATFORM = Darwin ]]; then PLATFORM=mac; EXT=zip; fi

ARCH=`uname -m`
if [[ $ARCH = x86_64 ]]; then ARCH=amd64
elif [[ $ARCH = aarch64 ]]; then ARCH=arm64
fi

CLI=OpenWhisk_CLI-${OPENWHISK_CLI_VERSION}-${PLATFORM}-${ARCH}.${EXT}
URL=https://github.com/apache/openwhisk-cli/releases/download/${OPENWHISK_CLI_VERSION}/${CLI}
echo "Downloading CLI from $URL"
curl -LO $URL
if [[ $EXT = tgz ]]; then tar zxf $CLI
else unzip $CLI wsk
fi
chmod +x wsk
sudo mv wsk /usr/local/bin

# CONF=$("$SCRIPTDIR"/config.sh)

IMAGE="${1:-openwhisk/standalone:nightly}"
shift
docker run --rm -d \
  -h openwhisk --name openwhisk \
  -p 3233:3233 -p 3232:3232 \
  -v //var/run/docker.sock:/var/run/docker.sock \
 "$IMAGE" "$@"
docker exec openwhisk waitready

#AUTH=$(docker exec openwhisk wsk property get --auth | awk '{ print $3}')
wsk property set --auth 23bc46b1-71f6-4ed5-8c54-816aa4f8c502:123zO3xZCLrMN6v2BKK1dXYFpXlPkccOFqm12CdAsMgRU4VrNZ9lyGVCGuMDGIwP --apihost http://localhost:3233
wsk property get --auth

echo "$(tput setaf 2)OpenWhisk is ready!$(tput sgr0)" # green text
