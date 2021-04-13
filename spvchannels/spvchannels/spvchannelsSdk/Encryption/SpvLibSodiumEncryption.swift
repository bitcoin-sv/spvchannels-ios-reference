//
//  SpvLibSodiumEncryption.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import Sodium

/// Convenience extension to convert Data class to an array of UInt8
extension Data {
    var bytes: [UInt8] {
        self.withUnsafeBytes { $0.map { $0 } }
    }
}

/// Base keyPair for use in libSodium encryption
struct SodiumKeyPair: Codable {
    let publicKey: Data
    let secretKey: Data
}

/// Implementation of libSodium encryption/decryption for SPV messaging, with helper methods
class SpvLibSodiumEncryption: SpvEncryptionProtocol {

    private let sodium = Sodium()
    private var myKeyPair: SodiumKeyPair
    private var encryptionKey: Data?

    /// Encrypts the payload using libSodium sealed box method and a previously set encryption key of the recipient
    func encrypt(input: Data) -> Data? {
        guard let encryptionKey = encryptionKey,
              let encryptedPayload = sodium.box.seal(message: input.bytes,
                                                     recipientPublicKey: encryptionKey.bytes)
        else { return nil }
        return Data(encryptedPayload)
    }

    /// Decrypts the payload using libSodium sealed box method and your previously set keypair
    func decrypt(input: Data) -> Data? {
        guard let decryptedPayload = sodium.box.open(anonymousCipherText: input.bytes,
                                                     recipientPublicKey: myKeyPair.publicKey.bytes,
                                                     recipientSecretKey: myKeyPair.secretKey.bytes)
        else { return nil }
        return Data(decryptedPayload)
    }

    /// Export the encryption key that is used by this encryption. Can be shared with others so that
    /// they can use it to encrypt data that only you can decrypt. Output format is a Data object
    func myPublicKey() -> Data {
        myKeyPair.publicKey
    }

    /// Export the encryption key that is used by this encryption. Can be shared with others so that
    /// they can use it to encrypt data that only you can decrypt. Output format is a Base64 encoded string
    func myPublicKeyString() -> String {
        myPublicKey().base64EncodedString()
    }

    /// Exports the public/secret key combination. Private key should **never** be shared.
    /// Output format is a JSON structure containing public and private keys in Base64 encoded values
    func exportKeys() -> String {
        myKeyPair.jsonString()
    }

    /// Set the key used for encryption of message payloads
    /// Input format is a Data object containing recipient's public key
    /// This key will be used to encrypt outgoing messages
    func setEncryptionKey(recipientPublicKey: Data) -> Bool {
        guard recipientPublicKey.count == 32,
              recipientPublicKey != myKeyPair.secretKey else { return false }
        self.encryptionKey = recipientPublicKey
        return true
    }

    /// Set the key used for encryption of message payloads
    /// Input format is a Base64 encoded string containing recipient's public key
    /// This key will be used to encrypt outgoing messages
    func setEncryptionKey(recipientPublicKeyString: String) -> Bool {
        guard let recipientPublicKeyData = Data(base64Encoded: recipientPublicKeyString) else { return false }
        return setEncryptionKey(recipientPublicKey: recipientPublicKeyData)
    }

    /// Initializer without given parameter generates an ephemeral keypair
    /// This keypair will be used to decrypt incoming messages
    init?() {
        guard let newKeyPair = sodium.box.keyPair() else { return nil }
        self.myKeyPair = SodiumKeyPair(publicKey: Data(newKeyPair.publicKey),
                                       secretKey: Data(newKeyPair.secretKey))
    }

    /// Initializer with parameters creates the class with given Data objects for your public and secret key
    /// Input format is a pair of Data objects
    /// This keypair will be used to decrypt incoming messages.
    init?(publicKey: Data, secretKey: Data) {
        guard publicKey.count == 32,
              secretKey.count == 32,
              publicKey != secretKey else { return nil }
        self.myKeyPair = SodiumKeyPair(publicKey: publicKey, secretKey: secretKey)
    }

    /// Initializer with parameters creates the class with given Base64 encoded strings for your public and secret key
    /// Input format is a pair of Base64 encoded strings
    /// This keypair will be used to decrypt incoming messages.
    convenience init?(publicKeyString: String, secretKeyString: String) {
        guard let publicKey = Data(base64Encoded: publicKeyString),
              let secretKey = Data(base64Encoded: secretKeyString) else { return nil }
        self.init(publicKey: publicKey, secretKey: secretKey)
    }

    /// Initializer with parameter creates the class with a given JSON data structure contaning your public/secret keys
    /// Input format is a JSON structure as produced by the exportKeys method above
    /// This keypair will be used to decrypt incoming messages.
    convenience init?(serializedKeypair: String) {
        guard let keyPair: SodiumKeyPair = .parse(from: serializedKeypair) else { return nil }
        self.init(publicKey: keyPair.publicKey, secretKey: keyPair.secretKey)
    }
}
