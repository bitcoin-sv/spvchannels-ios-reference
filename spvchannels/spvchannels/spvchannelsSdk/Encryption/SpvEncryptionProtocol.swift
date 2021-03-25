//
//  SpvEncryptionProtocol.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

protocol SpvEncryptionProtocol {
    func encrypt(input: Data) -> Data
    func dencrypt(input: Data) -> Data
}
