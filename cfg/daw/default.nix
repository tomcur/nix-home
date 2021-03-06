{ pkgs, ... }:
let
  systemLibOverlay = self: super: {
    libjack2 = pkgs.libjack2;
    jack2 = pkgs.jack2;
    # gtk2 = pkgs.gtk2;
    # gtk3 = pkgs.gtk3;
    # qt5 = pkgs.qt5;
    # qt5.qtbase = pkgs.qt5.qtbase;
    # # python2 = pkgs.python2;
    # # python2Packages = pkgs.python2Packages;
    # # python3 = pkgs.python3;
    # # python3Packages = pkgs.python3Packages;
  };
  unstable = import <unstable> {
    overlays = [ systemLibOverlay ];
  };
  master = import ../../nixpkgs {
    overlays = [ systemLibOverlay ];
  };
in
{
  home.packages = (with pkgs; [
    # Generic LV2
    jalv
    lilv
    # Synths
    master.surge
    helm
    qsynth
    # LV2
    avldrums-lv2
    drumkv1
    fmsynth
    # LADSPA
    autotalent
    # DSSI
    xsynth_dssi
    # Collections
    zam-plugins
    # Music programming language
    supercollider
    ### DAW
    ardour
    # Collections
    lsp-plugins
    master.distrho
    (callPackage ./harrison-ava.nix {})
  ]) ++ (with unstable; [
    # Plugin host
    vcv-rack
    (carla.override {
      # python3Packages = pkgs.python3Packages;
      # qtbase = pkgs.qt5.qtbase;
      # wrapQtAppsHook = pkgs.qt5.wrapQtAppsHook;
      # gtk2 = pkgs.gtk2;
      # gtk3 = pkgs.gtk3;
    })
  ]) ++ (with master; [
    bitwig-studio
    # Wine VST bridge
    # # (master.airwave.override {
    # #   qt5 = pkgs.qt5;
    # #   # libX11 = pkgs.libX11;
    # #   wine = pkgs.wine;
    # # })
    # (master.airwave.override {
    #   qt5 = pkgs.qt5;
    # })
    # Use latest renoise, with stable libjack2 version.
    (renoise.override {
      # libjack2 = pkgs.libjack2;
      releasePath = ~/music-production/renoise/rns_331_linux_x86_64.tar.gz;
    })
    (zynaddsubfx.override {
      guiModule = "zest";
    })
  ]);
}
