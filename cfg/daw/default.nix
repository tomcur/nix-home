{ pkgs, ... }:
let
  unstable = import <unstable> { };
  master = import ../../nixpkgs { };
in {
  home.packages = with pkgs; [
    # Generic LV2
    jalv
    lilv
    # Plugin host
    carla
    # Synths
    zynaddsubfx
    helm
    qsynth
    ### Plugins
    # LV2
    avldrums-lv2
    drumkv1
    fmsynth
    # DSSI
    xsynth_dssi
    # Collections
    zam-plugins
    # Music programming language
    supercollider
    ### DAW
    ardour
  ]) ++ [
    # Wine VST bridge
    # (master.airwave.override {
    #   qt5 = pkgs.qt5;
    #   # libX11 = pkgs.libX11;
    #   wine = pkgs.wine;
    # })
    (master.airwave.override {
      qt5 = pkgs.qt5;
    })
    # Use latest renoise, with stable libjack2 version.
    (master.renoise.override {
      libjack2 = pkgs.libjack2;
      releasePath = ~/music-production/renoise/rns_322_linux_x86_64.tar.gz;
    })
  ];
}
