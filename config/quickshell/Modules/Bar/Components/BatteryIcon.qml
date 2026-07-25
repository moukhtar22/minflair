import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Services.Notifications
import qs.Core
import qs.Core.Components
import qs.Core.Services

SvgIcon {
    id: root

    property int batteryLevel: SystemInfoService.batteryLevel
    property string batteryStatus: SystemInfoService.batteryStatus
    property bool hasBattery: SystemInfoService.hasBattery
    property var notificationService
    property string _prevStatus: ""
    property int _prevLevel: -1
    property bool notifiedFull: false
    property int textOffsetX: -2
    property int textOffsetY: 1
    property color activeColor: Theme.fg
    readonly property string batteryIconText: {
        if (root.batteryStatus === "Charging")
            return "battery-bolt";

        if (root.batteryLevel >= 90)
            return "battery-full";

        if (root.batteryLevel >= 70)
            return "battery-4";

        if (root.batteryLevel >= 50)
            return "battery-3";

        if (root.batteryLevel >= 30)
            return "battery-2";

        if (root.batteryLevel >= 10)
            return "battery-1";

        return "battery-question";
    }

    onBatteryStatusChanged: {
        if (batteryStatus === "" || batteryStatus === _prevStatus)
            return ;

        if (_prevStatus !== "") {
            let summary = "Battery";
            let body = "";
            if (batteryStatus === "Charging") {
                if (_prevStatus === "Discharging") {
                    summary = "Battery";
                    body = "Charger connected";
                }
            } else if (batteryStatus === "Discharging") {
                if (_prevStatus === "Charging" || _prevStatus === "Full" || _prevStatus === "Not charging") {
                    summary = "Battery";
                    body = "Charger disconnected";
                }
            } else if (batteryStatus === "Full" || batteryStatus === "Not charging") {
                if (!root.notifiedFull && batteryStatus === "Full" && root.batteryLevel >= 95) {
                    summary = "Battery";
                    body = "Battery fully charged";
                    root.notifiedFull = true;
                }
            }
            if (body !== "" && notificationService)
                notificationService.notify(summary, body);

        }
        _prevStatus = batteryStatus;
    }
    onBatteryLevelChanged: {
        if (batteryLevel <= 0 || batteryLevel === _prevLevel)
            return ;

        if (batteryStatus === "Discharging" && batteryLevel < 95)
            root.notifiedFull = false;

        if (_prevLevel !== -1 && batteryStatus === "Discharging") {
            let threshold = 0;
            if (batteryLevel <= 5 && _prevLevel > 5)
                threshold = 5;
            else if (batteryLevel <= 10 && _prevLevel > 10)
                threshold = 10;
            else if (batteryLevel <= 20 && _prevLevel > 20)
                threshold = 20;
            if (threshold > 0 && notificationService)
                notificationService.notify("Low Battery", "Battery level: " + batteryLevel + "%", "", "System", NotificationUrgency.Critical);

        }
        _prevLevel = batteryLevel;
    }
    visible: hasBattery
    icon: root.batteryIconText
    iconColor: root.activeColor
    iconSize: 24
    flat: true

    ThemedText {
        anchors.centerIn: parent
        anchors.horizontalCenterOffset: root.textOffsetX
        anchors.verticalCenterOffset: root.textOffsetY
        z: 1
        text: root.batteryLevel.toString()
        color: root.batteryLevel > 70 || root.batteryStatus === "Charging" ? Theme.bg : Theme.fg
        font.bold: true
        font.pixelSize: Constants.sizeXs
        visible: root.batteryLevel > 0
    }

    Behavior on activeColor {
        ColorAnimation {
            duration: Constants.animSlow
            easing.type: Easing.OutQuint
        }

    }

    SequentialAnimation on opacity {
        id: breathAnim

        loops: Animation.Infinite
        running: root.batteryStatus === "Charging"
        onRunningChanged: {
            if (!running)
                root.opacity = 1;

        }

        NumberAnimation {
            to: 0.4
            duration: 1000
            easing.type: Easing.InOutSine
        }

        NumberAnimation {
            to: 1
            duration: 1000
            easing.type: Easing.InOutSine
        }

    }

}
