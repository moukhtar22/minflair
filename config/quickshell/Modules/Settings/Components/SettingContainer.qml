import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import qs.Core
import qs.Core.Components
import qs.Modules.Settings.Components

Rectangle {
    id: root

    property bool scrollable: true
    default property alias content: contentLayout.data

    color: "transparent"
    Layout.fillWidth: true
    Layout.fillHeight: scrollable
    implicitHeight: scrollable ? 100 : (mainCard.implicitHeight)

    Flickable {
        id: flickable

        clip: true
        interactive: root.scrollable
        contentWidth: width
        contentHeight: mainCard.implicitHeight

        anchors {
            fill: parent
        }

        ColumnLayout {
            id: mainCard

            width: flickable.width

            ColumnLayout {
                id: contentLayout

                Layout.fillWidth: true
                spacing: Constants.sizeLg
            }

        }

        ScrollBar.vertical: ScrollBar {
            policy: ScrollBar.AlwaysOff
        }

    }

}
