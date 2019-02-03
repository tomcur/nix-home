{ config, pkgs, ... }:

{
  # Common packages.
  home.packages = with pkgs; [
    (import ./my-programs/volume-control)
    (import ./my-programs/thingshare)
    # Dotfiles manager.
    yadm
    # The basics.
    firefox
    thunderbird
    # Cloud.
    seafile-client
    # Tools.
    direnv
    libnotify
    # Documents.
    nomacs
    okular
    zathura
    libreoffice
    (
      python3.withPackages (
        python-packages: with python-packages; [
          numpy
        ]
      )
    )
    (
      texlive.combine {
        inherit (pkgs.texlive)
          scheme-small
          apacite
          floatflt wrapfig # Figures
          enumitem
          courier # Font
        ;
      }
    )
  ];

  imports = [
    ./cfg/xresources.nix
    ./cfg/dunst.nix
    ./cfg/polybar
  ];
}
