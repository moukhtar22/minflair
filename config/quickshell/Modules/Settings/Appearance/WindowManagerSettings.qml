import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Core
import qs.Core.Components
import qs.Core.Services
import qs.Modules.Settings.Components

SettingContainer {
    id: root

    SettingHeader {
        title: "Window"
    }

    SettingGroup {
        ColumnLayout {
            spacing: Constants.sizeLg

            SettingSpinBox {
                label: "Window Rounding"
                from: 0
                to: 30
                stepSize: 1
                value: HyprlandService.hyprRounding
                defaultValue: 16
                suffix: "px"
                onMoved: (val) => {
                    HyprlandService.hyprRounding = Math.round(val);
                }
            }

            SettingSpinBox {
                label: "Global Opacity"
                description: "Transparency of windows and shell"
                from: 50
                to: 100
                stepSize: 5
                value: HyprlandService.hyprActiveOpacity
                defaultValue: 100
                suffix: "%"
                onMoved: (val) => {
                    let intVal = Math.round(val);
                    HyprlandService.hyprActiveOpacity = intVal;
                    HyprlandService.hyprInactiveOpacity = intVal;
                    HyprlandService.applyHyprlandSettings();
                    Theme.bgOpacity = intVal / 100;
                    Theme.saveScheme();
                }
            }

        }

        ColumnLayout {
            spacing: Constants.sizeLg

            SettingSpinBox {
                label: "Gaps In"
                from: 0
                to: 20
                stepSize: 1
                value: HyprlandService.hyprGapsIn
                defaultValue: 4
                suffix: "px"
                onMoved: (val) => {
                    HyprlandService.hyprGapsIn = Math.round(val);
                }
            }

            SettingSpinBox {
                label: "Gaps Out"
                from: 0
                to: 40
                stepSize: 1
                value: HyprlandService.hyprGapsOut
                defaultValue: 8
                suffix: "px"
                onMoved: (val) => {
                    HyprlandService.hyprGapsOut = Math.round(val);
                }
            }

        }

        SettingToggle {
            id: blurToggle

            label: "Enable Window & Panel Blur"
            onCheckedChanged: {
                if (checked !== HyprlandService.hyprBlur)
                    HyprlandService.hyprBlur = checked;

            }

            Binding on checked {
                value: HyprlandService.hyprBlur
            }

        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Constants.sizeMd
            enabled: HyprlandService.hyprBlur
            opacity: enabled ? 1 : 0.5

            SettingSpinBox {
                label: "Blur Size"
                from: 1
                to: 15
                stepSize: 1
                value: HyprlandService.hyprBlurSize
                defaultValue: 6
                onMoved: (val) => {
                    HyprlandService.hyprBlurSize = Math.round(val);
                }
            }

            SettingSpinBox {
                label: "Blur Passes"
                from: 1
                to: 10
                stepSize: 1
                value: HyprlandService.hyprBlurPasses
                defaultValue: 4
                onMoved: (val) => {
                    HyprlandService.hyprBlurPasses = Math.round(val);
                }
            }

        }

        ThemedButton {
            Layout.alignment: Qt.AlignRight
            disabled: !(!HyprlandService.hyprBlur || HyprlandService.hyprRounding !== 16 || HyprlandService.hyprActiveOpacity !== 100 || HyprlandService.hyprInactiveOpacity !== 100 || HyprlandService.hyprBlurSize !== 6 || HyprlandService.hyprBlurPasses !== 4 || HyprlandService.hyprGapsIn !== 4 || HyprlandService.hyprGapsOut !== 8)
            text: "Restore Defaults"
            onClicked: {
                HyprlandService.hyprBlur = true;
                HyprlandService.hyprRounding = 16;
                HyprlandService.hyprActiveOpacity = 100;
                HyprlandService.hyprInactiveOpacity = 100;
                HyprlandService.hyprBlurSize = 6;
                HyprlandService.hyprBlurPasses = 4;
                HyprlandService.hyprGapsIn = 4;
                HyprlandService.hyprGapsOut = 8;
                Theme.bgOpacity = 1;
                Theme.saveScheme();
            }
        }

    }

}
