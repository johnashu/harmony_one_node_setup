#!/bin/bash

node_name="Maffaz.One"
shard="2"

echo -e "\n    $(date)" && \
echo -e "\n    ${node_name}:\n" && \
./hmy blockchain latest-headers | grep -e epoch -e viewID -e shardID && \
echo -e "\n    External Harmony Node:\n" && \
./hmy --node="https://api.s${shard}.t.hmny.io" blockchain latest-headers  | grep -e epoch -e viewID -e shardID && \
echo -e "\n    Usage:\n\n    $(uptime)\n\n     Harmony Shard0 Size  ::  $(du -h harmony_db_0)\n     Harmony Shard${shard} Size  ::  $(du -h harmony_db_${shard})\n" &&\
echo -e "    Binary Version:\n\n     $(./harmony -V)\n"