//
//  MessagingModels.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Messaging Scene use case value structs for methods as per Clean Swift architecture
enum MessagingModels {
    enum GetChannelInfo {
        struct ViewAction {}
        struct ActionResponse {
            let channelId: String
            let tokenId: String
        }
        struct ResponseDisplay {
            let channelId: String
            let tokenId: String
        }
    }

    enum PerformApiAction {
        struct ViewAction {
            let action: MessagingApiAction
            let contentType: String
            let sequenceId: String
            let payload: String
            let unreadOnly: Bool
            let markReadUnread: Bool
            let markOlderMessages: Bool
        }
        struct ActionResponse<T: Encodable> {
            let result: Result<T, Error>
        }
        struct ResponseDisplay {
            let result: String
        }
    }

}
