//
//  SpvMessagingApiProtocol.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

protocol SpvMessagingApiProtocol {

    // MARK: Messaging API
    typealias StringResult = (Result<String, Error>) -> Void
    typealias MessageResult = (Result<[Message], Error>) -> Void

    func getMaxSequence(completion: @escaping StringResult)
    func getAllMessages(unread: Bool, completion: @escaping MessageResult)
    func markMessageRead(sequenceId: String, read: Bool, older: Bool, completion: @escaping StringResult)
    func deleteMessage(sequenceId: String, completion: @escaping StringResult)
}
