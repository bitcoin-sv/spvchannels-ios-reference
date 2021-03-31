//
//  HomeModels.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

enum HomeModels {

    enum CreateSdk {
        struct ViewAction {
            let baseUrl: String
        }
        struct ActionResponse {
            let result: Bool
        }
        struct ResponseDisplay {
            let result: Bool
        }
    }

    enum CreateChannelApi {
        struct ViewAction {
            let accountId: String
            let username: String
            let password: String
        }
        struct ActionResponse {
            let result: Bool
        }
        struct ResponseDisplay {
            let result: Bool
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
            let result: Bool
        }
        struct ResponseDisplay {
            let result: Bool
        }
    }

    enum GetFirebaseToken {
        struct ViewAction {}
        struct ActionResponse {
            let token: String
        }
        struct ResponseDisplay {
            let token: String
        }
    }

}
