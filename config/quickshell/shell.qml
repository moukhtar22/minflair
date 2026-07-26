import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.SystemTray as QSSysTray
import Quickshell.Wayland
import qs.Core
import qs.Core.Components
import qs.Core.Services
import qs.Modules.Bar
import qs.Modules.Bar
import qs.Modules.Bar.Widgets.MainPanel
import qs.Modules.Bar.Widgets.SystemTray
import qs.Modules.Clipboard
import qs.Modules.ControlCenter
import qs.Modules.KeybindsCheatSheet
import qs.Modules.Launcher
import qs.Modules.LockScreen
import qs.Modules.Notifications
import qs.Modules.PackageManager
import qs.Modules.PowerMenu
import qs.Modules.Screenshot
import qs.Modules.Settings
import qs.Modules.WallpaperSelector
import qs.Services.System

ShellRoot {
    NotificationService {
        id: globalNotificationService
    }

    PanelWindow {
        id: barExclusionZone

        color: "transparent"
        implicitWidth: 1
        implicitHeight: 56
        anchors.top: true
        anchors.left: true
        anchors.right: true

        mask: Region {
        }

    }

    PanelWindow {
        id: barSurface

        property var activeTrayPopup: null
        readonly property int barHeight: 48
        readonly property int barMarginTop: 8
        readonly property int barMarginSide: 8
        readonly property int popupStartY: barMarginTop + barHeight

        color: "transparent"
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        focusable: false

        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }

        Bar {
            id: barStrip

            z: 1
            notificationService: globalNotificationService
            mainPanelWidget: mainPanel
            x: barSurface.barMarginSide
            y: barSurface.barMarginTop
            width: barSurface.width - barSurface.barMarginSide * 2
            height: barSurface.barHeight
        }

        MainPanel {
            id: mainPanel

            popupId: "dashboard"
            x: (barSurface.width - implicitWidth) / 2
            y: barSurface.popupStartY
        }

        Repeater {
            model: QSSysTray.SystemTray.items

            SystemTray {
                popupId: "systemTray_" + index
                currentTrayItem: modelData
                x: barSurface.width - implicitWidth - barSurface.barMarginSide
                y: barSurface.popupStartY
                onIsOpenChanged: {
                    if (isOpen)
                        barSurface.activeTrayPopup = this;
                    else if (barSurface.activeTrayPopup === this)
                        barSurface.activeTrayPopup = null;
                }
            }

        }

        mask: Region {
            Region {
                x: barSurface.barMarginSide
                y: barSurface.barMarginTop
                width: barSurface.width - barSurface.barMarginSide * 2
                height: barSurface.barHeight
            }

            Region {
                x: mainPanel.x
                y: mainPanel.y
                width: mainPanel._visible ? mainPanel.implicitWidth : 0
                height: mainPanel._visible ? mainPanel.implicitHeight : 0
            }

            Region {
                x: barSurface.activeTrayPopup ? barSurface.activeTrayPopup.x : 0
                y: barSurface.activeTrayPopup ? barSurface.activeTrayPopup.y : 0
                width: (barSurface.activeTrayPopup && barSurface.activeTrayPopup._visible) ? barSurface.activeTrayPopup.implicitWidth : 0
                height: (barSurface.activeTrayPopup && barSurface.activeTrayPopup._visible) ? barSurface.activeTrayPopup.implicitHeight : 0
            }

        }

    }

    PopupLoader {
        popupId: "launcher"

        sourceComponent: Component {
            Launcher {
            }

        }

    }

    PopupLoader {
        popupId: "clipboard"

        sourceComponent: Component {
            Clipboard {
            }

        }

    }

    PopupLoader {
        popupId: "wallpaper"

        sourceComponent: Component {
            WallpaperSelector {
            }

        }

    }

    PopupLoader {
        popupId: "screenshot"

        sourceComponent: Component {
            Screenshot {
            }

        }

    }

    PopupLoader {
        popupId: "keybinds"

        sourceComponent: Component {
            KeybindsCheatSheet {
            }

        }

    }

    PopupLoader {
        popupId: "minflair_settings"
        exclusive: false

        sourceComponent: Component {
            Settings {
            }

        }

    }

    PopupLoader {
        popupId: "packagemanager"

        sourceComponent: Component {
            PackageManager {
            }

        }

    }

    NotificationOverlay {
        notificationService: globalNotificationService
    }

    LockScreen {
        id: lockScreen
    }

    PopupLoader {
        popupId: "controlCenter"
        exclusive: false

        sourceComponent: Component {
            ControlCenter {
                notificationService: globalNotificationService
            }

        }

    }

    PopupLoader {
        popupId: "powerMenu"
        exclusive: false

        sourceComponent: Component {
            PowerMenu {
            }

        }

    }

    Process {
        id: hyprlandAnimProc
    }

}
