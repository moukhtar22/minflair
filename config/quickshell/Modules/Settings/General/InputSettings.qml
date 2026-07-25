import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import qs.Core
import qs.Core.Components
import qs.Core.Services
import qs.Modules.Settings.Components

SettingContainer {
    id: inputRoot

    SettingHeader {
        title: "Input & Clipboard"
    }

    SettingGroup {
        SettingSelect {
            label: "Keyboard Layout"
            description: "Select active layout for system input"
            model: ["English (US)", "Español (LatAm)"]
            currentIndex: HyprlandService.keyboardLayout === "latam" ? 1 : 0
            onActivated: (index) => {
                let code = index === 1 ? "latam" : "us";
                HyprlandService.keyboardLayout = code;
            }
        }

        SettingSelect {
            label: "Clipboard Max History Items"
            description: "Limit number of clipboard entries displayed"
            model: ["25 items", "50 items", "100 items", "200 items", "500 items"]
            currentIndex: {
                let items = SettingsService.clipboardMaxItems;
                if (items === 25)
                    return 0;

                if (items === 50)
                    return 1;

                if (items === 100)
                    return 2;

                if (items === 200)
                    return 3;

                if (items === 500)
                    return 4;

                return 1;
            }
            onActivated: (index) => {
                let vals = [25, 50, 100, 200, 500];
                SettingsService.clipboardMaxItems = vals[index];
            }
        }

        RowLayout {
            spacing: Constants.sizeLg

            ThemedButton {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                text: "Clear History"
                onClicked: {
                    clearClipboardProc.running = false;
                    clearClipboardProc.running = true;
                    wipeClipboardImagesProc.running = false;
                    wipeClipboardImagesProc.running = true;
                }
            }

            ThemedButton {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                text: "Wipe Image Cache"
                onClicked: {
                    wipeClipboardImagesProc.running = false;
                    wipeClipboardImagesProc.running = true;
                }
            }

        }

    }

}
