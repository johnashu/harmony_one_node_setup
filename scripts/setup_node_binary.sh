#!/bin/bash

key_dir="./.hmy/blskeys"
data_dir="./"
max_keys=10
network="mainnet"
working_dir="/home/maffaz"
user="maffaz"

# Node Binary
curl -LO https://harmony.one/binary && mv binary harmony && chmod +x harmony
./harmony dumpconfig harmony.conf

cat <<-EOF >harmony.conf
Version = "1.0.4"

[BLSKeys]
  KMSConfigFile = ""
  KMSConfigSrcType = "shared"
  KMSEnabled = false
  KeyDir = "${key_dir}"
  KeyFiles = []
  MaxKeys = ${max_keys}
  PassEnabled = true
  PassFile = ""
  PassSrcType = "auto"
  SavePassphrase = false

[General]
  DataDir = "${data_dir}"
  IsArchival = false
  IsBeaconArchival = false
  IsOffline = false
  NoStaking = false
  NodeType = "validator"
  ShardID = -1

[HTTP]
  Enabled = true
  IP = "127.0.0.1"
  Port = 9500
  RosettaEnabled = false
  RosettaPort = 9700

[Log]
  FileName = "harmony.log"
  Folder = "./latest"
  RotateSize = 100
  Verbosity = 3

[Network]
  BootNodes = ["/dnsaddr/bootstrap.t.hmny.io"]
  DNSPort = 9000
  DNSZone = "t.hmny.io"
  LegacySyncing = false
  NetworkType = "${network}"

[P2P]
  IP = "0.0.0.0"
  KeyFile = "./.hmykey"
  Port = 9000

[Pprof]
  Enabled = false
  ListenAddr = "127.0.0.1:6060"

[RPCOpt]
  DebugEnabled = false

[Sync]
  Concurrency = 4
  DiscBatch = 8
  DiscHardLowCap = 4
  DiscHighCap = 1024
  DiscSoftLowCap = 4
  Downloader = false
  InitStreams = 4
  MinPeers = 4

[TxPool]
  BlacklistFile = "./.hmy/blacklist.txt"

[WS]
  Enabled = true
  IP = "127.0.0.1"
  Port = 9800

[Consensus]
AggregateSig=false

EOF

# Setup Systemd

cat <<-EOF > /etc/systemd/system/harmony.service
[Unit]
Description=Harmony daemon
After=network-online.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=${user}
WorkingDirectory=${working_dir}
ExecStart=${working_dir}/harmony -c harmony.conf
SyslogIdentifier=harmony
StartLimitInterval=0
LimitNOFILE=65536
LimitNPROC=65536

[Install]
WantedBy=multi-user.target
EOF

sudo chmod 755 /etc/systemd/system/harmony.service
sudo systemctl enable harmony.service
sudo service harmony start
sudo service harmony status
