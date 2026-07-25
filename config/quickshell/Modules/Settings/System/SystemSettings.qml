import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Core
import qs.Core.Components
import qs.Core.Services
import qs.Modules.Settings.Components

SettingContainer {
    id: systemRoot

    Timer {
        id: reloadTimer

        interval: 300
        repeat: false
        onTriggered: Quickshell.reload()
    }

    Process {
        id: resetSettingsProcLocal

        command: ["sh", "-c", "rm -f ~/.cache/quickshell/settings_prefs.json ~/.cache/quickshell/colorscheme.json ~/.cache/quickshell/wallpaper_colorscheme.json"]
    }

    Process {
        id: setHyprlandOptionProcLocal

        property string category: ""
        property string option: ""
        property string value: ""

        function setKeyword(cat, opt, val) {
            category = cat;
            option = opt;
            value = val || "";
            running = false;
            running = true;
        }

        command: ["hyprctl", category, option, value]
    }

    Process {
        id: restartQuickshellProc

        command: ["sh", "-c", "nohup sh -c 'sleep 0.3 && quickshell -d' &>/dev/null & killall quickshell"]
    }

    SystemInfo {
        Layout.fillWidth: true
    }

    SettingHeader {
        title: "Danger Zone"
    }

    SettingGroup {
        RowLayout {
            spacing: Constants.sizeLg
            Layout.fillWidth: true

            ThemedButton {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                text: "Restart Quickshell"
                onClicked: {
                    restartQuickshellProc.running = false;
                    restartQuickshellProc.running = true;
                }
            }

            ThemedButton {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                text: "Reset Settings"
                onClicked: {
                    resetSettingsProcLocal.running = false;
                    resetSettingsProcLocal.running = true;
                    reloadTimer.start();
                }
            }

            ThemedButton {
                Layout.fillWidth: true
                Layout.preferredWidth: 1
                textColor: Theme.accentComplementary
                text: "Exit Hyprland"
                onClicked: {
                    setHyprlandOptionProcLocal.setKeyword("dispatch", "exit");
                }
            }

        }

    }

}
