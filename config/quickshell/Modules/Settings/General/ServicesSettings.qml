import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import qs.Core
import qs.Core.Components
import qs.Core.Services
import qs.Modules.Settings.Components

SettingContainer {
    id: servicesScroll

    scrollable: true

    SettingHeader {
        title: "GitHub Integration"
    }

    SettingGroup {
        ThemedTextField {
            id: usernameField

            label: "GitHub Username"
            placeholderText: "Enter your username..."
            text: SettingsService.githubUsername
        }

        ThemedTextField {
            id: tokenField

            label: "GitHub Personal Access Token"
            placeholderText: "Enter your personal access token (optional)..."
            isPassword: true
            text: SettingsService.githubToken
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: Constants.sizeMd

            ThemedButton {
                text: "Save GitHub Config"
                onClicked: {
                    SettingsService.githubUsername = usernameField.text;
                    SettingsService.githubToken = tokenField.text;
                    SettingsService.saveSettings();
                }
            }

            ThemedText {
                text: "Token is optional but recommended to avoid rate limits."
                font.pixelSize: Constants.sizeXs + 2
                color: Theme.muted
                Layout.fillWidth: true
            }

        }

    }

}
