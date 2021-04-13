//
//  UserDefaults+Extensions.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Extension to UserDefaults for convenient storing and retrieving values in app preferences
extension UserDefaults {

    enum Keys: String {
        case baseUrl = "base_url"
        case accountId = "account_id"
        case username = "username"
        case password = "password"
        case token = "token"
        case channelId = "channel_id"
        case firebaseToken = "firebase_token"
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

    var channelId: String? {
        get { Self.getValue(for: .channelId) }
        set { Self.setValue(value: newValue, for: .channelId) }
    }

    var token: String? {
        get { Self.getValue(for: .token) }
        set { Self.setValue(value: newValue, for: .token) }
    }

    var firebaseToken: String? {
        get { Self.getValue(for: .firebaseToken) }
        set { Self.setValue(value: newValue, for: .firebaseToken) }
    }

}
