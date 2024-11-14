
import Foundation

class LanguageManager{
    static let shared = LanguageManager()
    var languageCode: String = "en"
    private init() {
            // Load the saved user data from UserDefaults
        if let lang = UserDefaults.standard.data(forKey: Configs.LanguageKeys.LocalizeLanguageKey),
           let langCode = try? JSONDecoder().decode(String.self, from: lang)
            {
                languageCode = langCode
            }
        }
    func updateLanguage(){
        if languageCode == "en"{
            languageCode = "vi"
        }
        else{
            languageCode = "en"
        }
        if let data = try? JSONEncoder().encode(languageCode) {
            UserDefaults.standard.set(data, forKey: Configs.LanguageKeys.LocalizeLanguageKey)
        }
    }
}
