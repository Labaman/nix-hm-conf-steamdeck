# nix-hm-conf-steamdeck

[English](README.md) | **Русский**

Минимальная база [Home Manager](https://github.com/nix-community/home-manager) для Steam Deck (SteamOS, non-NixOS).

## Что включено

| Фикс / Фича | Описание |
|-------------|----------|
| Порядок XDG_DATA_DIRS | Flatpak остаётся первым в меню KDE — без этого вместо Flatpak-приложений (Firefox и др.) открывается системный стаб «Install Firefox» (HM [#8076](https://github.com/nix-community/home-manager/issues/8076) / [#9356](https://github.com/nix-community/home-manager/pull/9356)) |
| Перестройка меню KDE | Иконки Nix-приложений появляются в лаунчере сразу после `switch`, без перезахода в сессию (при первом switch иконки могут быть пустыми, но приложения запускаются). Также предотвращает исчезновение системных приложений из меню. |
| nixGL | Обёртки GPU-драйверов для Nix GUI-приложений (OpenGL + Vulkan/RADV) |
| Wayland | `NIXOS_OZONE_WL` + `QT_QPA_PLATFORM` для Electron/Qt-приложений |
| EmuDeck / rustup | Писабельный `~/.gitconfig` рядом с управляемым HM git-конфигом |
| Промпт Starship | Стиль под дефолтный SteamOS bash: `[user@host dir] (ветка)*$` — работает в bash, zsh и fish |

## Установка

Установить Nix, если ещё не установлен ([NixOS/nix-installer](https://github.com/NixOS/nix-installer), автоматически определяет SteamOS):

```bash
curl -sSfL https://artifacts.nixos.org/nix-installer | sh -s -- install --enable-flakes
```

Затем:

```bash
git clone https://github.com/Labaman/nix-hm-conf-steamdeck ~/.config/home-manager
home-manager switch --flake ~/.config/home-manager#deck
```

Свои пакеты и программы добавляй ниже комментария в конце `home.nix`.

## Оболочка (опционально)

Управляемая оболочка нужна для того, чтобы переменные сессии (фиксы выше) попадали в графическую сессию. Раскомментируй один из блоков в `home.nix`.

| Оболочка | Покрытие переменных сессии | Примечания |
|----------|---------------------------|------------|
| **bash** | login + интерактивные шеллы | Дефолт SteamOS; проще всего начать. Две строки `# bash only` в `home.nix` закрывают пробел в non-interactive запусках. |
| **zsh** | login, интерактивный и non-interactive | `.zshenv` сорсится при каждом запуске zsh — переменные сессии загружаются всегда, без доп. костылей. Не трогает bash-дотфайлы. Строки `# bash only` можно удалить. |
| **fish** | login, интерактивный и non-interactive | Автодополнение, подсказки команд и подсветка синтаксиса работают из коробки без доп. настройки. Не трогает bash-дотфайлы. Строки `# bash only` можно удалить. Важно: fish не совместим с POSIX/bash — bash-скрипты не запустятся напрямую внутри fish. |

### Смена дефолтного логин-шелла

Для zsh или fish меняй шелл на **системный** бинарь, а не на Nix-managed — тогда логин останется рабочим даже если Nix будет удалён (оба шелла идут в комплекте с SteamOS):

Переключиться на **zsh**:
```bash
chsh -s /usr/bin/zsh
```

Переключиться на **fish**:
```bash
chsh -s /usr/bin/fish
```

Сделай это **до** запуска `home-manager switch` с включённым модулем оболочки. После перезахода в сессию раскомментируй соответствующий блок в `home.nix`.
