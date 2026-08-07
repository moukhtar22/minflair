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
import qs.Modules.Settings.System

SettingContainer {
    id: root

    Timer {
        id: reloadTimer

        interval: 300
        repeat: false
        onTriggered: Quickshell.reload()
    }

    SystemInfo {
        Layout.fillWidth: true
    }

    SettingGroup {
        title: "Input & Clipboard"
        icon: "edit"

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

    }

    SettingGroup {
        title: "Update Preferences"
        icon: "refresh"

        SettingToggle {
            label: "Auto-check System Updates"
            checked: UpdateService.packageManagerChecksEnabled
            onCheckedChanged: UpdateService.packageManagerChecksEnabled = checked
        }

        SettingSelect {
            Layout.fillWidth: true
            enabled: UpdateService.packageManagerChecksEnabled
            opacity: enabled ? 1 : 0.5
            label: "Check Interval"
            description: "Frequency of update checks"
            model: ["1 hour", "6 hours", "12 hours", "24 hours"]
            currentIndex: {
                let val = UpdateService.packageManagerCheckInterval;
                if (val === 3.6e+06)
                    return 0;

                if (val === 2.16e+07)
                    return 1;

                if (val === 4.32e+07)
                    return 2;

                if (val === 8.64e+07)
                    return 3;

                return 3;
            }
            onActivated: (index) => {
                let intervals = [3.6e+06, 2.16e+07, 4.32e+07, 8.64e+07];
                UpdateService.packageManagerCheckInterval = intervals[index];
            }
        }

    }

}
