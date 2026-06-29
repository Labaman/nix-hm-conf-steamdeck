{ config, lib, pkgs, nixgl, ... }:

# Minimal Home Manager base for Steam Deck (SteamOS, non-NixOS).
# Solves only SteamDeck-specific issues; add your own programs/options below.

let
  # Keep Flatpak first (set by /etc/profile -> flatpak.sh), append Nix+system.
  xdgDataDirsAppend =
    "\${XDG_DATA_DIRS:+\$XDG_DATA_DIRS:}${lib.concatStringsSep ":" config.xdg.systemDirs.data}";

  # POSIX dedup, keep-first, order preserved (works in zsh/bash and fish via babelfish).
  dedupXdgDataDirs = ''
    XDG_DATA_DIRS="$(printf '%s' "$XDG_DATA_DIRS" | awk -v RS=: -v ORS=: '!a[$0]++' | sed 's/:$//')"
    export XDG_DATA_DIRS
  '';
in
{
  home.username = "deck";
  home.homeDirectory = "/home/deck";
  home.stateVersion = "26.05";

  # Required on non-NixOS.
  targets.genericLinux.enable = true;
  xdg.enable = true;

  # nixGL: GPU drivers for Nix GUI apps (Deck = AMD). mesa = OpenGL, vulkan = RADV.
  # Use: home.packages = [ (config.lib.nixGL.wrap pkgs.<app>) ];  or  nixGLMesa <app>
  targets.genericLinux.nixGL = {
    packages = nixgl.packages;
    defaultWrapper = "mesa";
    vulkan.enable = true;
    installScripts = [ "mesa" ];
  };

  # XDG_DATA_DIRS order fix: keep Flatpak ahead of the SteamOS "Install Firefox"
  # stub in the KDE menu (HM #8076 / #9356). Overrides prepend -> append.
  home.sessionVariables.XDG_DATA_DIRS = lib.mkForce xdgDataDirsAppend;
  systemd.user.sessionVariables.XDG_DATA_DIRS = lib.mkForce xdgDataDirsAppend;
  # Dedup: one source for zsh/bash/fish, plus .bashrc for genericLinux's nix.sh re-source.
  home.sessionVariablesExtra = lib.mkAfter dedupXdgDataDirs;
  programs.bash.initExtra = lib.mkAfter dedupXdgDataDirs;

  # Native Wayland for Nix GUI apps (SteamOS 3.8).
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
  };

  # Required: a managed shell sources hm-session-vars.sh (the fixes above) into the
  # session. Deck's default login shell is bash; use programs.zsh instead if yours is zsh.
  programs.bash.enable = true;

  # Add your own here, e.g.:
  #   programs.git = { enable = true; userName = "..."; userEmail = "..."; };
  #   programs.starship.enable = true;
  #   home.packages = with pkgs; [ ripgrep fd ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # programs.git makes ~/.config/git/config a read-only symlink into the Nix store.
  # Tools that call `git config --global` during setup (EmuDeck, rustup, etc.) fail with
  # "could not lock config file ... Permission denied". Git writes --global to ~/.gitconfig
  # when that file exists, falling back to the XDG path otherwise. Ensuring a writable
  # ~/.gitconfig redirects those writes there; the managed config remains read-only
  # and is still read by git (it checks both files).
  home.activation.ensureMutableGitconfig =
    lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      if [ ! -e "$HOME/.gitconfig" ]; then
        $DRY_RUN_CMD touch "$HOME/.gitconfig"
      fi
    '';
}
