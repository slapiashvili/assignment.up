//
//  KeychainHelper.swift
//  m2a7.NotesApp
//
//  Created by Salome Lapiashvili on 05.11.23.
//

import UIKit
import Security

final class KeychainHelper {
    
    static let standard = KeychainHelper()
    
    func save(_ data: Data, service: String, account: String) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ] as [String: Any]
        
        SecItemDelete(query as CFDictionary)
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status == errSecSuccess else {
            throw KeychainError.unableToSave
        }
    }
    
    func read(service: String, account: String) throws -> Data {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ] as [String: Any]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        
        guard status == errSecSuccess, let data = item as? Data else {
            throw KeychainError.unableToRead
        }
        
        return data
    }
    
    func delete(service: String, account: String) throws {
        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ] as [String: Any]
        
        let status = SecItemDelete(query as CFDictionary)
        
        guard status == errSecSuccess else {
            throw KeychainError.unableToDelete
        }
    }
    
    enum KeychainError: Error {
        case unableToSave
        case unableToRead
        case unableToDelete
    }
}

private func saveLogin(username: String, password: String) {
    let service = "slap.ExipNotes"
    let account = username
    do {
        try KeychainHelper.standard.save(password.data(using: .utf8)!, service: service, account: account)
    } catch {
        print("Error saving to keychain: \(error)")
    }
}
