//
//  SpvEncryptionProtocol.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/**
 Encryption service protocol that allows plug-in of any type of encryption functionality
 
 - parameter input: Data object containing payload to be encrypted/decrypted
 - returns: Optional Data if encryption/descryption successful, *nil* if it failed

 # Notes: #
 If making your own class to use, in case encryption fails, do *not* pass unaltered input as output, return nil instead
*/
public protocol SpvEncryptionProtocol {
    func encrypt(input: Data) -> Data?
    func decrypt(input: Data) -> Data?
}
