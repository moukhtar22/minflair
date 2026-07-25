import QtQuick
import QtQuick.Layouts
import qs.Core

Rectangle {
    id: root

    property bool vertical: false

    color: Theme.border
    implicitWidth: vertical ? 1 : 0
    implicitHeight: vertical ? 0 : 1
    Layout.fillWidth: !vertical
    Layout.fillHeight: vertical
}
