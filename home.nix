{ config, lib, pkgs, nixgl, ... }:

{

  nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
    vulkan.enable = true;
  };

  home.username = "deck";
  home.homeDirectory = "/home/deck";

  home.stateVersion = "25.05"; # Please read the new release comment before changing.

  targets.genericLinux.enable = true;
  xdg.enable = true;

  # Perform a menu/icon update and shell rehash without requiring a relogin
  home.activation = {
    refreshPlasma6 = lib.hm.dag.entryAfter [ "linkGeneration" "onFilesChange" ] ''
      [ -x /usr/bin/update-desktop-database ] && /usr/bin/update-desktop-database || true
    '';

    rehash-current-shell = lib.hm.dag.entryAfter [ "linkGeneration" "onFilesChange" ] ''
      s="$(readlink -f "$(/usr/bin/getent passwd "$USER" | cut -d: -f7)" 2>/dev/null || true)"
      case "$s" in
      */bash) "$s" -lc 'hash -r' ;;
      */zsh)  "$s" -lc 'rehash' ;;
      */fish) "$s" -lc 'fish_update_completions' ;;
      esac || true
    '';
  };

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [

  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {

  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
    };

    history.size = 10000;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
