#!/bin/bash -ex

export DEBIAN_FRONTEND=noninteractive

# remove password from sysdev (can still login via ssh + keys)
sudo passwd -d ubuntu

sudo apt-get autoremove --purge -yq
sudo apt-get clean -yq

# show old machine-id to help debugging just in case
echo "machine-id before removal: $(cat /etc/machine-id)"

# cloud-init clean is also supposed to make ssh_pwauth disabled again
# besides doing a bunch of other cleanings
sudo cloud-init clean --logs --machine-id --seed --configs all

# remove other leftovers
sudo rm -f /etc/cloud/cloud.cfg.d/91_kernel_cmdline_url.cfg
sudo rm -f /var/lib/systemd/random-seed
sudo rm -f /var/lib/systemd/credential.secret
sudo rm -rf /etc/ssh/ssh_host_*

