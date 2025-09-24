import Foundation

class LocalizationService {
    static let shared = LocalizationService()
    
    private var currentLanguage: String
    private var translations: [String: [String: String]] = [:]
    
    private init() {
        // 默认使用系统语言，如果系统语言不是中文则使用英文
        currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        if currentLanguage != "zh" {
            currentLanguage = "en"
        }
        
        // 初始化翻译数据
        setupTranslations()
    }
    
    private func setupTranslations() {
        // 英文翻译
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
        
        // 中文翻译
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