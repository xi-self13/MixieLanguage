{ pkgs, ... }: {
  # Add the channel for Nix packages
  channel = "stable-24.05";

  # We need bison, flex, and gcc to build our language compiler/interpreter.
  # We also add vsce to package and install our custom extension.
  packages = [
    pkgs.bison
    pkgs.flex
    pkgs.gcc
    pkgs.vsce # The official extension packaging tool
    pkgs.bash # Shell for running scripts
  ];

  idx = {
    # We only list pre-built extensions from the marketplace here.
    # Our custom extension will be installed via the onStart hook.
    extensions = [
      "ms-vscode.cpptools" # C/C++ language support
    ];

    workspace = {
      # This hook runs every time the workspace starts.
      onStart = {
        # This command compiles the C source files for the interpreter.
        compile-interpreter = ". ./.idx/scripts/compile-interpreter.sh";

        # This script packages and installs the local MixieLang extension.
        install-mixie-extension = ". ./.idx/scripts/install-extension.sh";
      };
    };
  };
}
