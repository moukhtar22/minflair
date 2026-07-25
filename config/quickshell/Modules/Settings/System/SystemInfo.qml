import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Io
import qs.Core
import qs.Core.Components
import qs.Core.Services
import qs.Modules.Settings.Components

ColumnLayout {
    id: root

    property string osName: SystemInfoService.osName
    property string kernel: SystemStats.kernel
    property string hostname: SystemStats.hostname
    property string cpuModel: SystemStats.cpuModel
    property string shell: SystemStats.shell
    property string packages: SystemStats.packages
    property string packagesAur: SystemStats.packagesAur
    property string uptimeText: SystemStats.uptime
    property double cpuUsage: SystemStats.cpuUsage
    property double memUsage: SystemStats.memUsage
    property string memTotal: SystemStats.memTotal.toFixed(1) + " GB"
    property string memUsed: SystemStats.memUsed.toFixed(1) + " GB"
    property string cpuTemp: SystemStats.cpuTemp
    property string cpuFreq: SystemStats.cpuFreq
    property string cpuCores: SystemStats.cpuCores
    property string diskSizeText: SystemStats.diskSizeText
    property int diskUsage: SystemStats.diskUsage
    property string loadAvg: SystemStats.loadAvg
    property int tasks: SystemStats.tasks
    property string gpuName: SystemStats.gpuName
    property string gpuUsage: SystemStats.hasGpu ? (SystemStats.gpuUsage + "%") : "--"
    property string gpuTemp: SystemStats.gpuTemp
    property string gpuVram: SystemStats.gpuVram
    property string username: SystemStats.username

    spacing: Constants.sizeLg

    ColumnLayout {
        spacing: Constants.sizeSm
        Layout.fillWidth: true
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: Constants.sizeLg
        Layout.bottomMargin: Constants.sizeLg

        AnimatedMinflair {
            iconSize: 96
            iconColor: Theme.fg
            extraAnimated: true
            Layout.alignment: Qt.AlignHCenter
        }

        ThemedText {
            text: root.username + "@" + root.hostname
            font.bold: true
            font.pixelSize: Constants.sizeLg
            Layout.alignment: Qt.AlignHCenter
        }

        ThemedText {
            text: root.osName
            font.pixelSize: Constants.sizeMd
            color: Theme.muted
            Layout.alignment: Qt.AlignHCenter
        }

    }

    SettingHeader {
        title: "System Information"
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Constants.sizeSm

        InfoRow {
            label: "Kernel"
            value: root.kernel
        }

        InfoRow {
            label: "Uptime"
            value: root.uptimeText
        }

        InfoRow {
            label: "Shell"
            value: root.shell
        }

        InfoRow {
            label: "Pacman Packages"
            value: root.packages
        }

        InfoRow {
            label: "AUR Packages"
            value: root.packagesAur
        }

        InfoRow {
            label: "WM / DE"
            value: "Hyprland"
        }

    }

    SettingHeader {
        title: "Hardware Status"
    }

    ColumnLayout {
        Layout.fillWidth: true
        spacing: Constants.sizeSm

        InfoRow {
            label: "CPU Model"
            value: root.cpuModel
        }

        InfoRow {
            label: "CPU Config"
            value: root.cpuCores + " @ " + root.cpuFreq
        }

        InfoRow {
            label: "CPU Usage"
            value: root.cpuUsage.toFixed(0) + "% (" + root.cpuTemp + ")"
        }

        InfoRow {
            label: "Memory"
            value: root.memUsed + " / " + root.memTotal + " (" + root.memUsage.toFixed(0) + "%)"
        }

        InfoRow {
            label: "Storage /"
            value: root.diskSizeText + " (" + root.diskUsage + "%)"
        }

        InfoRow {
            label: "Load Average"
            value: root.loadAvg
        }

        InfoRow {
            label: "Active Tasks"
            value: root.tasks.toString()
        }

        InfoRow {
            label: "GPU Model"
            value: root.gpuName
            visible: root.gpuName !== "None"
        }

        InfoRow {
            label: "GPU VRAM"
            value: root.gpuVram
            visible: root.gpuName !== "None" && root.gpuVram !== "" && root.gpuVram !== "None"
        }

        InfoRow {
            label: "GPU Usage"
            value: root.gpuUsage + " (" + root.gpuTemp + ")"
            visible: root.gpuName !== "None"
        }

    }

}
