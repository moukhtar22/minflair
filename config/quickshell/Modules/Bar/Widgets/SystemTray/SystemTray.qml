import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import qs.Core
import qs.Core.Components
import qs.Core.Windows

TopPopup {
    id: root

    property var currentTrayItem: null

    contentWidth: Math.max(250, Math.min(trayMenu.implicitWidth, 450))
    contentHeight: 300
    onIsOpenChanged: {
        if (!isOpen)
            trayMenu.resetToRoot();

    }

    TrayMenu {
        id: trayMenu

        width: parent.width
        Layout.preferredHeight: 300
        menuHandle: root.currentTrayItem ? root.currentTrayItem.menu : null
        title: root.currentTrayItem ? root.currentTrayItem.title : "Menu"
        onBackRequested: root.isOpen = false
        onCloseRequested: root.isOpen = false
    }

    Behavior on contentHeight {
        NumberAnimation {
            duration: Constants.animNormal
            easing.type: Easing.OutExpo
        }

    }

    Behavior on contentWidth {
        NumberAnimation {
            duration: Constants.animNormal
            easing.type: Easing.OutExpo
        }

    }

}
