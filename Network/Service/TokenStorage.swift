//
//  TokenStorage.swift
//  ABZUsers
//
//  Created by Igor Karyi on 30.07.2025.
//

import Foundation

protocol TokenStorageProtocol: AnyObject {
    var token: String? { get set }
}

final class TokenStorage: TokenStorageProtocol, ObservableObject {

    private let tokenKey = "TokenKey"

    @Published var token: String? {
        didSet { saveToken(token, forKey: tokenKey) }
    }

    init() {
        token = loadToken(forKey: tokenKey)
    }

    private func saveToken(_ token: String?, forKey key: String) {
        guard let token = token else {
            deleteToken(forKey: key)
            return
        }
        let tokenData = Data(token.utf8)

        deleteToken(forKey: key)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: tokenData,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            print("Failed to save token with key: \(key), status: \(status)")
        } else {
            print("Token saved with key: \(key)")
        }
    }

    private func loadToken(forKey key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var dataTypeRef: AnyObject? = nil
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            let token = String(data: data, encoding: .utf8)
            print("Loaded token for key: \(key)")
            return token
        } else {
            print("Failed to load token for key: \(key), status: \(status)")
            return nil
        }
    }

    private func deleteToken(forKey key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        let status = SecItemDelete(query as CFDictionary)
        if status == errSecSuccess {
            print("Successfully deleted token with key: \(key)")
        } else if status == errSecItemNotFound {
            print("Token not found for key: \(key)")
        } else {
            print("Failed to delete token for key: \(key), status: \(status)")
        }
    }
}
