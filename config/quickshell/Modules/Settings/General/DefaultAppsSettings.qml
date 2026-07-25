import QtQuick
import QtQuick.Layouts
import Quickshell
import qs.Core
import qs.Core.Components
import qs.Core.Services
import qs.Modules.Settings.Components

SettingContainer {
    id: defaultAppsRoot

    readonly property var availablePlayers: {
        let list = [];
        if (SystemStats.hasSpotify)
            list.push({
            "label": "Spotify",
            "value": "spotify",
            "command": "spotify"
        });

        if (SystemStats.hasYoutubeMusic)
            list.push({
            "label": "YouTube Music",
            "value": "youtube-music",
            "command": "youtube-music"
        });

        if (SystemStats.hasKew)
            list.push({
            "label": "Kew (TUI)",
            "value": "kew",
            "command": "kitty --class kitty-kew -e kew"
        });

        list.push({
            "label": "Custom Command",
            "value": "custom",
            "command": SettingsService.musicPlayerCommand
        });
        return list;
    }

    SettingHeader {
        title: "Default Applications"
    }

    SettingGroup {
        SettingSelect {
            label: "Default Music Player"
            description: "Select which music application or TUI to launch"
            model: {
                let arr = [];
                for (let i = 0; i < defaultAppsRoot.availablePlayers.length; i++) {
                    arr.push(defaultAppsRoot.availablePlayers[i].label);
                }
                return arr;
            }
            currentIndex: {
                let val = SettingsService.musicPlayer;
                for (let i = 0; i < defaultAppsRoot.availablePlayers.length; i++) {
                    if (defaultAppsRoot.availablePlayers[i].value === val)
                        return i;

                }
                return defaultAppsRoot.availablePlayers.length - 1;
            }
            onActivated: (index) => {
                let choice = defaultAppsRoot.availablePlayers[index];
                SettingsService.musicPlayer = choice.value;
                if (choice.value !== "custom") {
                    SettingsService.musicPlayerCommand = choice.command;
                } else {
                    if (SettingsService.musicPlayerCommand === "spotify" || SettingsService.musicPlayerCommand === "youtube-music" || SettingsService.musicPlayerCommand === "kitty --class kitty-kew -e kew")
                        SettingsService.musicPlayerCommand = "";

                }
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Constants.sizeMd
            visible: SettingsService.musicPlayer === "custom" || SettingsService.musicPlayer === "kew"

            ThemedTextField {
                id: musicCmdField

                Layout.fillWidth: true
                label: "Music Launch Command"
                placeholderText: "e.g. kitty --class kitty-kew -e kew"
                text: SettingsService.musicPlayerCommand
                textField.onTextEdited: {
                    SettingsService.musicPlayerCommand = text;
                }
            }

        }

    }

}
