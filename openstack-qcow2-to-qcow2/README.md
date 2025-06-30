
This plan will take an existing qcow2 image, boot it, further customize
it, clean after itself and re-pack it to be used again as if it was the
first boot.

It can take either an image downloaded from the internet or one generated
by the earlier stage (iso-to-qcow2).

The idea is to concentrate all customizations here so that it is more
generic and less rendundant.

user-data on this plan must not have any autoinstall directives and
instead contain plain cloud-init configs on the main level.

