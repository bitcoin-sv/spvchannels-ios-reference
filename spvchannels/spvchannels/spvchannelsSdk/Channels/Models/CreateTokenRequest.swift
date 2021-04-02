//
//  CreateTokenRequest.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

struct CreateTokenRequest: Codable {
    let canRead: Bool
    let canWrite: Bool
    let description: String
}
