//
//  UserDefaults+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension UserDefaults {

    enum Keys: String {
        case baseUrl = "base_url"
        case accountId = "account_id"
        case username = "username"
        case password = "password"
    }

    // MARK: -
    static private func getValue<T>(for key: UserDefaults.Keys) -> T? {
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) as? T else { return nil }
        return value
    }

    static private func setValue<T>(value: T?, for key: UserDefaults.Keys) {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        } else {
            UserDefaults.standard.setValue(value, forKey: key.rawValue)
        }
    }

    static private func getData<T: Decodable>(for key: UserDefaults.Keys) -> T? {
        guard let data = Self.getDataRaw(for: key) else { return nil }
        return try? PropertyListDecoder().decode(T.self, from: data)
    }

    static private func getDataRaw(for key: UserDefaults.Keys) -> Data? {
        UserDefaults.standard.object(forKey: key.rawValue) as? Data
    }

    static private func setData<T: Encodable>(value: T?, for key: UserDefaults.Keys) {
        let data = try? PropertyListEncoder().encode(value)
        Self.setDataRaw(value: data, for: key)
    }

    static private func setDataRaw(value: Data?, for key: UserDefaults.Keys) {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        } else {
            UserDefaults.standard.setValue(value, forKey: key.rawValue)
        }
    }

    // MARK: -
    var baseUrl: String? {
        get { Self.getValue(for: .baseUrl) }
        set { Self.setValue(value: newValue, for: .baseUrl) }
    }

    var accountId: String? {
        get { Self.getValue(for: .accountId) }
        set { Self.setValue(value: newValue, for: .accountId) }
    }

    var username: String? {
        get { Self.getValue(for: .username) }
        set { Self.setValue(value: newValue, for: .username) }
    }

    var password: String? {
        get { Self.getValue(for: .password) }
        set { Self.setValue(value: newValue, for: .password) }
    }

}
