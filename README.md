# nix-hm-conf-steamdeck

Minimal [Home Manager](https://github.com/nix-community/home-manager) base for Steam Deck (SteamOS, non-NixOS).

## What it fixes

| Fix | Why |
|-----|-----|
| XDG_DATA_DIRS order | Keeps Flatpak ahead of system stubs in the KDE menu (HM [#8076](https://github.com/nix-community/home-manager/issues/8076) / [#9356](https://github.com/nix-community/home-manager/pull/9356)) |
| KDE app menu rebuild | System apps vanish from launcher after `switch` without it |
| nixGL | GPU driver wrappers for Nix GUI apps (OpenGL + Vulkan/RADV) |
| Wayland | `NIXOS_OZONE_WL` + `QT_QPA_PLATFORM` for Electron/Qt apps |
| EmuDeck / rustup | Writable `~/.gitconfig` alongside HM-managed git config |

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
