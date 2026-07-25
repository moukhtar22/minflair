import "Components"
import QtQuick
import QtQuick.Layouts
import Quickshell.Services.SystemTray
import qs.Core
import qs.Core.Components
import qs.Core.Services
import qs.Modules.Bar.Widgets.SystemTray as STray

Item {
    id: mainBar

    required property var notificationService
    required property var mainPanelWidget
    required property var systemTrayRef

    Rectangle {
        id: barContent

        anchors.fill: parent
        color: Theme.bg
        radius: Constants.size2Xl

        RowLayout {
            id: hLeftGroup

            anchors.left: parent.left
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            spacing: Constants.sizeLg
            anchors.leftMargin: 16

            MinflairButton {
                widget: mainBar.mainPanelWidget
            }

            Workspaces {
            }

        }

        ClockButton {
            id: centerClock

            anchors.centerIn: parent
        }

        RowLayout {
            id: hRightGroup

            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            spacing: Constants.sizeLg
            anchors.rightMargin: 16

            ControlCenterButton {
                notificationService: mainBar.notificationService
            }

            RowLayout {
                spacing: Constants.sizeXs

                Repeater {
                    model: SystemTray.items

                    delegate: STray.TrayItem {
                        trayItem: modelData
                        onClicked: (mouse) => {
                            if (mouse.button === Qt.RightButton || mouse.button === Qt.LeftButton) {
                                if (modelData.menu) {
                                    if (mainBar.systemTrayRef.isOpen && mainBar.systemTrayRef.currentTrayItem === modelData) {
                                        mainBar.systemTrayRef.isOpen = false;
                                    } else {
                                        mainBar.systemTrayRef.currentTrayItem = modelData;
                                        mainBar.systemTrayRef.isOpen = true;
                                    }
                                } else if (mouse.button === Qt.LeftButton)
                                    modelData.activate();
                                else if (modelData.secondaryActivate && mouse.button === Qt.RightButton)
                                    modelData.secondaryActivate();
                            }
                        }
                    }

                }

            }

            PowerButton {
                popupId: "powerMenu"
            }

        }

    }

}
