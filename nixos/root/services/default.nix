{ pkgs }:

with pkgs;
with pkgs.lib;

let
  layout = ../../../layouts/en_ru;
in

rec {
  openssh.enable = true;
  xbanish.enable = true;
  compton.enable = true;

  gnome3.gnome-documents.enable = false;
  gnome3.gnome-online-accounts.enable = false;
  gnome3.gnome-terminal-server.enable = false;
  gnome3.gnome-user-share.enable = false;
  gnome3.tracker.enable = false;

  redshift = {
    enable = true;
    latitude = "47.517201";
    longitude = "35.859375";
    temperature.night = 2500;
    brightness.night = "0.5";
  };

  acpid = {
    enable = true;
    handlers = {
      power = {
        event = "button/power";
        action = "${pkgs.systemd}/bin/systemctl poweroff";
      };
    };
  };

  logind.extraConfig = "HandleLidSwitch=ignore";

  xserver = {
    enable = true;

    layout = "us,ru";
    xkbOptions = "caps:swapescape,grp:rctrl_rshift_toggle";
    xkbVariant = "qwerty";
    libinput.enable = true;

    dpi = 96;
    deviceSection = ''
      Option "DPI" "96 x 96"
    '';

    windowManager = {
      default = "i3";
      i3.enable = true;
    };

    desktopManager = {
      default = "gnome3";
      gnome3.enable = true;
    };

    displayManager = {
      lightdm = {
        enable = true;
        autoLogin = {
          enable = true;
          user = "mechetel";
        };
      };

      sessionCommands = ''
        ${xorg.xkbcomp}/bin/xkbcomp ${layout} $DISPLAY &
        ${copyq}/bin/copyq &
      '';
    };
  };
}
