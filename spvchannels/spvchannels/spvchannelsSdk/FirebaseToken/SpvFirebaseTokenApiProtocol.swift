//
//  SpvFirebaseTokenApiProtocol.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

protocol SpvFirebaseTokenApiProtocol {

    // MARK: FirebaseToken API
    typealias StringResult = (Result<String, Error>) -> Void

    func updateFirebaseToken(token: String,
                             completion: @escaping StringResult)
}
