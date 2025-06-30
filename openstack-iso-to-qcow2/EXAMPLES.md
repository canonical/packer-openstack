
This is a storage snippet that can be used in case you want separate
partitions in the final image (CSI hardening requires part of this).
It also uses LVM, to make life easier with so many partitions:

  storage:
    config:
      # Partition table
      - { ptable: gpt, path: /dev/vda, wipe: superblock-recursive, preserve: false, name: '', grub_device: true,type: disk, id: disk-vda }
      - { device: disk-vda, size: 1048576, flag: bios_grub, number: 1, preserve: false, grub_device: false, offset: 1048576, type: partition, id: partition-0 }

      # Linux boot partition
      - { device: disk-vda, size: 1G, wipe: superblock, number: 2, preserve: false, grub_device: false, offset: 2097152, type: partition, id: partition-1 }
      - { fstype: ext4, volume: partition-1, preserve: false, type: format, id: format-0 }

      # Partition for LVM, VG
      - { device: disk-vda, size: -1, wipe: superblock, number: 3, preserve: false, grub_device: false, offset: 2149580800, type: partition, id: partition-2 }
      - { name: rootVG, devices: [ partition-2 ], preserve: false, type: lvm_volgroup, id: lvm_volgroup-0 }

      # Swap
      - { name: swap, volgroup: lvm_volgroup-0, size: 1G, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-1 }
      - { fstype: swap, volume: lvm_partition-1, preserve: false, type: format, id: format-1 }

      # root
      - { name: rootVol, volgroup: lvm_volgroup-0, size: 5G, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-0 }
      - { fstype: ext4, volume: lvm_partition-0, preserve: false, type: format, id: format-2 }

      # opt
      - { name: optVol, volgroup: lvm_volgroup-0, size: 1G, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-2 }
      - { fstype: ext4, volume: lvm_partition-2, preserve: false, type: format, id: format-3 }

      # home
      - { name: homeVol, volgroup: lvm_volgroup-0, size: 1G, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-4 }
      - { fstype: ext4, volume: lvm_partition-4, preserve: false, type: format, id: format-4 }

      # tmp
      - { name: tmpVol, volgroup: lvm_volgroup-0, size: 1G, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-5 }
      - { fstype: ext4, volume: lvm_partition-5, preserve: false, type: format, id: format-5 }

      # var
      - { name: varVol, volgroup: lvm_volgroup-0, size: 2G, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-6 }
      - { fstype: ext4, volume: lvm_partition-6, preserve: false, type: format, id: format-6 }

      # varlog
      - { name: varlogVol, volgroup: lvm_volgroup-0, size: 1G, wipe: superblock, preserve: false, type: lvm_partition, id: lvm_partition-7 }
      - { fstype: ext4, volume: lvm_partition-7, preserve: false, type: format, id: format-7 }

      # Mount points
      - { path: /boot, device: format-0, type: mount, id: mount-0 }
      - { path: '', device: format-1, type: mount, id: mount-1 }
      - { path: /, device: format-2, type: mount, id: mount-2 }
      - { path: /opt, device: format-3, type: mount, id: mount-3 }
      - { path: /home, device: format-4, type: mount, id: mount-4 }
      - { path: /tmp, device: format-5, type: mount, id: mount-5 }
      - { path: /var, device: format-6, type: mount, id: mount-6 }
      - { path: /var/log, device: format-7, type: mount, id: mount-7 }
    swap:
      # this is because we already have swap inside LVM
      swap: 0
