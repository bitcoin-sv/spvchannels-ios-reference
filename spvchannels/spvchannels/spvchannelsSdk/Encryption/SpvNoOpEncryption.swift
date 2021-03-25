//
//  NoOpEncryption.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

struct SpvNoOpEncryption: SpvEncryptionProtocol {

    func encrypt(input: Data) -> Data {
        input
    }

    func dencrypt(input: Data) -> Data {
        input
    }

}
