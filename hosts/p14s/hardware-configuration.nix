# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    # nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen2
    # nixos-hardware.nixosModules.common-pc-laptop-acpi_call
  ];

  # Wifi support
  hardware.firmware = [pkgs.rtw89-firmware];
  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
    amdvlk
  ];
  hardware.opengl.driSupport = true;
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.extraPackages32 = with pkgs; [driversi686Linux.amdvlk];

  hardware.bluetooth = {
    enable = true;
    settings = {
      # Disable auto turn on
      Policy = {AutoEnable = false;};
      General = {Enable = "Source,Sink,Media,Socket";};
    };
  };

  boot.kernelParams = ["amdgpu.backlight=0" "acpi_backlight=none"];
  # Modules nvme: nvme ssd, xhci_pci: usb and pci, rtsx_pci_sdmmc: Realtek pci sdmmc card reader
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "rtsx_pci_sdmmc" "thinkpad_acpi"];
  # Modules dm-snapshot: https://www.kernel.org/doc/html/latest/admin-guide/device-mapper/snapshot.html, snapshots for lvm
  boot.initrd.kernelModules = ["dm-snapshot"];

  boot.kernelPackages = pkgs.unstable.linuxPackages_5_18;
  # Modules
  # kvm-amd: kernel based virtualization for amd,
  # amdgpu: driver for radeon based gpus https://www.kernel.org/doc/html/v4.20/gpu/amdgpu.html
  # acpi_call: call  acpi methods (https://de.wikipedia.org/wiki/Advanced_Configuration_and_Power_Interface)
  boot.kernelModules = ["kvm-amd" "amdgpu" "acpi_call"];
  boot.extraModulePackages = with config.boot.kernelPackages; [acpi_call];

  fileSystems."/" = {
    neededForBoot = true;
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  fileSystems."/var" = {
    device = "/dev/disk/by-label/var";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-label/home";
    fsType = "ext4";
  };

  fileSystems."/tmp" = {
    device = "/dev/disk/by-label/tmp";
    fsType = "ext4";
  };

  swapDevices = [{device = "/dev/disk/by-label/swap";}];

  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
