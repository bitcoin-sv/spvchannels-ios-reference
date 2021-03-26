//
//  SpvMessagingEndpoint.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

enum MessagingEndpoint {
    enum Actions: CaseIterable {
        case getMaxSequence, sendMessage, getAllMessages, markMessageRead, deleteMessage

        var actionTitle: String {
            switch self {
            case .getMaxSequence:
                return "Get Max Message Sequence"
            case .sendMessage:
                return "Write Message"
            case .getAllMessages:
                return "Get Messages"
            case .markMessageRead:
                return "Mark Message As Read/Unread"
            case .deleteMessage:
                return "Delete Message"
            }
        }
    }

    case getMaxSequence
}

extension MessagingEndpoint: RequestProtocol {

    var path: String {
        switch self {
        case .getMaxSequence:
            return ""
        }
    }

    var method: RequestMethod {
        switch self {
        case .getMaxSequence:
            return .head
        }
    }

    var headers: RequestHeaders? {
        nil
    }

    var parameters: RequestParameters? {
        switch self {
        case .getMaxSequence:
            return nil
        }
    }

}
