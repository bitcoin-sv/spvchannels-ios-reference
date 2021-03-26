//
//  MessagingModels.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

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
            let action: MessagingEndpoint.Actions
            let contentType: String
            let messageId: String
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
