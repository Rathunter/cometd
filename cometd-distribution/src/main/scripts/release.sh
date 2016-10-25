#!/usr/bin/env bash

echo "Running release script with arguments" "$@"

COMETD_DIR=$1
VERSION=$2

echo "Updating cometd-javascript repository"
COMETD_JS_DIR=${COMETD_DIR}/target/release/cometd-javascript
git clone git@github.com:cometd/cometd-javascript.git ${COMETD_JS_DIR}

COMETD_JS_SOURCE=${COMETD_DIR}/cometd-javascript/common/target/cometd-javascript-common-${VERSION}
cp ${COMETD_JS_SOURCE}/org/cometd.js ${COMETD_JS_DIR}
cp ${COMETD_JS_SOURCE}/org/cometd/AckExtension.js ${COMETD_JS_DIR}
cp ${COMETD_JS_SOURCE}/org/cometd/ReloadExtension.js ${COMETD_JS_DIR}
cp ${COMETD_JS_SOURCE}/org/cometd/TimeStampExtension.js ${COMETD_JS_DIR}
cp ${COMETD_JS_SOURCE}/org/cometd/TimeSyncExtension.js ${COMETD_JS_DIR}

cd ${COMETD_JS_DIR}

cat <<EOF > ${COMETD_JS_DIR}/package.json
{
  "name": "cometd",
  "version": "${VERSION}",
  "description": "Comet and WebSocket library for web messaging",
  "keywords": ["comet", "websocket", "messaging", "pubsub", "publish", "subscribe", "rpc", "p2p", "peer-to-peer"],
  "homepage": "https://cometd.org",
  "bugs": {
    "url": "https://bugs.cometd.org"
  },
  "license": "Apache-2.0",
  "main": "cometd.js",
  "repository": {
    "type": "git",
    "url": "https://github.com/cometd/cometd.git"
  }
}
EOF

git add .
git commit -m "Release ${VERSION}."
git tag -am "Release ${VERSION}." ${VERSION}
git push --follow-tags

echo "Updating cometd-dojo repository"
COMETD_DOJO_DIR=${COMETD_DIR}/target/release/cometd-dojo
DOJO_VERSION=$3

git clone git@github.com:cometd/cometd-dojo.git ${COMETD_DOJO_DIR}

COMETD_DOJO_SOURCE=${COMETD_DIR}/cometd-javascript/dojo/target/cometd-javascript-dojo-${VERSION}
cp -r ${COMETD_DOJO_SOURCE}/org/* ${COMETD_DOJO_DIR}/org
cp ${COMETD_DOJO_SOURCE}/dojox/cometd.js ${COMETD_DOJO_DIR}
cp -r ${COMETD_DOJO_SOURCE}/dojox/cometd/* ${COMETD_DOJO_DIR}/cometd

cd ${COMETD_DOJO_DIR}

cat <<EOF > ${COMETD_DOJO_DIR}/package.json
{
  "name": "CometD",
  "version": "${VERSION}",
  "description": "Comet and WebSocket library for web messaging",
  "main": "cometd.js",
  "licenses": [{
    "type":"Apache License, Version 2.0",
    "url":"http://www.apache.org/licenses/LICENSE-2.0"
  }],
  "repository": {
    "type": "git",
    "url": "https://github.com/cometd/cometd-dojo.git"
  },
  "bugs": "https://bugs.cometd.org",
  "homepage": "https://cometd.org",
  "dependencies": {
    "dojo": "${DOJO_VERSION}"
  }
}
EOF
