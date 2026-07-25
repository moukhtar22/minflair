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

    IconImage {
        id: iconImage

        anchors.centerIn: parent
        width: Constants.sizeLg
        height: Constants.sizeLg
        source: {
            if (!itemRoot.trayItem)
                return "";

            try {
                if (itemRoot.trayItem.iconName !== undefined && itemRoot.trayItem.iconName !== "")
                    return "image://icon/" + itemRoot.trayItem.iconName;

                let icon = itemRoot.trayItem.icon;
                if (!icon)
                    return "";

                let iconStr = icon.toString();
                if (iconStr.indexOf("://") !== -1 || iconStr.startsWith("/"))
                    return iconStr;

                return "image://icon/" + iconStr;
            } catch (e) {
                return "";
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
