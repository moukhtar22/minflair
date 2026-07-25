import QtQuick
import QtQuick.Layouts
import qs.Core
import qs.Core.Components

Card {
    id: root

    default property alias groupContent: mainLayout.data

    backgroundColor: Theme.bgSecondary
    useBorder: true
    Layout.fillWidth: true
    contentPadding: Constants.sizeLg

    ColumnLayout {
        id: mainLayout

        width: parent.width
        spacing: Constants.sizeLg
    }

}
