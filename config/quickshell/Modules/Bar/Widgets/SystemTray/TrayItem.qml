import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import qs.Core
import qs.Core.Components

Item {
    id: itemRoot

    property var trayItem: null

    signal clicked(var mouse)

    implicitWidth: iconImage.width
    implicitHeight: iconImage.height

    SvgIcon {
        id: iconImage

        anchors.centerIn: parent
        iconSize: Constants.sizeMd
        useOriginalColors: {
            if (!itemRoot.trayItem || !itemRoot.trayItem.iconName)
                return true;

            let name = itemRoot.trayItem.iconName.toLowerCase();
            if (name.endsWith("-symbolic"))
                return false;

            let monoIcons = ["blueman", "nm-device", "network-wireless", "network-wired", "audio-volume", "microphone-sensitivity", "battery", "kdeconnect", "cbatticon", "indicator-sound", "indicator-bluetooth", "network-manager", "nm-applet"];
            for (let i = 0; i < monoIcons.length; i++) {
                if (name.includes(monoIcons[i]))
                    return false;

            }
            return true;
        }
        iconColor: Theme.fg
        flat: true
        icon: {
            if (!itemRoot.trayItem)
                return "";

            try {
                if (itemRoot.trayItem.iconName !== undefined && itemRoot.trayItem.iconName !== "")
                    return "image://icon/" + itemRoot.trayItem.iconName + "?fallback=false";

                let icon = itemRoot.trayItem.icon;
                if (!icon)
                    return "";

                let iconStr = icon.toString();
                if (iconStr.indexOf("://") !== -1 || iconStr.startsWith("/"))
                    return iconStr;

                return "image://icon/" + iconStr + "?fallback=false";
            } catch (e) {
                return "";
            }
        }
        scale: mouseArea.pressed ? 0.9 : (mouseArea.containsMouse ? 1.1 : 1)

        Behavior on scale {
            NumberAnimation {
                duration: Constants.animFast
                easing.type: Easing.OutQuad
            }

        }

    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: (mouse) => {
            if (!itemRoot.trayItem)
                return ;

            if (mouse.button === Qt.LeftButton)
                itemRoot.trayItem.activate();

            itemRoot.clicked(mouse);
        }
    }

}
