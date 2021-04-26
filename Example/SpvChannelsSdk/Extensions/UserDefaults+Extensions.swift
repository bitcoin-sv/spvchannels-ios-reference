//
//  UserDefaults+Extensions.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import Foundation

/// Extension to UserDefaults for convenient storing and retrieving values in app preferences
extension UserDefaults {
    
    private enum Keys: String {
        case baseUrl = "base_url"
        case accountId = "account_id"
        case username = "username"
        case password = "password"
        case channelId = "channel_id"
        case token = "channel_token"
    }

    // MARK: -
    var baseUrl: String? {
        get { Self.getValue(for: Keys.baseUrl.rawValue) }
        set { Self.setValue(value: newValue, for: Keys.baseUrl.rawValue) }
    }

    var accountId: String? {
        get { Self.getValue(for: Keys.accountId.rawValue) }
        set { Self.setValue(value: newValue, for: Keys.accountId.rawValue) }
    }

    var username: String? {
        get { Self.getValue(for: Keys.username.rawValue) }
        set { Self.setValue(value: newValue, for: Keys.username.rawValue) }
    }

    var password: String? {
        get { Self.getValue(for: Keys.password.rawValue) }
        set { Self.setValue(value: newValue, for: Keys.password.rawValue) }
    }

    var channelId: String? {
        get { Self.getValue(for: Keys.channelId.rawValue) }
        set { Self.setValue(value: newValue, for: Keys.channelId.rawValue) }
    }

    var token: String? {
        get { Self.getValue(for: Keys.token.rawValue) }
        set { Self.setValue(value: newValue, for: Keys.token.rawValue) }
    }

}
