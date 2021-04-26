//
//  UserDefaults+Extensions.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Extension to UserDefaults for convenient storing and retrieving values in app preferences
extension UserDefaults {
    
    private enum Keys: String {
        case firebaseToken = "firebase_token"
    }

    // MARK: -
    static public func getValue<T>(for key: String) -> T? {
        guard let value = UserDefaults.standard.object(forKey: key) as? T else { return nil }
        return value
    }

    static public func setValue<T>(value: T?, for key: String) {
        if value == nil {
            UserDefaults.standard.removeObject(forKey: key)
        } else {
            UserDefaults.standard.setValue(value, forKey: key)
        }
    }

    // MARK: -
    public var firebaseToken: String? {
        get { Self.getValue(for: Keys.firebaseToken.rawValue) }
        set { Self.setValue(value: newValue, for: Keys.firebaseToken.rawValue) }
    }
}
