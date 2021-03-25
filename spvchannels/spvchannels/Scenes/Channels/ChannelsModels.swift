//
//  ChannelsModels.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

enum ChannelsModels {
    enum CreateSdkAndChannelApi {
        struct ViewAction {
            let firebase: FirebaseConfig
            let baseUrl: String
            let accountId: String
            let username: String
            let password: String
        }
        struct ActionResponse {
            let baseUrl: String
            let accountId: String
            let username: String
            let password: String
        }
        struct ResponseDisplay {
            let baseUrl: String
            let accountId: String
            let username: String
            let password: String
        }
    }

    enum SavedCredentials {
        struct ViewAction {}
        struct ActionResponse {
            let baseUrl: String
            let accountId: String
            let username: String
            let password: String
        }
        struct ResponseDisplay {
            let baseUrl: String
            let accountId: String
            let username: String
            let password: String
        }
    }

    enum PerformApiAction {
        struct ViewAction {
            let action: ChannelsEndpoint.Actions
            let publicRead: Bool
            let publicWrite: Bool
            let locked: Bool
            let sequenced: Bool
            let channelId: String
            let tokenId: String
            let tokenDescription: String
            let minAge: String
            let maxAge: String
            let autoPrune: Bool
        }
        struct ActionResponse {
            let result: String
        }
        struct ResponseDisplay {
            let result: String
        }
    }

}
