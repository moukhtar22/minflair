# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.1.0] - 2026-08-06

### Added

- System-wide font and size management via a custom settings module and Python script.
- Expanded Hyprland decoration settings, adding controls for border size and shadows.
- Modular categorized settings modules (`EffectsSettings.qml`, `IntegrationsSettings.qml`, `PersonalizationSettings.qml`, `SystemInputSettings.qml`, `WindowSettings.qml`).
- Core UI components (`GhostEmptyState.qml`, `PageTransitionView.qml`, `SearchableSidebar.qml`, `SidebarItem.qml`).
- New application and script for keybinds (`minflair-keybinds.desktop`, `toggle_minflair_keybinds.sh`).
- Scalable UI SVG icons (`apps.svg`, `hyprland.svg`, `neovim.svg`, `sparkles.svg`, etc.).
- Utility modules like `ColorUtils.qml`.

### Changed

- Refactored shell configuration by separating bar and popup surfaces.
- Performance: Enabled `mipmap` and optimized `sourceSize` for images across all modules.
- Massive refactoring of the Settings module to use the new modular submodules instead of monolithic files.
- Updated Settings components (`SettingContainer`, `SettingGroup`, `SettingSegmented`, `SettingSelect`, `SettingSpinBox`, `SettingToggle`, `SettingsSidebar`).
- Updated Python scripts (`apply_theme.py`, `generate_theme.py`, `parse_keybinds.py`).
- Updated Hyprland configurations (`autostart.lua`, `keybinds.lua`, `windowrules.lua`) and Fastfetch config.
- Minor UI tweaks in several modules (Bar, Clipboard, ControlCenter, KeybindsCheatSheet, WallpaperSelector, etc.).
- Updated `install.sh` script.

### Removed

- Deprecated `BarWindow` component.
- Monolithic legacy settings modules (`AppearanceSettings.qml`, `WindowManagerSettings.qml`, `DefaultAppsSettings.qml`, `QuoteSettings.qml`, `ServicesSettings.qml`, `SystemSettings.qml`, `UpdatesSettings.qml`).
- Deprecated battery icon SVGs.

## [1.0.7] - 2026-07-31

### Added

- Display system stats instead of hostname on the lockscreen.
- Quote categories and a dedicated quotes settings page.

### Changed

- Adjusted lockscreen font sizes and wallpaper selector colors.
- Updated project description in README.
