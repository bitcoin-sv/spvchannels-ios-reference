//
//  ChannelsModels.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Channels API Scene use case value structs for methods as per Clean Swift architecture
enum ChannelsModels {
    enum CreateSdkAndChannelApi {
        struct ViewAction {
            let firebaseConfig: String
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
            let action: ChannelApiAction
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
        struct ActionResponse<T: Encodable> {
            let result: Result<T, Error>
        }
        struct ResponseDisplay {
            let result: String
        }
    }

}
