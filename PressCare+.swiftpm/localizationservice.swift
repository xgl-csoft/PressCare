import Foundation

class LocalizationService {
    static let shared = LocalizationService()
    
    private var currentLanguage: String
    private var translations: [String: [String: String]] = [:]
    
    private init() {
        currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        if currentLanguage != "zh" {
            currentLanguage = "en"
        }
        setupTranslations()
    }
    
    private func setupTranslations() {
        translations["en"] = [
            "Head": "Head",
            "Neck": "Neck",
            "Chest": "Chest",
            "Back": "Back",
            "Arms": "Arms",
            "Hands": "Hands",
            "Legs": "Legs",
            "Feet": "Feet"
        ]
        translations["zh"] = [
            "Head": "头部",
            "Neck": "颈部",
            "Chest": "胸部",
            "Back": "背部",
            "Arms": "手臂",
            "Hands": "手部",
            "Legs": "腿部",
            "Feet": "足部"
        ]
    }
    
    func localizedString(_ key: String) -> String {
        return translations[currentLanguage]?[key] ?? key
    }
    
    func setLanguage(_ language: String) {
        if translations[language] != nil {
            currentLanguage = language
        }
    }
    
    var currentLocale: String {
        return currentLanguage
    }
}
