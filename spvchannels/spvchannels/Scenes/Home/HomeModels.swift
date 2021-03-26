//
//  HomeModels.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

enum HomeModels {

    enum CreateSdkAndChannelApi {
        struct ViewAction {
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

    enum LoadSavedCredentials {
        struct ViewAction {}
        struct ActionResponse {
            let baseUrl: String
            let accountId: String
            let username: String
            let password: String
            let channelId: String
            let token: String
        }
        struct ResponseDisplay {
            let baseUrl: String
            let accountId: String
            let username: String
            let password: String
            let channelId: String
            let token: String
        }
    }

    enum CreateMessagingApi {
        struct ViewAction {
            let channelId: String
            let token: String
        }
        struct ActionResponse {
            let channelId: String
            let tokenId: String
        }
        struct ResponseDisplay {
            let channelId: String
            let tokenId: String
        }
    }

}
