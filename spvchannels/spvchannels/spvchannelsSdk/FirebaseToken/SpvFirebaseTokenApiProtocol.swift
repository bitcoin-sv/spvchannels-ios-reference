//
//  SpvFirebaseTokenApiProtocol.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

protocol SpvFirebaseTokenApiProtocol {

    // MARK: FirebaseToken API
    typealias StringResult = (Result<String, Error>) -> Void

    func updateFirebaseToken(token: String,
                             completion: @escaping StringResult)
}
