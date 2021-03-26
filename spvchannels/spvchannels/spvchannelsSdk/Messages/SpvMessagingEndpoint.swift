//
//  SpvMessagingEndpoint.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

enum MessagingEndpoint {
    enum Actions: CaseIterable {
        case getAllMessages, getMaxSequence, sendMessage, markMessageRead, deleteMessage

        var actionTitle: String {
            switch self {
            case .getAllMessages:
                return "Get All Messages"
            case .getMaxSequence:
                return "Get Max Message Sequence"
            case .sendMessage:
                return "Write Message"
            case .markMessageRead:
                return "Mark Message As Read/Unread"
            case .deleteMessage:
                return "Delete Message"
            }
        }
    }

    case getMaxSequence
    case getAllMessages(unread: Bool)

}

extension MessagingEndpoint: RequestProtocol {

    var path: String {
        switch self {
        case .getMaxSequence:
            return ""
        case .getAllMessages:
            return ""
        }
    }

    var method: RequestMethod {
        switch self {
        case .getMaxSequence:
            return .head
        case .getAllMessages:
            return .get
        }
    }

    var headers: RequestHeaders? {
        nil
    }

    var parameters: RequestParameters? {
        switch self {
        case .getMaxSequence:
            return nil
        case .getAllMessages(let unread):
            return unread ? ["unread": "true"] : nil
        }
    }

}
