{ pkgs, ... }: {
  # Add the channel for Nix packages
  channel = "stable-24.05";

  # We need bison, flex, and gcc to build our language compiler/interpreter.
  # We also add vsce to package and install our custom extension.
  packages = [
    pkgs.bison
    pkgs.flex
    pkgs.gcc
    pkgs.pkg-config  # Add pkg-config to the list of packages
    pkgs.vsce  # The official extension packaging tool
    pkgs.bash  # Shell for running scripts
  ];

  idx = {
    # We only list pre-built extensions from the marketplace here.
    # Our custom extension will be installed via the onStart hook.
    extensions = [
      # Add any pre-built extensions here
    ];
  };
}