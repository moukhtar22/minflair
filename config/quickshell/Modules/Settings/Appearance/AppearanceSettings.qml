import Qt5Compat.GraphicalEffects
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
    id: appearanceRoot

    property bool showingDark: true

    scrollable: true
    onShowingDarkChanged: {
        if (!Theme.generateFromWallpaper) {
            let t = Theme.themes[0];
            let scheme = showingDark ? t.dark : t.light;
            Theme.applyScheme(scheme);
        }
    }
    Component.onCompleted: {
        let brightness = Theme.bg.r * 0.299 + Theme.bg.g * 0.587 + Theme.bg.b * 0.114;
        showingDark = (brightness <= 0.5);
    }

    Connections {
        function onBgChanged() {
            let brightness = Theme.bg.r * 0.299 + Theme.bg.g * 0.587 + Theme.bg.b * 0.114;
            appearanceRoot.showingDark = (brightness <= 0.5);
        }

        target: Theme
    }

    SettingHeader {
        title: "Interface Settings"
    }

    SettingGroup {
        SettingSpinBox {
            label: "Animation Speed"
            description: "Control UI transition and fade speed"
            from: 0
            to: 2
            stepSize: 0.1
            value: HyprlandService.enableAnimations ? HyprlandService.animationSpeedFactor : 0
            suffix: "x"
            decimals: 1
            allowOff: true
            offText: "Off"
            onMoved: (val) => {
                if (val <= 0.001) {
                    HyprlandService.enableAnimations = false;
                } else {
                    if (!HyprlandService.enableAnimations)
                        HyprlandService.enableAnimations = true;

                    HyprlandService.animationSpeedFactor = Number(val.toFixed(1));
                }
            }
        }

    }

    SettingHeader {
        title: "Theme Settings"
    }

    SettingGroup {
        SettingToggle {
            id: wpColorsToggle

            Layout.fillWidth: true
            label: "Generate Theme from Wallpaper"
            onCheckedChanged: {
                if (checked) {
                    if (!Theme.generateFromWallpaper) {
                        Theme.generateFromWallpaper = true;
                        Theme.saveScheme();
                        if (WallpaperManager.currentWallpaperPath !== "")
                            Theme.generateTheme(WallpaperManager.currentWallpaperPath);

                    }
                } else {
                    if (Theme.generateFromWallpaper) {
                        Theme.generateFromWallpaper = false;
                        let t = Theme.themes[0];
                        let scheme = appearanceRoot.showingDark ? t.dark : t.light;
                        Theme.applyScheme(scheme);
                    }
                }
            }

            Binding {
                target: wpColorsToggle
                property: "checked"
                value: Theme.generateFromWallpaper
            }

        }

        SettingToggle {
            id: darkToggle

            Layout.fillWidth: true
            label: "Enable Dark Mode"
            enabled: !Theme.generateFromWallpaper
            onCheckedChanged: {
                if (checked !== appearanceRoot.showingDark)
                    appearanceRoot.showingDark = checked;

            }

            Binding {
                target: darkToggle
                property: "checked"
                value: appearanceRoot.showingDark
            }

        }

    }

    SettingHeader {
        title: "Wallpaper Settings"
    }

    SettingGroup {
        SettingToggle {
            id: autoShuffleToggle

            label: "Auto-shuffle Wallpapers"
            onCheckedChanged: {
                if (checked !== HyprlandService.wpAutoShuffle)
                    HyprlandService.wpAutoShuffle = checked;

            }

            Binding {
                target: autoShuffleToggle
                property: "checked"
                value: HyprlandService.wpAutoShuffle
            }

        }

        SettingSpinBox {
            enabled: HyprlandService.wpAutoShuffle
            opacity: enabled ? 1 : 0.5
            label: "Shuffle Interval"
            from: 1
            to: 60
            stepSize: 1
            value: HyprlandService.wpShuffleInterval
            suffix: " min"
            decimals: 0
            onMoved: (val) => {
                HyprlandService.wpShuffleInterval = Math.round(val);
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Constants.sizeLg
            opacity: SystemInfoService.powerProfile === "power-saver" ? 0.4 : 1
            enabled: SystemInfoService.powerProfile !== "power-saver"

            SettingSelect {
                label: "Transition Type"
                model: ["none", "grow", "fade", "wipe", "wave", "random"]
                currentIndex: {
                    if (!HyprlandService.wpEnableTransitions)
                        return 0;

                    let idx = model.indexOf(HyprlandService.wpTransitionType);
                    return idx !== -1 ? idx : 1;
                }
                onActivated: (index) => {
                    let val = model[index];
                    if (val === "none") {
                        HyprlandService.wpEnableTransitions = false;
                    } else {
                        HyprlandService.wpEnableTransitions = true;
                        HyprlandService.wpTransitionType = val;
                    }
                }
            }

            SettingSelect {
                label: "Transition Position"
                model: ["top-left", "top", "top-right", "left", "center", "right", "bottom-left", "bottom", "bottom-right"]
                currentIndex: {
                    let idx = model.indexOf(HyprlandService.wpTransitionPos);
                    return idx !== -1 ? idx : 4;
                }
                onActivated: (index) => {
                    HyprlandService.wpTransitionPos = model[index];
                }
                enabled: HyprlandService.wpEnableTransitions && HyprlandService.wpTransitionType !== "random"
                opacity: enabled ? 1 : 0.4

                Behavior on opacity {
                    NumberAnimation {
                        duration: Constants.animFast
                    }

                }

            }

            ColumnLayout {
                spacing: Constants.sizeLg
                Layout.fillWidth: true
                enabled: HyprlandService.wpEnableTransitions
                opacity: enabled ? 1 : 0.4

                SettingSegmented {
                    label: "Transition Speed"
                    model: [{
                        "text": "Slow",
                        "value": 60
                    }, {
                        "text": "Normal",
                        "value": 120
                    }, {
                        "text": "Fast",
                        "value": 180
                    }, {
                        "text": "Ultra",
                        "value": 240
                    }]
                    currentValue: HyprlandService.wpTransitionStep
                    onActivated: (val) => {
                        HyprlandService.wpTransitionStep = val;
                    }
                }

                SettingSegmented {
                    label: "Transition Frame Rate"
                    model: [{
                        "text": "30",
                        "value": 30
                    }, {
                        "text": "60",
                        "value": 60
                    }, {
                        "text": "120",
                        "value": 120
                    }, {
                        "text": "144",
                        "value": 144
                    }]
                    currentValue: HyprlandService.wpTransitionFps
                    onActivated: (val) => {
                        HyprlandService.wpTransitionFps = val;
                    }
                }

                ThemedSlider {
                    label: "Transition Angle"
                    from: 0
                    to: 360
                    stepSize: 10
                    value: HyprlandService.wpTransitionAngle
                    suffix: "°"
                    decimals: 0
                    visible: HyprlandService.wpTransitionType === "wipe" || HyprlandService.wpTransitionType === "wave"
                    onMoved: (val) => {
                        HyprlandService.wpTransitionAngle = Math.round(val);
                    }
                }

                Behavior on opacity {
                    NumberAnimation {
                        duration: Constants.animFast
                    }

                }

            }

            Behavior on opacity {
                NumberAnimation {
                    duration: Constants.animNormal
                }

            }

        }

    }

    ThemedButton {
        Layout.alignment: Qt.AlignRight
        disabled: !(!HyprlandService.wpEnableTransitions || HyprlandService.wpTransitionType !== "grow" || HyprlandService.wpTransitionStep !== 120 || HyprlandService.wpTransitionPos !== "center" || HyprlandService.wpTransitionFps !== 60 || HyprlandService.wpTransitionAngle !== 30 || HyprlandService.wpAutoShuffle || HyprlandService.wpShuffleInterval !== 10)
        text: "Restore Defaults"
        onClicked: {
            HyprlandService.wpEnableTransitions = true;
            HyprlandService.wpTransitionType = "grow";
            HyprlandService.wpTransitionStep = 120;
            HyprlandService.wpTransitionPos = "center";
            HyprlandService.wpTransitionFps = 60;
            HyprlandService.wpTransitionAngle = 30;
            HyprlandService.wpAutoShuffle = false;
            HyprlandService.wpShuffleInterval = 10;
        }
    }

}
