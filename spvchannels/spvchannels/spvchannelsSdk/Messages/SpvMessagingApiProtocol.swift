//
//  SpvMessagingApiProtocol.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

protocol SpvMessagingApiProtocol {

    // MARK: Messaging API
    typealias StringResult = (Result<String, Error>) -> Void

    func getMaxSequence(completion: @escaping StringResult)
}
