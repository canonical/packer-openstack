
packer {
  required_version = ">= 1.12.0"
  required_plugins {
    qemu = {
      #version = "~> 1.1.1"
      version = "= 1.1.1" # see https://github.com/hashicorp/packer-plugin-qemu/issues/198
      source  = "github.com/hashicorp/qemu"
    }
  }
}

source "qemu" "iso" {
  # for ubuntu noble
  vm_name              = "ubuntu-2404-amd64_packer-from-iso.qcow2"
  iso_url              = "https://www.releases.ubuntu.com/24.04/ubuntu-24.04.2-live-server-amd64.iso"
  iso_checksum         = "d6dab0c3a657988501b4bd76f1297c053df710e06e0c3aece60dead24f270b4d"
  # for ubuntu jammy
  #vm_name              = "ubuntu-2204-amd64_packer-from-iso.qcow2"
  #iso_url              = "https://www.releases.ubuntu.com/22.04/ubuntu-22.04.5-live-server-amd64.iso"
  #iso_checksum         = "9bc6028870aef3f74f4e16b900008179e78b130e6b0b9a140635434a46aa98b0"
  # if the image is created as EFI, you will need -> openstack image set --property hw_firmware_type=uefi $IMAGE
  #efi_boot             = true
  #efi_firmware_code    = "/usr/share/OVMF/OVMF_CODE_4M.fd"
  #efi_firmware_vars    = "/usr/share/OVMF/OVMF_VARS_4M.fd"
  cpus                 = 2
  memory               = 1500
  headless             = false
  disk_image           = false
  output_directory     = "build"
  accelerator          = "kvm"
  disk_size            = "5G"
  disk_interface       = "virtio"
  format               = "qcow2"
  net_device           = "virtio-net"
  http_directory       = "http"
  communicator         = "none"
  shutdown_timeout     = "30m" # just in case it hangs, it should shut itself down in <10min
  boot_wait            = "3s"
  boot_command         = [
    "e<wait>",
    "<down><down><down><end>",
    " autoinstall ds=\"nocloud;s=http://_gateway:{{.HTTPPort}}/\"",
    "<f10>",
    ]
}

build {
  name    = "builder"
  sources = ["source.qemu.iso"]
}

