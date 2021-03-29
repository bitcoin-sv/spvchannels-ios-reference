//
//  SpvLibSodiumEncryption.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation
import Sodium

extension Data {
    var bytes: [UInt8] {
        self.withUnsafeBytes { $0.map { $0 } }
    }
}

struct SodiumKeyPair: Codable {
    let publicKey: Data
    let secretKey: Data
    enum CodingKeys: String, CodingKey {
        case publicKey = "public_key"
        case secretKey = "secret_key"
    }
}

class SpvLibSodiumEncryption: SpvEncryptionProtocol {

    private let sodium = Sodium()
    private var myKeyPair: SodiumKeyPair
    private var encryptionKey: Data?

    func encrypt(input: Data) -> Data? {
        guard let encryptionKey = encryptionKey,
              let encryptedPayload = sodium.box.seal(message: input.bytes,
                                                     recipientPublicKey: encryptionKey.bytes)
        else { return nil }
        return Data(encryptedPayload)
    }

    func decrypt(input: Data) -> Data? {
        guard let decryptedPayload = sodium.box.open(anonymousCipherText: input.bytes,
                                                     recipientPublicKey: myKeyPair.publicKey.bytes,
                                                     recipientSecretKey: myKeyPair.secretKey.bytes)
        else { return nil }
        return Data(decryptedPayload)
    }

    func myPublicKey() -> Data {
        myKeyPair.publicKey
    }

    func myPublicKeyString() -> String {
        myPublicKey().base64EncodedString()
    }

    func exportKeys() -> String {
        myKeyPair.jsonString()
    }

    func setEncryptionKey(recipientPublicKey: Data) -> Bool {
        guard recipientPublicKey.count == 32,
              recipientPublicKey != myKeyPair.secretKey else { return false }
        self.encryptionKey = recipientPublicKey
        return true
    }

    func setEncryptionKey(recipientPublicKeyString: String) -> Bool {
        guard let recipientPublicKeyData = Data(base64Encoded: recipientPublicKeyString) else { return false }
        return setEncryptionKey(recipientPublicKey: recipientPublicKeyData)
    }

    init?() {
        guard let newKeyPair = sodium.box.keyPair() else { return nil }
        self.myKeyPair = SodiumKeyPair(publicKey: Data(newKeyPair.publicKey),
                                       secretKey: Data(newKeyPair.secretKey))
    }

    init?(publicKey: Data, secretKey: Data) {
        guard publicKey.count == 32, secretKey.count == 32, publicKey != secretKey else { return nil }
        self.myKeyPair = SodiumKeyPair(publicKey: publicKey, secretKey: secretKey)
    }

    convenience init?(publicKeyString: String, secretKeyString: String) {
        guard let publicKey = Data(base64Encoded: publicKeyString),
              let secretKey = Data(base64Encoded: secretKeyString) else { return nil }
        self.init(publicKey: publicKey, secretKey: secretKey)
    }

    convenience init?(serializedKeypair: String) {
        guard let keyPair: SodiumKeyPair = .parse(from: serializedKeypair) else { return nil }
        self.init(publicKey: keyPair.publicKey, secretKey: keyPair.secretKey)
    }
}
