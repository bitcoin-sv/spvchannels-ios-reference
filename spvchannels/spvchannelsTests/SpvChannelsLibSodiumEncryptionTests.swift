//
//  SpvChannelsLibSodiumEncryptionTests.swift
//  spvchannelsTests
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import XCTest
@testable import spvchannels

class SpvChannelsLibSodiumEncryptionTests: XCTestCase {

    let bobPubKey = "3uNk31m6mtuKeK/f6U5EFREilaahQR2PewReP3Cypzg="
    let bobSecKey = "Pr9g/f79rGIlIq+NpsXreUifC5KTTwRYLaWTYjhHfY8="

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testInitSuccedsWithKeyPairGeneration() {
        let encryption = SpvLibSodiumEncryption()
        XCTAssertNotNil(encryption)
        XCTAssertEqual(encryption?.myPublicKey().count, 32)
    }

    func testInitFailsWithPublicKeyTooShort() {
        let encryption = SpvLibSodiumEncryption(publicKeyString: "short", secretKeyString: bobSecKey)
        XCTAssertNil(encryption)
    }

    func testInitFailsWithPublicKeyTooLong() {
        let longString = String(repeating: "X", count: 33)
        let encryption = SpvLibSodiumEncryption(publicKeyString: longString, secretKeyString: bobSecKey)
        XCTAssertNil(encryption)
    }

    func testInitFailsWithSecretKeyTooShort() {
        let encryption = SpvLibSodiumEncryption(publicKeyString: bobPubKey, secretKeyString: "short")
        XCTAssertNil(encryption)
    }

    func testInitFailsWithSecretKeyTooLong() {
        let longString = String(repeating: "X", count: 33)
        let encryption = SpvLibSodiumEncryption(publicKeyString: bobPubKey, secretKeyString: longString)
        XCTAssertNil(encryption)
    }

    func testInitSucceedsWithGoodKeys() {
        let encryption = SpvLibSodiumEncryption(publicKeyString: bobPubKey, secretKeyString: bobSecKey)
        XCTAssertNotNil(encryption)
    }

    func testInitSucceedsWithGoodDeserializedKeypairString() {
        let serializedString = """
        { "public_key" : "\(bobPubKey)", "secret_key" : "\(bobSecKey)" }
        """
        let encryption = SpvLibSodiumEncryption(serializedKeypair: serializedString)
        XCTAssertNotNil(encryption)
        XCTAssertEqual(encryption?.myPublicKeyString(), bobPubKey)
    }

    func testInitFailsWithBadDeserializedKeypairString() {
        let serializedString = """
        { "public_key" : "abcde", "secret_key" : "fghij" }
        """
        let encryption = SpvLibSodiumEncryption(serializedKeypair: serializedString)
        XCTAssertNil(encryption)
    }

    func testInitFailsWithMalformedDeserializedKeypairString() {
        let serializedString = "this is not a valid string"
        let encryption = SpvLibSodiumEncryption(serializedKeypair: serializedString)
        XCTAssertNil(encryption)
    }

    func testDeserializationSucceedsWithSerializedKeypairString() {
        guard let encryption = SpvLibSodiumEncryption() else {
            XCTFail("encryption init failed")
            return
        }
        let serializedKeys = encryption.exportKeys()
        let myPublicKey = encryption.myPublicKeyString()
        let newEncryption = SpvLibSodiumEncryption(serializedKeypair: serializedKeys)
        XCTAssertNotNil(newEncryption)
        XCTAssertEqual(newEncryption?.myPublicKeyString(), myPublicKey)
    }

    func testSetEncryptionKeyFailsWithTooShortKey() {
        guard let encryption = SpvLibSodiumEncryption() else {
            XCTFail("encryption init failed")
            return
        }
        let result = encryption.setEncryptionKey(recipientPublicKeyString: "abc")
        XCTAssertFalse(result)
    }

    func testSetMySecretKeyAsEncryptionKeyFails() {
        let serializedString = """
            { "public_key" : "\(bobPubKey)", "secret_key" : "\(bobSecKey)" }
            """
        guard let encryption = SpvLibSodiumEncryption(serializedKeypair: serializedString) else {
            XCTFail("encryption init failed")
            return
        }
        let result = encryption.setEncryptionKey(recipientPublicKeyString: bobSecKey)
        XCTAssertNotNil(encryption)
        XCTAssertFalse(result)
    }

    func testSetEncryptionKeyFailsWithTooLongKey() {
        guard let encryption = SpvLibSodiumEncryption() else {
            XCTFail("encryption init failed")
            return
        }
        let longString = String(repeating: "X", count: 33)
        let result = encryption.setEncryptionKey(recipientPublicKeyString: longString)
        XCTAssertFalse(result)
    }

