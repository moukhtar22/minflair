import "Components"
import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Core
import qs.Core.Components
import qs.Core.Services
import qs.Core.Windows
import qs.Modules.Settings.Appearance
import qs.Modules.Settings.General
import qs.Modules.Settings.System

AppWindow {
    id: root

    property int activeTab: 0
    property int lastTab: 0
    property int animOff: 0
    property var pageComponents: [appearanceComp, wmComp, inputComp, defaultAppsComp, githubComp, quoteSettingsComp, systemComp, updatesComp]
    property string powerProfile: SystemInfoService.powerProfile
    property string batteryStatus: SystemInfoService.batteryStatus
    property string batteryPercentage: SystemInfoService.batteryPercentage
    property string batteryEstimation: SystemInfoService.batteryEstimation

    popupId: "minflair_settings"
    windowTitle: "Minflair Settings"
    onIsOpenChanged: {
        if (isOpen) {
            if (AppState.pendingSettingsTab !== -1) {
                activeTab = AppState.pendingSettingsTab;
                AppState.pendingSettingsTab = -1;
            } else {
                activeTab = 0;
            }
        }
    }

    Connections {
        function onActiveTabChanged() {
            switchAnim.complete();
            root.animOff = 40 * (root.activeTab > root.lastTab ? 1 : -1);
            switchAnim.start();
            root.lastTab = root.activeTab;
        }

        target: root
    }

    SequentialAnimation {
        id: switchAnim

        NumberAnimation {
            target: pageLoader
            property: "opacity"
            to: 0
            duration: Constants.animFast
            easing.type: Easing.InQuad
        }

        ScriptAction {
            script: {
                pageLoader.sourceComponent = root.pageComponents[root.activeTab];
            }
        }

        PropertyAction {
            target: pageLoader
            property: "anchors.topMargin"
            value: root.animOff
        }

        PropertyAction {
            target: pageLoader
            property: "anchors.bottomMargin"
            value: -root.animOff
        }

        PropertyAction {
            target: pageLoader
            property: "scale"
            value: 0.95
        }

        ParallelAnimation {
            NumberAnimation {
                target: pageLoader
                property: "opacity"
                from: 0
                to: 1
                duration: Constants.animNormal
                easing.type: Easing.OutQuint
            }

            NumberAnimation {
                target: pageLoader
                properties: "anchors.topMargin,anchors.bottomMargin"
                to: 0
                duration: Constants.animSlow
                easing.type: Easing.OutBack
            }

            NumberAnimation {
                target: pageLoader
                property: "scale"
                to: 1
                duration: Constants.animSlow
                easing.type: Easing.OutBack
            }

        }

    }

    Process {
        id: queryHyprlandProc

        command: ["sh", "-c", "echo \"{\\\"blur\\\":$(hyprctl getoption decoration:blur:enabled -j | jq .int),\\\"rounding\\\":$(hyprctl getoption decoration:rounding -j | jq .int),\\\"active_opacity\\\":$(hyprctl getoption decoration:active_opacity -j | jq .float),\\\"inactive_opacity\\\":$(hyprctl getoption decoration:inactive_opacity -j | jq .float),\\\"blur_size\\\":$(hyprctl getoption decoration:blur:size -j | jq .int),\\\"blur_passes\\\":$(hyprctl getoption decoration:blur:passes -j | jq .int),\\\"gaps_in\\\":\\\"$(hyprctl getoption general:gaps_in -j | jq -r .custom)\\\",\\\"gaps_out\\\":\\\"$(hyprctl getoption general:gaps_out -j | jq -r .custom)\\\"}\""]

        stdout: SplitParser {
            onRead: (data) => {
                if (data && data.trim() !== "") {
                    try {
                        let opts = JSON.parse(data.trim());
                        HyprlandService.hyprBlur = opts.blur === 1;
                        HyprlandService.hyprRounding = opts.rounding;
                        HyprlandService.hyprActiveOpacity = Math.round(opts.active_opacity * 100);
                        HyprlandService.hyprInactiveOpacity = Math.round(opts.inactive_opacity * 100);
                        HyprlandService.hyprBlurSize = opts.blur_size;
                        HyprlandService.hyprBlurPasses = opts.blur_passes;
                        let gapsInStr = opts.gaps_in || "4";
                        HyprlandService.hyprGapsIn = parseInt(gapsInStr.split(" ")[0]) || 4;
                        let gapsOutStr = opts.gaps_out || "8";
                        HyprlandService.hyprGapsOut = parseInt(gapsOutStr.split(" ")[0]) || 8;
                    } catch (e) {
                        console.error("Error parsing Hyprland options: " + e);
                    }
                }
            }
        }

    }

    Process {
        id: resetSettingsProc

        command: ["sh", "-c", "rm -f ~/.cache/quickshell/settings_prefs.json ~/.cache/quickshell/colorscheme.json ~/.cache/quickshell/wallpaper_colorscheme.json"]
    }

    Process {
        id: clearClipboardProc

        command: ["cliphist", "wipe"]
    }

    Process {
        id: wipeClipboardImagesProc

        command: ["sh", "-c", "rm -rf /tmp/quickshell-clipboard/*"]
    }

    Timer {
        id: reloadTimer

        interval: 300
        repeat: false
        onTriggered: Quickshell.reload()
    }

    Component {
        id: appearanceComp

        AppearanceSettings {
            anchors.fill: parent
        }

    }

    Component {
        id: wmComp

        WindowManagerSettings {
            anchors.fill: parent
        }

    }

    Component {
        id: inputComp

        InputSettings {
            anchors.fill: parent
        }

    }

    Component {
        id: defaultAppsComp

        DefaultAppsSettings {
            anchors.fill: parent
        }

    }

    Component {
        id: githubComp

        ServicesSettings {
            anchors.fill: parent
        }

    }

    Component {
        id: quoteSettingsComp

        QuoteSettings {
            anchors.fill: parent
        }

    }

    Component {
        id: systemComp

        SystemSettings {
            anchors.fill: parent
        }

    }

    Component {
        id: updatesComp

        UpdatesSettings {
            anchors.fill: parent
        }

    }

    RowLayout {
        Layout.fillWidth: true
        Layout.fillHeight: true
        spacing: Constants.sizeLg

        SettingsSidebar {
            Layout.fillHeight: true
            Layout.preferredWidth: 260
            activeTab: root.activeTab
            onTabClicked: (index) => {
                root.activeTab = index;
            }
        }

        Divider {
            vertical: true
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true

            Loader {
                id: pageLoader

                anchors.fill: parent
                sourceComponent: appearanceComp
            }

        }

    }

}
