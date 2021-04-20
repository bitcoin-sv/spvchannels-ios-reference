//
//  SpvMessagingEndpoint.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Messaging API endpoint definition
enum MessagingEndpoint {

    /// UI action selection strings
    enum Actions: CaseIterable {
        case getMaxSequence, getAllMessages, markMessageRead, sendMessage, deleteMessage, registerForPushNotifications,
             deregisterNotifications

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
            case .registerForPushNotifications:
                return "Register channel for push"
            case .deregisterNotifications:
                return "Deregister channel from push"
            }
        }
    }

    /// Messaging API call parameter definitions
    case getMaxSequence
    case getAllMessages(unread: Bool)
    case markMessageRead(sequenceId: String, urlParameters: [String: Any], bodyParameters: [String: Any])
    case sendMessage(contentType: String, payload: Data)
    case deleteMessage(sequenceId: String)
}

extension MessagingEndpoint: RequestProtocol {

    /// URL path of each API call
    var path: String {
        switch self {
        case .getAllMessages, .getMaxSequence, .sendMessage:
            return ""
        case .markMessageRead(let sequenceId, _, _):
            return "/\(sequenceId)"
        case .deleteMessage(let sequenceId):
            return "/\(sequenceId)"
        }
    }

    /// HTTP method of each API call
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

    /// Additional HTTP headers of each API call
    var headers: RequestHeaders? {
        switch self {
        case .sendMessage(let contentType, _):
            return ["Content-Type": contentType]
        default: return ["Content-Type": "application/json"]
        }
    }

    /// HTTP request URL parameters of each API call
    var urlParameters: RequestParameters? {
        switch self {
        case .getAllMessages(let unread):
            return unread ? ["unread": true] : nil
        case .markMessageRead(_, let urlParameters, _):
            return urlParameters
        default: return nil
        }
    }

    /// HTTP JSON body parameters of each API call
    var bodyParameters: RequestParameters? {
        switch self {
        case .markMessageRead(_, _, let bodyParameters):
            return bodyParameters
        default: return nil
        }
    }

    /// HTTP raw data body of each specific API call
    var rawBody: Data? {
        switch self {
        case .sendMessage(_, let payload):
            return payload
        default: return nil
        }
    }

}
