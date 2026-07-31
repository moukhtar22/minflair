import qs.Core
import qs.Core.Components
import qs.Core.Services
import qs.Modules.Settings.Components

SettingContainer {
    id: quoteSettingsRoot

    readonly property var categories: QuoteService.categories

    SettingHeader {
        title: "Daily Quotes"
    }

    SettingGroup {
        SettingSelect {
            label: "Select Quote Category"
            description: "Choose the theme of the quotes displayed on your dashboard and lock screen."
            model: quoteSettingsRoot.categories
            currentIndex: quoteSettingsRoot.categories.indexOf(QuoteService.currentCategory)
            onActivated: (index) => {
                SettingsService.quoteCategory = quoteSettingsRoot.categories[index];
                QuoteService.generateRandomQuote();
            }
        }

    }

}
