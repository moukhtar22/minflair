import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Core
import qs.Core.Services
import qs.Modules.Bar
import qs.Modules.Bar.Widgets.MainPanel
import qs.Modules.Bar.Widgets.SystemTray
import qs.Modules.ControlCenter.Widgets.NotificationCenter
import qs.Modules.ControlCenter.Widgets.PerformanceWidget
import qs.Modules.ControlCenter.Widgets.QuickSettings
import qs.Modules.PowerMenu

Scope {
    id: barScope

    required property var notificationService

    PanelWindow {
        id: exclusionWindow

        readonly property int barMarginTop: 8
        readonly property int barHeight: 48

        color: "transparent"
        implicitWidth: 1
        implicitHeight: barMarginTop + barHeight
        anchors.top: true
        anchors.left: true
        anchors.right: true

        mask: Region {
        }

    }

    PanelWindow {
        id: barWindow

        readonly property int barHeight: exclusionWindow.barHeight
        readonly property int barMarginTop: exclusionWindow.barMarginTop
        readonly property int barMarginSide: 8
        readonly property int popupStartY: barMarginTop + barHeight

        color: "transparent"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        focusable: false
        visible: SettingsService.settingsLoaded

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Bar {
            id: barStrip

            notificationService: barScope.notificationService
            mainPanelWidget: mainPanel
            batteryWidgetRef: batteryWidget
            quickSettingsRef: quickSettings
            notificationCenterRef: notificationCenter
            systemTrayRef: systemTray
            powerMenuRef: powerMenu
            x: barWindow.barMarginSide
            y: barWindow.barMarginTop
            width: barWindow.width - barWindow.barMarginSide * 2
            height: barWindow.barHeight
        }

        MainPanel {
            id: mainPanel

            popupId: "dashboard"
            x: (barWindow.width - implicitWidth) / 2
            y: barWindow.popupStartY
        }

        BatteryWidget {
            id: batteryWidget

            popupId: "batteryWidget"
            x: barWindow.width - implicitWidth - barWindow.barMarginSide
            y: barWindow.popupStartY
        }

        QuickSettings {
            id: quickSettings

            popupId: "quickSettings"
            x: barWindow.width - implicitWidth - barWindow.barMarginSide
            y: barWindow.popupStartY
        }

        NotificationCenter {
            id: notificationCenter

            notificationService: barScope.notificationService
            popupId: "notificationCenter"
            x: barWindow.width - implicitWidth - barWindow.barMarginSide
            y: barWindow.popupStartY
        }

        SystemTray {
            id: systemTray

            popupId: "systemTray"
            x: barWindow.width - implicitWidth - barWindow.barMarginSide
            y: barWindow.popupStartY
        }

        PowerMenu {
            id: powerMenu

            popupId: "powerMenu"
            x: barWindow.width - implicitWidth - barWindow.barMarginSide
            y: barWindow.popupStartY
        }

    }

}
