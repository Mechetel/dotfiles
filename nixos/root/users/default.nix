{ pkgs }:

with pkgs;

rec {
  mutableUsers = false;

  defaultUserShell = zsh;

  extraUsers =
    let
      # generated via: mkpasswd -m sha-512
      hashedPassword = "$6$FVQALIyY$HMIosPeHwgBfDSgUHhqgrs/7luW1RtST4R2a4q3AhENoOLRB1JPEZ5g60rspa8q28yIiJxE/UpQe2PrkicYC80";
    in {
      root = {
        inherit hashedPassword;
      };

      mechetel = {
        isNormalUser = true;
        extraGroups = [ "audio" "disk" "wheel" "networkmanager" "docker" "vboxusers" "libvirtd" ];
        inherit hashedPassword;
      };
    };
}
