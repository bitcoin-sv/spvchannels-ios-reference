//
//  RawMessage.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

struct RawMessage {
    let sequence: Int
    let date: Date
    let contentType: String
    let payload: String
    var messageData: Data {
        Data(base64Encoded: payload) ?? Data()
    }

    init(sequence: Int, date: Date, contentType: String, payload: String) {
        self.sequence = sequence
        self.date = date
        self.contentType = contentType
        self.payload = payload
    }
}
