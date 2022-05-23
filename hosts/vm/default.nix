{ config, pkgs, ... }:

{
  imports =  [                                  # For now, if applying to other system, swap files
    ./hardware-configuration.nix                # Current system hardware config @ /etc/nixos/hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = {
   root = {
      name = "root";
      device = "/dev/disk/by-uuid/ac8e83e9-2762-4864-83a0-3b940282a21f";
      preLVM = true;
      allowDiscards = true;
    };
  };
}
