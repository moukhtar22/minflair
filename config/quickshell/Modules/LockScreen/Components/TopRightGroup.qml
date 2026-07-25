import QtQuick
import QtQuick.Layouts
import qs.Core
import qs.Core.Services

RowLayout {
    spacing: Constants.sizeMd

    Text {
        text: SystemStats.username
        font.family: Constants.fontFamily
        font.pixelSize: Constants.sizeSm
        color: Theme.muted
    }

    Rectangle {
        width: Constants.size2Xl
        height: 2
        color: Theme.accent
        Layout.alignment: Qt.AlignVCenter
    }

    Text {
        text: SystemStats.hostname
        font.family: Constants.fontFamily
        font.pixelSize: Constants.sizeSm
        color: Theme.muted
    }

}
