# Reference data of commands to setup.. Changes to Harmony should be changed here also.

# Download Harmony CLI tool

curl -LO https://harmony.one/hmycli && mv hmycli hmy && chmod +x hmy

# cREATE kEYS

./hmy keys generate-bls-keys --count 1 --shard 2 --passphrase

# Configuring the BLS keys

mkdir -p .hmy/blskeys
cp *.key .hmy/blskeys

echo "" > .hmy/blskeys/KEY.pass


# recover key
./hmy keys recover-from-mnemonic Maffaz.One

# syNC WITH Rclone

curl https://rclone.org/install.sh | sudo bash

# rclone config file

cat<<-EOF > ~/.config/rclone/rclone.conf
[release]
type = s3
provider = AWS
env_auth = false
region = us-west-1
acl = public-read
server_side_encryption = AES256
storage_class = REDUCED_REDUNDANCY
EOF

rclone -P sync release:pub.harmony.one/mainnet.min/harmony_db_0 harmony_db_0
rclone -P sync release:pub.harmony.one/mainnet.min/harmony_db_2 harmony_db_2

rclone -P sync release:pub.harmony.one/mainnet.min/harmony_db_0 /mnt/volume_sfo3_01/harmony_db_0
rclone -P sync release:pub.harmony.one/mainnet.min/harmony_db_2 /mnt/volume_sfo3_01/harmony_db_2

# Node Binary

curl -LO https://harmony.one/binary && mv binary harmony && chmod +x harmony

# config

./harmony dumpconfig harmony.conf

nano harmony.conf

Version = "1.0.4"

[BLSKeys]
  KMSConfigFile = ""
  KMSConfigSrcType = "shared"
  KMSEnabled = false
  KeyDir = "./.hmy/blskeys"
  KeyFiles = []
  MaxKeys = 10
  PassEnabled = true
  PassFile = ""
  PassSrcType = "auto"
  SavePassphrase = false

[General]
  DataDir = "/mnt/volume_sfo3_01"
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
  NetworkType = "mainnet"

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
  Concurrency = 6
  DiscBatch = 8
  DiscHardLowCap = 6
  DiscHighCap = 128
  DiscSoftLowCap = 8
  Downloader = false
  InitStreams = 8
  LegacyClient = true
  LegacyServer = true
  MinPeers = 6

[TxPool]
  BlacklistFile = "./.hmy/blacklist.txt"

[WS]
  Enabled = true
  IP = "127.0.0.1"
  Port = 9800

[Consensus]
AggregateSig=false


 # Setup Systemd

sudo nano /etc/systemd/system/harmony.service

[Unit]
Description=Harmony daemon
After=network-online.target

[Service]
Type=simple
Restart=always
RestartSec=1
User=root
WorkingDirectory=/root
ExecStart=/root/harmony -c harmony.conf
SyslogIdentifier=harmony
StartLimitInterval=0
LimitNOFILE=65536
LimitNPROC=65536

[Install]
WantedBy=multi-user.target


sudo chmod 755 /etc/systemd/system/harmony.service
sudo systemctl enable harmony.service
sudo service harmony start
sudo service harmony status
sudo service harmony restart
