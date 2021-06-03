#!/bin/bash

# syNC WITH Rclone
curl https://rclone.org/install.sh | sudo bash

# Create config file
rclone config file

# Update config
cat <<-EOF >~/.config/rclone/rclone.conf
[release]
type = s3
provider = AWS
env_auth = false
region = us-west-1
acl = public-read
server_side_encryption = AES256
storage_class = REDUCED_REDUNDANCY
EOF

# Sync Dbs , Comment as appropriate - TODO: allow user to select in a config file..
rclone -P sync release:pub.harmony.one/mainnet.min/harmony_db_0 harmony_db_0
# rclone -P sync release:pub.harmony.one/mainnet.min/harmony_db_1 harmony_db_1
rclone -P sync release:pub.harmony.one/mainnet.min/harmony_db_2 harmony_db_2
# rclone -P sync release:pub.harmony.one/mainnet.min/harmony_db_3 harmony_db_3
