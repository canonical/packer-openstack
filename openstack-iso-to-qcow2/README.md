
This packer plan is meant to install an ubuntu ISO to a qcow2 image
using autoinstaller. The installation will not reboot at the end, it
will instead just shut down and leave the machine in a state where
it will do it's first boot after deployed.

This is meant to make it possible to customize images in a way that
is not possible when starting from an already existing qcow2 (such as
special or elaborated partitioning schemes).

Once you get a qcow2 image, use it in the next stage to further
customize it (instead of adding more scripts to this plan).

Keeping this one small and clean helps the autointaller not to break
and removes redundancy.

ATTENTION:

This installation WILL NOT REBOOT, it will just shutdown after curtin
has written the installed image, before the actual 'first boot'.
This means that cloud-init will not have a chance to run yet, it will
only run later when booting this image somewhere else, either in
openstack directly or in next stage (qcow2-to-qcow2).

This also means that using 'user-data' inside autoinstall is
meaningless since that is embedded cloud-init data that will
only take effect on next boot.

Run with 'packer build ubuntu.pkr.hcl'