    func testEncryptingFailsWithoutEncryptionKey() {
        guard let encryption = SpvLibSodiumEncryption() else {
            XCTFail("Encryption init failed")
            return
        }
        let bobToAliceMessage = "The quick brown fox jumped over the lazy dog."+UUID().uuidString
        let bobToAliceMessageData = bobToAliceMessage.data(using: .utf8)!
        let bobToAliceEncryptedMessageData = encryption.encrypt(input: bobToAliceMessageData)
        XCTAssertNil(bobToAliceEncryptedMessageData)
    }

    func testEncryptingReturnsCypherText() {
        let alicePubKey = "DqnzGcbqmdSrhMji1m+G57dGjYwGcPbxnyn6323N2Sw="
        guard let encryption = SpvLibSodiumEncryption() else {
            XCTFail("Encryption init failed")
            return
        }
        if !encryption.setEncryptionKey(recipientPublicKeyString: alicePubKey) {
            XCTFail("Setting encryption key failed")
            return
        }
        let bobToAliceMessage = "The quick brown fox jumped over the lazy dog."+UUID().uuidString
        let bobToAliceMessageData = bobToAliceMessage.data(using: .utf8)!
        let bobToAliceEncryptedMessageData = encryption.encrypt(input: bobToAliceMessageData)
        XCTAssertNotEqual(bobToAliceEncryptedMessageData, bobToAliceMessageData)
    }

    func testEncryptedMessageDecryptsSuccessfully() throws {
        let alicePubKey = "DqnzGcbqmdSrhMji1m+G57dGjYwGcPbxnyn6323N2Sw="
        let aliceSecKey = "gGh+Jl6mWXI3vkMN8DTwXmg6KKDjZCKCLDbP5N2d54M="

        guard let encryption = SpvLibSodiumEncryption() else {
            XCTFail("Encryption init failed")
            return
        }

        if !encryption.setEncryptionKey(recipientPublicKeyString: alicePubKey) {
            XCTFail("Setting encryption key failed")
            return
        }
        let bobToAliceMessage = "The quick brown fox jumped over the lazy dog."+UUID().uuidString
        let bobToAliceMessageData = bobToAliceMessage.data(using: .utf8)!
        guard let bobToAliceEncryptedMessage = encryption.encrypt(input: bobToAliceMessageData) else {
            XCTFail("Could not encrypt message")
            return
        }
        XCTAssertNotNil(bobToAliceEncryptedMessage)

        guard let encryption2 = SpvLibSodiumEncryption(publicKeyString: alicePubKey,
                                                       secretKeyString: aliceSecKey) else {
            XCTFail("Could not initialize encryption")
            return
        }
        guard let aliceSeesThisData = encryption2.decrypt(input: bobToAliceEncryptedMessage),
              let aliceSeesThis = String(data: aliceSeesThisData, encoding: .utf8) else {
            XCTFail("Could not decrypt message")
            return
        }
        XCTAssertEqual(bobToAliceMessage, aliceSeesThis)
    }

    func testEncryptedMessageFailsDecryptWithWrongKey() throws {
        let alicePubKey = "DqnzGcbqmdSrhMji1m+G57dGjYwGcPbxnyn6323N2Sw="

        guard let encryption = SpvLibSodiumEncryption() else {
            XCTFail("Encryption init failed")
            return
        }

        if !encryption.setEncryptionKey(recipientPublicKeyString: alicePubKey) {
            XCTFail("Setting encryption key failed")
            return
        }
        let bobToAliceMessage = "The quick brown fox jumped over the lazy dog."+UUID().uuidString
        let bobToAliceMessageData = bobToAliceMessage.data(using: .utf8)!
        guard let bobToAliceEncryptedMessage = encryption.encrypt(input: bobToAliceMessageData) else {
            XCTFail("Could not encrypt message")
            return
        }

        let bobSeesThis = encryption.decrypt(input: bobToAliceEncryptedMessage)
        XCTAssertNil(bobSeesThis)
    }

    func testEncryptionDuration1MB() throws {
        guard let encryption = SpvLibSodiumEncryption() else {
            XCTFail("Encryption init failed")
            return
        }
        let alicePubKey = "DqnzGcbqmdSrhMji1m+G57dGjYwGcPbxnyn6323N2Sw="
        if !encryption.setEncryptionKey(recipientPublicKeyString: alicePubKey) {
            XCTFail("setting encryption key failed")
            return
        }
        let testString = String(repeating: "X", count: 1_000_000)
        self.measure {
            _ = encryption.encrypt(input: testString.data(using: .utf8)!)
        }
    }

}
