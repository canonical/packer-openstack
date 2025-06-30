
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

source "qemu" "qcow2" {
  vm_name              = "ubuntu-2404-amd64_packer-customized.qcow2"
  #vm_name              = "ubuntu-2204-amd64_packer-customized.qcow2"
  iso_url              = var.source_qcow2_image
  iso_checksum         = "none"
  # if the image is EFI, you need -> openstack image set --property hw_firmware_type=uefi $IMAGE
  #efi_boot             = true
  #efi_firmware_code    = "/usr/share/OVMF/OVMF_CODE_4M.fd"
  #efi_firmware_vars    = "/usr/share/OVMF/OVMF_VARS_4M.fd"
  cpus                 = 2
  memory               = 1500
  headless             = false
  disk_image           = true
  output_directory     = "build"
  accelerator          = "kvm"
  disk_interface       = "virtio"
  format               = "qcow2"
  skip_resize_disk     = true
  net_device           = "virtio-net"
  http_directory       = "http"
  communicator         = "ssh"
  ssh_username         = "ubuntu"
  ssh_password         = "ubuntu"
  ssh_timeout          = "15m"
  pause_before_connecting = "10s"
  shutdown_command     = "echo packer | sudo -S shutdown -P now"
  boot_wait            = "1s"
  # boot command does not work because grub menu is hidden
  #boot_command         = [
  #  "e<wait><down><down><down><down><down><down><down><down><down><down><end>",
  #  " cloud-config-url=\"http://_gateway:{{.HTTPPort}}/user-data\"<f10>"
  #  ]
  # using a hack via smbios instead to point the cloud-init source
  qemuargs = [
    ["-smbios", "type=1,serial=ds=nocloud;s=http://_gateway:{{.HTTPPort}}/"],
    ["-smbios", "type=11,value=ds=nocloud;s=http://_gateway:{{.HTTPPort}}/"],
  ]
}

build {
  name    = "builder"
  sources = ["source.qemu.qcow2"]

  provisioner "shell" {
    scripts            = [
        "${path.root}/scripts/my-customizations.sh",
        "${path.root}/scripts/cleanup.sh"
    ]
  }

}

variable "source_qcow2_image" {
  type        = string
  default     = "../openstack-iso-to-qcow2/build/ubuntu-2404-amd64_packer-from-iso.qcow2"
  description = "file to use as input qcow2 image"
}

