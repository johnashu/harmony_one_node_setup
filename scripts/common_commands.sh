# Basic commands to use for calling when troubleshooting common issues.
# so far just a list but should be added to command line args..

user="maffaz"

sudo chown ${user} /etc/systemd/system/harmony.service
sudo systemctl daemon-reload
sudo systemctl restart harmony
tail -n 1000 latest/zerolog-harmony*.log > harmony.log