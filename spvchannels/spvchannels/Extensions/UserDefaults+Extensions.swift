//
//  UserDefaults+Extensions.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension UserDefaults {
    
    enum Keys: String {
        case name = "input_storage"
        case url = "url"
        case account = "account"
        case username = "username"
        case password = "password"
        case channelId = "channel_id"
        case token = "token"
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
    var name: String? {
        get { Self.getValue(for: .name) }
        set { Self.setValue(value: newValue, for: .name) }
    }
    
    var url: String? {
        get { Self.getValue(for: .url) }
        set { Self.setValue(value: newValue, for: .url) }
    }

    var account: String? {
        get { Self.getValue(for: .account) }
        set { Self.setValue(value: newValue, for: .account) }
    }
    
    var username: String? {
        get { Self.getValue(for: .username) }
        set { Self.setValue(value: newValue, for: .username) }
    }
    
    var password: String? {
        get { Self.getValue(for: .password) }
        set { Self.setValue(value: newValue, for: .password) }
    }

    var channelId: String? {
        get { Self.getValue(for: .channelId) }
        set { Self.setValue(value: newValue, for: .channelId) }
    }
    
    var token: String? {
        get { Self.getValue(for: .token) }
        set { Self.setValue(value: newValue, for: .token) }
    }
    
}
