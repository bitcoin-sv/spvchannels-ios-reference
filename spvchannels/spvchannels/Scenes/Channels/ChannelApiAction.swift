//
//  ChannelApiAction.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// UI action selection strings
enum ChannelApiAction: CaseIterable {
    case getAllChannels, getChannel, createChannel, amendChannel, deleteChannel, getAllChannelTokens
    case getChannelToken, createChannelToken, revokeChannelToken, disableAllNotifications

    var actionTitle: String {
        switch self {
        case .getAllChannels:
            return "List All Channels"
        case .getChannel:
            return "Get Channel"
        case .createChannel:
            return "Create Channel"
        case .deleteChannel:
            return "Delete Channel"
        case .amendChannel:
            return "Amend Channel"
        case .getAllChannelTokens:
            return "Get All Channel Tokens"
        case .getChannelToken:
            return "Get Channel Token"
        case .createChannelToken:
            return "Generate Channel Token"
        case .revokeChannelToken:
            return "Revoke Channel Token"
        case .disableAllNotifications:
            return "Disable all Push Notifications"
        }
    }
}
