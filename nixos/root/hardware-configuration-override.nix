{ config, lib, pkgs, ... }:

with lib;

let
  mkBind = device: {
    inherit device;
    fsType  = "none";
    options = [ "defaults" "bind" "rw" ];
  };
in

{
  boot = {
    tmpOnTmpfs = true;
    cleanTmpDir = true;

    # Bootloader
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  fileSystems = {
    "/mnt/hdd" =
      { device = "/dev/disk/by-partuuid/650fcfee-3cdd-46d0-acb0-d159eb4f6b07";
        fsType = "ntfs";
        options = [ "nofail" ];
      };
  };
}
