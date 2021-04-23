//
//  MessagingApiAction.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// UI action selection strings
enum MessagingApiAction: CaseIterable {
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
