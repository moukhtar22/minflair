import Qt5Compat.GraphicalEffects
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Core
import qs.Core.Components
import qs.Core.Services

Rectangle {
    id: sidebarRoot

    property int activeTab: 1
    property bool appearanceCollapsed: false
    property bool generalCollapsed: false
    property bool systemCollapsed: false

    signal tabClicked(int index)

    color: "transparent"

    Component {
        id: itemDelegate

        Rectangle {
            id: delegateRoot

            property var itemData: delegateRoot.parent && delegateRoot.parent.parent ? delegateRoot.parent.parent.itemData : null
            property bool isActive: itemData ? itemData.type === "item" && sidebarRoot.activeTab === itemData.index : false
            property bool isHovered: hoverHandler.hovered
            property bool isPressed: tapHandler.pressed

            width: parent ? parent.width : 260
            implicitHeight: Constants.size4Xl
            radius: Constants.sizeLg
            color: delegateRoot.isActive || delegateRoot.isHovered ? Theme.bgSecondary : "transparent"
            scale: isPressed ? 0.95 : (isHovered ? 1.02 : 1)

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Constants.sizeLg
                anchors.rightMargin: Constants.sizeLg
                spacing: Constants.sizeLg

                SvgIcon {
                    Layout.alignment: Qt.AlignVCenter
                    icon: delegateRoot.itemData && delegateRoot.itemData.icon ? delegateRoot.itemData.icon : ""
                    iconSize: Constants.sizeLg
                    flat: true
                    iconColor: delegateRoot.isActive || delegateRoot.isHovered ? Theme.accent : Theme.muted

                    Behavior on iconColor {
                        ColorAnimation {
                            duration: Constants.animFast
                        }

                    }

                }

                ThemedText {
                    Layout.fillWidth: true
                    text: delegateRoot.itemData ? delegateRoot.itemData.label : ""
                    color: delegateRoot.isActive || delegateRoot.isHovered ? Theme.fg : Theme.muted
                    font.pixelSize: Constants.sizeMd
                    font.weight: delegateRoot.isActive ? Font.Medium : Font.Normal

                    Behavior on color {
                        ColorAnimation {
                            duration: Constants.animFast
                        }

                    }

                }

            }

            TapHandler {
                id: tapHandler

                onTapped: {
                    if (delegateRoot.itemData && delegateRoot.itemData.type === "item")
                        sidebarRoot.tabClicked(delegateRoot.itemData.index);

                }
            }

            HoverHandler {
                id: hoverHandler

                cursorShape: Qt.PointingHandCursor
            }

            Behavior on color {
                ColorAnimation {
                    duration: Constants.animFast
                }

            }

            Behavior on scale {
                NumberAnimation {
                    duration: Constants.animFast
                    easing.type: Easing.OutBack
                }

            }

        }

    }

    Component {
        id: headerDelegate

        Item {
            id: headerRoot

            property var itemData: headerRoot.parent && headerRoot.parent.parent ? headerRoot.parent.parent.itemData : null
            property bool isCollapsed: headerRoot.parent && headerRoot.parent.parent ? headerRoot.parent.parent.isCollapsed : false

            width: parent ? parent.width : 260
            implicitHeight: Constants.size3Xl

            RowLayout {
                anchors.fill: parent
                anchors.leftMargin: Constants.sizeLg
                anchors.rightMargin: Constants.sizeLg
                spacing: Constants.sizeSm

                SvgIcon {
                    id: headerIcon

                    icon: "minflair"
                    flat: true
                    iconSize: 10
                    iconColor: Theme.accent
                    transformOrigin: Item.Center

                    ParallelAnimation {
                        running: typeof HyprlandService !== "undefined" && HyprlandService.enableAnimations
                        loops: Animation.Infinite

                        SequentialAnimation {
                            loops: Animation.Infinite

                            NumberAnimation {
                                target: headerIcon
                                property: "scale"
                                from: 1
                                to: 1.25
                                duration: 2000
                                easing.type: Easing.InOutQuad
                            }

                            NumberAnimation {
                                target: headerIcon
                                property: "scale"
                                from: 1.25
                                to: 1
                                duration: 2000
                                easing.type: Easing.InOutQuad
                            }

                        }

                        SequentialAnimation {
                            loops: Animation.Infinite

                            NumberAnimation {
                                target: headerIcon
                                property: "rotation"
                                from: 0
                                to: 10
                                duration: 2000
                                easing.type: Easing.InOutQuad
                            }

                            NumberAnimation {
                                target: headerIcon
                                property: "rotation"
                                from: 10
                                to: 0
                                duration: 2000
                                easing.type: Easing.InOutQuad
                            }

                        }

                    }

                }

                ThemedText {
                    text: headerRoot.itemData ? headerRoot.itemData.label : ""
                    color: Theme.muted
                    font.pixelSize: 11
                    font.letterSpacing: 1.5
                    font.weight: Font.Bold
                }

                Item {
                    Layout.fillWidth: true
                }

                SvgIcon {
                    icon: "chevron-right"
                    flat: true
                    iconSize: Constants.sizeSm
                    iconColor: Theme.muted
                    rotation: headerRoot.isCollapsed ? 0 : 90

                    Behavior on rotation {
                        NumberAnimation {
                            duration: Constants.animFast
                            easing.type: Easing.OutQuad
                        }

                    }

                }

            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: {
                    if (!headerRoot.itemData)
                        return ;

                    if (headerRoot.itemData.section === "appearance")
                        sidebarRoot.appearanceCollapsed = !sidebarRoot.appearanceCollapsed;
                    else if (headerRoot.itemData.section === "general")
                        sidebarRoot.generalCollapsed = !sidebarRoot.generalCollapsed;
                    else if (headerRoot.itemData.section === "system")
                        sidebarRoot.systemCollapsed = !sidebarRoot.systemCollapsed;
                }
            }

        }

    }

    Component {
        id: separatorDelegate

        Item {
            width: parent ? parent.width : 260
            implicitHeight: Constants.sizeXl

            Rectangle {
                anchors.centerIn: parent
                width: parent.width - Constants.sizeLg * 2
                height: 1
                color: Theme.bgSecondary
            }

        }

    }

    Item {
        id: profileHeader

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Constants.size4Xl + Constants.sizeLg

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Constants.sizeLg
            anchors.rightMargin: Constants.sizeLg
            spacing: Constants.sizeLg

            Rectangle {
                width: Constants.size4Xl
                height: Constants.size4Xl
                radius: Constants.size4Xl / 2
                color: Theme.bgSecondary
                Layout.alignment: Qt.AlignVCenter

                Image {
                    id: profileImage

                    anchors.fill: parent
                    source: "file:///home/" + SystemStats.username + "/.face"
                    mipmap: true
                    fillMode: Image.PreserveAspectCrop
                    visible: false
                }

                Rectangle {
                    id: mask

                    anchors.fill: parent
                    radius: Constants.size4Xl / 2
                    visible: false
                }

                OpacityMask {
                    anchors.fill: parent
                    source: profileImage
                    maskSource: mask
                }

            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignVCenter
                spacing: Constants.size3Xs

                ThemedText {
                    text: SystemStats.username
                    font.pixelSize: Constants.sizeLg
                    font.weight: Font.Bold
                    color: Theme.fg
                    Layout.fillWidth: true
                }

                ThemedText {
                    text: "@" + SystemStats.hostname
                    font.pixelSize: Constants.sizeSm
                    color: Theme.muted
                    Layout.fillWidth: true
                }

            }

        }

    }

    ColumnLayout {
        id: tabColumn

        anchors.top: profileHeader.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        spacing: 2

        Repeater {
            id: tabRepeater

            model: [{
                "type": "header",
                "label": "APPEARANCE",
                "section": "appearance"
            }, {
                "type": "item",
                "index": 0,
                "label": "Appearance",
                "icon": "color-palette",
                "section": "appearance"
            }, {
                "type": "item",
                "index": 1,
                "label": "Window Manager",
                "icon": "app-window",
                "section": "appearance"
            }, {
                "type": "separator",
                "section": "appearance"
            }, {
                "type": "header",
                "label": "GENERAL",
                "section": "general"
            }, {
                "type": "item",
                "index": 2,
                "label": "Input & Clipboard",
                "icon": "edit",
                "section": "general"
            }, {
                "type": "item",
                "index": 3,
                "label": "Default Applications",
                "icon": "star",
                "section": "general"
            }, {
                "type": "item",
                "index": 4,
                "label": "Services",
                "icon": "code",
                "section": "general"
            }, {
                "type": "item",
                "index": 5,
                "label": "Quotes",
                "icon": "quote",
                "section": "general"
            }, {
                "type": "separator",
                "section": "general"
            }, {
                "type": "header",
                "label": "SYSTEM",
                "section": "system"
            }, {
                "type": "item",
                "index": 6,
                "label": "System",
                "icon": "info",
                "section": "system"
            }, {
                "type": "item",
                "index": 7,
                "label": "Updates",
                "icon": "refresh",
                "section": "system"
            }]

            delegate: Item {
                property var itemData: modelData
                property bool isHeader: modelData.type === "header"
                property bool isCollapsed: {
                    if (!itemData || !itemData.section)
                        return false;

                    if (itemData.section === "appearance")
                        return sidebarRoot.appearanceCollapsed;

                    if (itemData.section === "general")
                        return sidebarRoot.generalCollapsed;

                    if (itemData.section === "system")
                        return sidebarRoot.systemCollapsed;

                    return false;
                }
                property real fullHeight: {
                    if (modelData.type === "item")
                        return Constants.size4Xl;

                    if (modelData.type === "separator")
                        return Constants.sizeXl;

                    if (modelData.type === "header")
                        return Constants.size3Xl;

                    return 0;
                }
                property real targetHeight: isHeader ? fullHeight : (isCollapsed ? 0 : fullHeight)
                property real animHeight: targetHeight

                Layout.fillWidth: true
                Layout.preferredHeight: animHeight
                opacity: isHeader ? 1 : (animHeight / (fullHeight || 1))
                visible: isHeader ? true : (animHeight > 0)
                clip: animHeight < fullHeight

                Loader {
                    id: loader

                    width: parent.width
                    sourceComponent: {
                        if (modelData.type === "item" || modelData.type === "profile")
                            return itemDelegate;

                        if (modelData.type === "header")
                            return headerDelegate;

                        if (modelData.type === "separator")
                            return separatorDelegate;

                        return null;
                    }
                }

                Behavior on animHeight {
                    NumberAnimation {
                        duration: Constants.animNormal
                        easing.type: Easing.InOutQuad
                    }

                }

            }

        }

    }

}
