//
//  SpvMessagingEndpoint.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

enum MessagingEndpoint {
    enum Actions: CaseIterable {
        case getMaxSequence, getAllMessages, markMessageRead, sendMessage, deleteMessage

        var actionTitle: String {
            switch self {
            case .getMaxSequence:
                return "Get Max Message Sequence"
            case .getAllMessages:
                return "Get All Messages"
            case .markMessageRead:
                return "Mark Message As Read/Unread"
            case .sendMessage:
                return "Send Message"
            case .deleteMessage:
                return "Delete Message"
            }
        }
    }

    case getMaxSequence
    case getAllMessages(unread: Bool)
    case markMessageRead(sequenceId: String, parameters: [String: Any])
    case sendMessage(contentType: String, payload: Data)
    case deleteMessage(sequenceId: String)
}

extension MessagingEndpoint: RequestProtocol {

    var path: String {
        switch self {
        case .getAllMessages, .getMaxSequence, .sendMessage:
            return ""
        case .markMessageRead(let sequenceId, _):
            return "/\(sequenceId)"
        case .deleteMessage(let sequenceId):
            return "/\(sequenceId)"
        }
    }

    var method: RequestMethod {
        switch self {
        case .getMaxSequence:
            return .head
        case .getAllMessages:
            return .get
        case .markMessageRead, .sendMessage:
            return .post
        case .deleteMessage:
            return .delete
        }
    }

    var headers: RequestHeaders? {
        switch self {
        case .sendMessage(let contentType, _):
            return ["Content-Type": contentType]
        default: return ["Content-Type": "application/json"]
        }
    }

    var parameters: RequestParameters? {
        switch self {
        case .getAllMessages(let unread):
            return unread ? ["unread": true] : nil
        case .markMessageRead(_, let parameters):
            return parameters
        default: return nil
        }
    }

    var rawBody: Data? {
        switch self {
        case .sendMessage(_, let payload):
            return payload
        default: return nil
        }
    }

}
