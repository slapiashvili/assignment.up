import UIKit

final class UserDefaultsManager {
    
    private enum Keys {
        static let lastLoggedInUsername = "lastLoggedInUsername"
        static func savedNotes(forUser username: String) -> String {
            "savedNotes.\(username)"
        }
    }
    
    static let shared = UserDefaultsManager()
    
    func saveLastLoggedInUsername(_ username: String) {
        UserDefaults.standard.set(username, forKey: Keys.lastLoggedInUsername)
    }
    
    func getLastLoggedInUsername() -> String? {
        UserDefaults.standard.string(forKey: Keys.lastLoggedInUsername)
    }
    
    func saveNotes(_ notes: [String], forUser username: String) {
        let key = Keys.savedNotes(forUser: username)
        UserDefaults.standard.set(notes, forKey: key)
    }
    
    func getSavedNotes(forUser username: String) -> [String]? {
        let key = Keys.savedNotes(forUser: username)
        return UserDefaults.standard.stringArray(forKey: key)
    }
}


//MARK: Fist log in
extension UserDefaultsManager {
    
    enum FirstLoginKeys {
        static let isFirstLogin = "isFirstLogin"
    }
    
    func isFirstLogin(forUser username: String) -> Bool {
        let key = FirstLoginKeys.isFirstLogin + ".\(username)"
        let defaults = UserDefaults.standard
        if defaults.object(forKey: key) == nil {
            defaults.set(true, forKey: key)
            return true
        }
        return defaults.bool(forKey: key)
    }

    func setFirstLoginFlag(forUser username: String, isFirstLogin: Bool) {
        let key = FirstLoginKeys.isFirstLogin + ".\(username)"
        UserDefaults.standard.set(isFirstLogin, forKey: key)
    }
    
    func setFirstLoginTrue(forUser username: String) {
        setFirstLoginFlag(forUser: username, isFirstLogin: true)
    }
}


