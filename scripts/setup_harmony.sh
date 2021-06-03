#!/bin/bash
pw=""
blskey_folder="bls_to_copy"
create_pass=false

# Download Harmony CLI tool
curl -LO https://harmony.one/hmycli && mv hmycli hmy && chmod +x hmy

# create key dir
mkdir -p .hmy/blskeys

# Copy key files
cp ${blskey_folder}/*.key .hmy/blskeys
cp ${blskey_folder}/*.pass .hmy/blskeys

# Add Password to key files (If not already in there..)
if $create_pass; then
    for f in ${blskey_folder}/*.key; do
        filename=$(basename -- "$f")
        filename="${filename%.*}"
        echo "$pw" >.hmy/blskeys/${filename}.pass
    done
fi

# recover key (Mnemonic phrase required)
./hmy keys recover-from-mnemonic Maffaz.One
