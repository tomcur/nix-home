{ config, pkgs, ... }:
let
  unstable = import <unstable> { };
  master = import ./nixpkgs { };
in
{
  # Common packages.
  home.packages = [
    (import ./my-programs/brightness-control)
    (import ./my-programs/volume-control)
    (import ./my-programs/thingshare)
    (import ./my-programs/extract)
    (pkgs.callPackage ./my-programs/paper {
      buildPythonPackage = pkgs.python3Packages.buildPythonPackage;
    })
  ] ++ (with pkgs; [
    # Font tools.
    gnome3.gucharmap
    # Tools.
    gnome3.gnome-system-monitor
    libnotify
    filelight
    ark
    calc
    leafpad
    transmission-gtk
    # Documents.
    nomacs
    okular
    zathura
    libreoffice
    # Cloud.
    seafile-client
    # Compiling.
    gcc
    gnumake
    # Debugging.
    ltrace
    gdb
    lldb
    gdbgui
    # TeX.
    (texlive.combine {
      inherit (texlive)
        amsmath# Math
        amsfonts# Math
        logreq# Automation, necessary for biblatex
        biblatex biblatex-ieee# References
        # psfonts # textcomp
        cm-super scheme-small apacite floatflt wrapfig# Figures
        enumitem courier# Font
        hyperref capt-of;
    })
    biber # For LaTeX.
  ]) ++ (with unstable.pkgs; [
    # Fuzzy finder.
    # fzf
    # Dotfiles manager.
    yadm
    # Editor.
    # The basics.
    firefox
    chromium
    thunderbird
    # Tools.
    direnv
    nox
    ripgrep
    # Password manager.
    keepassxc
    # File formatting.
    nixpkgs-fmt
    (python3.withPackages (python-packages: with python-packages; [ numpy ]))
    # Chat.
    discord
    # Music.
    spotify
  ]) ++ (with master.pkgs; [
    # Temporarily use master version of fuzzy finder, until 0.24 is in nixos-unstable
    fzf
    # Databases.
    dbeaver
  ]);

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
      "text/plain" = [ "nvim-qt.desktop" ];
      "text/html" = [ "firefox.desktop" ];
      "application/octet-stream" = [ "firefox.desktop" ];
      "application/pdf" = [ "zathura.desktop" ];
      "image/svg+xml" = [ "org.nomacs.ImageLounge.desktop" ];
      "image/png" = [ "org.nomacs.ImageLounge.desktop" ];
      "image/tiff" = [ "org.nomacs.ImageLounge.desktop" ];
      "image/gif" = [ "org.nomacs.ImageLounge.desktop" ];
      "image/jpeg" = [ "org.nomacs.ImageLounge.desktop" ];
      "image/bmp" = [ "org.nomacs.ImageLounge.desktop" ];
      "video/mp4" = [ "mpv.desktop" ];
      "video/mpeg" = [ "mpv.desktop" ];
      "video/mkv" = [ "mpv.desktop" ];
      "video/flv" = [ "mpv.desktop" ];
      "audio/aac" = [ "mpv.desktop" ];
      "audio/ac3" = [ "mpv.desktop" ];
      "audio/mp4" = [ "mpv.desktop" ];
      "audio/mpeg" = [ "mpv.desktop" ];
      "audio/ogg" = [ "mpv.desktop" ];
      "audio/vorbis" = [ "mpv.desktop" ];
      "audio/wav" = [ "mpv.desktop" ];
      "audio/x-wav" = [ "mpv.desktop" ];
      "audio/mp3" = [ "mpv.desktop" ];
      "audio/x-mp3" = [ "mpv.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "x-scheme-handler/about" = [ "firefox.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      "x-scheme-handler/magnet" = [ "deluge.desktop" ];
    };
    associations.added = {
      "image/svg+xml" = [ "nvim-qt.desktop" ];
    };
  };

  services.unclutter.enable = true;
  services.unclutter.timeout = 3;

  services.syncthing = { enable = true; };

  # Nix direnv handler.
  services.lorri = { enable = true; };

  programs.mpv = {
    enable = true;
    config = {
      # OSD.
      "--osd-on-seek" = "msg-bar";
      # Fuzzy sub name matching for autoload.
      sub-auto = "fuzzy";
    };

    bindings = {
      MBTN_LEFT = "cycle pause";
      WHEEL_UP = "add volume 2";
      WHEEL_DOWN = "add volume -2";
    };
  };

  # A systemd target to hook other units onto.
  # This is supposed to run when the window manager has started.
  systemd.user.targets.window-manager = {
    Unit = {
      PartOf = [ "graphical-session.target" ];
      Description = "window manager";
    };
  };

  systemd.user.sessionVariables = config.home.sessionVariables;

  imports = [
    ./cfg/picom
    ./cfg/alacritty
    ./cfg/nvim
    ./cfg/vscode
    ./cfg/gtk.nix
    ./cfg/xresources
    ./cfg/dunst.nix
    ./cfg/redshift
    ./cfg/rofi
  ];
}
