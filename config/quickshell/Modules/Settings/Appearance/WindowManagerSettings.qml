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
                to: 40
                stepSize: 1
                value: HyprlandService.hyprRounding
                defaultValue: 32
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

            SettingSpinBox {
                label: "Border Size"
                from: 0
                to: 10
                stepSize: 1
                value: HyprlandService.hyprBorderSize
                defaultValue: 2
                suffix: "px"
                onMoved: (val) => {
                    HyprlandService.hyprBorderSize = Math.round(val);
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

        SettingToggle {
            id: shadowToggle

            label: "Enable Window Shadows"
            onCheckedChanged: {
                if (checked !== HyprlandService.hyprShadow)
                    HyprlandService.hyprShadow = checked;

            }

            Binding on checked {
                value: HyprlandService.hyprShadow
            }

        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: Constants.sizeMd
            enabled: HyprlandService.hyprShadow
            opacity: enabled ? 1 : 0.5

            SettingSpinBox {
                label: "Shadow Range"
                from: 1
                to: 40
                stepSize: 1
                value: HyprlandService.hyprShadowRange
                defaultValue: 4
                suffix: "px"
                onMoved: (val) => {
                    HyprlandService.hyprShadowRange = Math.round(val);
                }
            }

            SettingSpinBox {
                label: "Shadow Render Power"
                from: 1
                to: 4
                stepSize: 1
                value: HyprlandService.hyprShadowRenderPower
                defaultValue: 3
                onMoved: (val) => {
                    HyprlandService.hyprShadowRenderPower = Math.round(val);
                }
            }

        }

        ThemedButton {
            Layout.alignment: Qt.AlignRight
            disabled: !(!HyprlandService.hyprBlur || HyprlandService.hyprRounding !== 32 || HyprlandService.hyprActiveOpacity !== 100 || HyprlandService.hyprInactiveOpacity !== 100 || HyprlandService.hyprBlurSize !== 6 || HyprlandService.hyprBlurPasses !== 4 || HyprlandService.hyprGapsIn !== 4 || HyprlandService.hyprGapsOut !== 8 || HyprlandService.hyprBorderSize !== 2 || HyprlandService.hyprShadow || HyprlandService.hyprShadowRange !== 4 || HyprlandService.hyprShadowRenderPower !== 3)
            text: "Restore Defaults"
            onClicked: {
                HyprlandService.hyprBlur = true;
                HyprlandService.hyprRounding = 32;
                HyprlandService.hyprActiveOpacity = 100;
                HyprlandService.hyprInactiveOpacity = 100;
                HyprlandService.hyprBlurSize = 6;
                HyprlandService.hyprBlurPasses = 4;
                HyprlandService.hyprGapsIn = 4;
                HyprlandService.hyprGapsOut = 8;
                HyprlandService.hyprBorderSize = 2;
                HyprlandService.hyprShadow = false;
                HyprlandService.hyprShadowRange = 4;
                HyprlandService.hyprShadowRenderPower = 3;
                Theme.bgOpacity = 1;
                Theme.saveScheme();
            }
        }

    }

}
