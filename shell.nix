{ pkgs ? import <nixpkgs> { } }:


with pkgs.lib;

let
  gcc = pkgs.gcc-arm-embedded; #pkgsCross.arm-embedded.buildPackages.gcc;
  binutils = pkgs.pkgsCross.arm-embedded.buildPackages.binutils;
  toolchain = pkgs.buildEnv {
    name = "arm-toolchain";
    paths = [ gcc binutils ];
  };
in
pkgs.mkShell rec {
  buildInputs =
    [
      gcc
      binutils
    ] ++
    (with pkgs; [
      stdenv.cc.cc.lib
      ninja
      which
      git
      cmake
      dtc
      gperf
      docutils
      openocd
    ])++
    (with pkgs.python3Packages; [
      west
      wheel
      breathe
      sphinx
      sphinx_rtd_theme
      pyyaml
      ply
      pyelftools
      pyserial
      pykwalify
      colorama
      pillow
      intelhex
      pytest
      gcovr
    ]);

  shellHook = ''
    if [[ ! -d .west ]]; then
      west init
      # west espressif install
    endif
    west update
    # west espressif update
  '';

  LD_LIBRARY_PATH = "${makeLibraryPath buildInputs}";

  #ZEPHYR_TOOLCHAIN_VARIANT="espressif";
  #ESPRESSIF_TOOLCHAIN_PATH="~/.espressif/tools/xtensa-esp32-elf/esp-2020r3-8.4.0/xtensa-esp32-elf";
  #PATH="$PATH:${ESPRESSIF_TOOLCHAIN_PATH}/bin";

  ZEPHYR_TOOLCHAIN_VARIANT = "gnuarmemb";
  GNUARMEMB_TOOLCHAIN_PATH = toolchain;

  # ZEPHYR_TOOLCHAIN_VARIANT = "zephyr";
}
