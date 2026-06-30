# nix-hm-conf-steamdeck

Minimal [Home Manager](https://github.com/nix-community/home-manager) base for Steam Deck (SteamOS, non-NixOS).

## What's included

| Fix / Feature | Notes |
|---------------|-------|
| XDG_DATA_DIRS order | Keeps Flatpak ahead of system stubs in the KDE menu (HM [#8076](https://github.com/nix-community/home-manager/issues/8076) / [#9356](https://github.com/nix-community/home-manager/pull/9356)) |
| KDE app menu rebuild | Nix app icons appear in the launcher right after `switch` without a relogin (icons may be blank on first switch, but are present). Also prevents system apps from vanishing after switch. |
| nixGL | GPU driver wrappers for Nix GUI apps (OpenGL + Vulkan/RADV) |
| Wayland | `NIXOS_OZONE_WL` + `QT_QPA_PLATFORM` for Electron/Qt apps |
| EmuDeck / rustup | Writable `~/.gitconfig` alongside HM-managed git config |
| Starship prompt | SteamOS-style `[user@host dir] (branch)*$` — works in bash, zsh, and fish |

## Usage

Install Nix if not already installed ([NixOS/nix-installer](https://github.com/NixOS/nix-installer), auto-detects SteamOS):

```bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
```

Then:

```bash
git clone https://github.com/Labaman/nix-hm-conf-steamdeck ~/.config/home-manager
home-manager switch --flake ~/.config/home-manager#deck
```

Add your own packages and programs below the comment at the bottom of `home.nix`.

## Shell (optional)

A managed shell is required to source session variables into the graphical session.
Uncomment one of the shell blocks in `home.nix`.

| Shell | Session env coverage | Notes |
|-------|----------------------|-------|
| **bash** | login + interactive shells | SteamOS default; simplest to start with. The two `# bash only` entries in `home.nix` cover the non-interactive startup gap. |
| **zsh** | login, interactive & non-interactive | `.zshenv` is sourced for every zsh invocation, so session vars always load without any workarounds. Does not touch bash dotfiles. The `# bash only` entries in `home.nix` may be removed. |
| **fish** | login, interactive & non-interactive | Autocompletion, command suggestions, and syntax highlighting work out of the box without extra config. Does not touch bash dotfiles. The `# bash only` entries may be removed. Note: fish syntax is not POSIX/bash-compatible — bash scripts won't run directly inside fish. |

### Changing the default login shell

To use zsh or fish, switch to the **system-provided** binary — not the Nix-managed one.
This keeps login working even if Nix is later removed (both shells ship with SteamOS):

Switch to **zsh**:
```bash
chsh -s /usr/bin/zsh
```

Switch to **fish**:
```bash
chsh -s /usr/bin/fish
```

Do this **before** running `home-manager switch` with the shell module enabled.
After re-login, uncomment the corresponding shell block in `home.nix`.
