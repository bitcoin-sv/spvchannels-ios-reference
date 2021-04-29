//
//  KeyedEncodingContainerProtocol+Extensions.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Extension with helper function to allow encoding nil optional values to a JSON NULL
extension KeyedEncodingContainerProtocol {
    mutating func encodeNullableOptional<T: Encodable>(_ value: T?, forKey key: Self.Key) throws {
        guard let value = value else {
            try self.encodeNil(forKey: key)
            return
        }
        try self.encode(value, forKey: key)
    }
}
