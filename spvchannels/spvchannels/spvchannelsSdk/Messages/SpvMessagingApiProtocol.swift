//
//  SpvMessagingApiProtocol.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Types and methods of the Messaging API facilitating network API calls
protocol SpvMessagingApiProtocol {

    // MARK: Messaging API
    typealias StringResult = (Result<String, Error>) -> Void
    typealias MessageResult = (Result<Message, Error>) -> Void
    typealias MessagesResult = (Result<[Message], Error>) -> Void

    func getMaxSequence(completion: @escaping StringResult)
    func getAllMessages(unread: Bool, completion: @escaping MessagesResult)
    func markMessageRead(sequenceId: String, read: Bool, older: Bool, completion: @escaping StringResult)
    func deleteMessage(sequenceId: String, completion: @escaping StringResult)
    func sendMessage(contentType: String, payload: Data, completion: @escaping MessageResult)
}
