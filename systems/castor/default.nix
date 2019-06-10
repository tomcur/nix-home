{ lib, pkgs, ... }:
let
  master = import ./../../nixpkgs {};
in
  {
    imports = [
      ../../common.nix
      ../../cfg/xmonad/castor.nix
      ./music.nix
    ];

    services.polybar = {
      script = ''
        MONITOR=DP-4 polybar top &
        MONITOR=DVI-D-0 polybar top &
      '';
      config."module/wlan".interface = "wlp3s0";
      config."bar/top".modules-right = "volume redshift wlan cpu memory date";
    };

    home.packages = (with pkgs;
        [
          deluge
        ]
      ) ++ (with master.pkgs;
        [
          # Games.
          steam
          steam-run
        ]
      );
  }