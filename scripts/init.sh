#!/usr/bin/env bash

rm -rf $HOME/.minid
MINID_BIN=$(which minid)
if [ -z "$MINID_BIN" ]; then
    GOBIN=$(go env GOPATH)/bin
    MINID_BIN=$(which $GOBIN/minid)
fi

if [ -z "$MINID_BIN" ]; then
    echo "please verify minid is installed"
    exit 1
fi

# configure minid
$MINID_BIN config set client chain-id demo
$MINID_BIN config set client keyring-backend test
$MINID_BIN keys add alice
$MINID_BIN keys add bob
$MINID_BIN init test --chain-id demo --default-denom doge
# update genesis
$MINID_BIN genesis add-genesis-account alice 1000000000doge --keyring-backend test
$MINID_BIN genesis add-genesis-account bob 1000doge --keyring-backend test
# create default validator
$MINID_BIN genesis gentx alice 1000000doge --chain-id demo
$MINID_BIN genesis collect-gentxs
