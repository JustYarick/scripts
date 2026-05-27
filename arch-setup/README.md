## Особенности

- **Omarchy-style Workflow**: Клавиатурно-ориентированное управление.
- **Модульность**: Каждый этап установки — отдельный скрипт. Можно запускать выборочно.
- **Dual-Monitor Ready**: Независимые рабочие столы для двух мониторов (1-10 и 11-20).
- **NVIDIA Safeguards**: Правильная настройка драйверов, DRM modesetting и KMS модулей.
- **Production Terminal**: Zsh + Oh My Zsh + Powerlevel10k + Tmux + Nerd Fonts.
- **Modern Suite**: Docker, Neovim (LazyVim), Ghostty, Discord (с фиксом стриминга), Chrome, Steam.

## Порядок установки

### 1. Базовая система

Установите Arch Linux через `archinstall`:

- **Profile**: Minimal (рекомендуется) или Hyprland.
- **Audio**: Pipewire.
- **Network**: NetworkManager.
- Создайте пользователя с правами sudo.

### 2. Запуск установщика YARICK

После первой загрузки в систему:

```bash
git clone <url-вашего-репозитория> arch-setup
cd arch-setup
chmod +x main.sh
./main.sh
```

### 3. Структура модулей

1. `01_mirrors.sh` — Оптимизация зеркал (reflector) и обновление.
2. `02_nvidia.sh` — Драйверы NVIDIA и фиксы для Wayland.
3. `03_aur.sh` — Установка помощника `yay`.
4. `04_hyprland.sh` — Конфиг Hyprland (модульный) и хоткеи.
5. `05_apps.sh` — Основной софт (Firefox, Telegram, Chrome и т.д.).
6. `06_docker.sh` — Настройка Docker и прав доступа.
7. `07_theme.sh` — Стилизация Waybar и Rofi.
8. `08_services.sh` — Bluetooth, Звук, Стриминг экрана.
9. `09_terminal.sh` — Идеальный Zsh, Tmux и шрифты.
10. `10_neovim.sh` — Neovim + LazyVim Starter.

## Горячие клавиши

| Клавиши | Действие |
| --- | --- |
| `Win + Enter` | Терминал (Ghostty) |
| `Win + Space` | Меню приложений (Rofi) |
| `Win + W` | Закрыть окно |
| `Win + B` | Браузер (Firefox) |
| `Win + Shift + F` | Файловый менеджер (Nautilus) |
| `Win + H/J/K/L` | Навигация (Vim-style) |
| `Win + 1...0` | Рабочие столы 1-10 (Монитор 1) |
| `Win + Alt + 1...0` | Рабочие столы 11-20 (Монитор 2) |
| `Win + Shift + 1...0` | Переместить окно на стол (Монитор 1) |
| `Win + G` | Переключить разделение окна (Togglesplit) |
| `Win + F` | Полный экран |

## Мониторы

Конфигурация мониторов находится в `~/.config/hypr/configs/monitors.conf`.
Если мониторы не определились автоматически, проверьте их имена через `hyprctl monitors` и обновите конфиг.

## После установки

- Перезагрузитесь (`reboot`).
- Запустите `nvim` для завершения установки плагинов.
- Запустите `p10k configure`, если хотите изменить вид строки терминала.
