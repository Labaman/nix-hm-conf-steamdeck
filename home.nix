{ config, lib, pkgs, nixgl, ... }:

{

  nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    installScripts = [ "mesa" ];
  };

  home.username = "deck";
  home.homeDirectory = "/home/deck";

  home.stateVersion = "25.05"; # Please read the new release comment before changing.

  targets.genericLinux.enable = true;
  xdg.enable = true;

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

  programs.zsh ={
    enable = true;
    enableCompletion = true;
    autosuggestion.enable =true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
    };

    history.size = 10000;
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
