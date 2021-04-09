//
//  HomeRouter.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

class HomeRouter: HomeRouterType {

    weak var coordinator: SceneCoordinator?
    var dataStore: HomeDataStore?

    // MARK: - Router methods

    func routeToChannels() {
        coordinator?.open(Scenes.Channels) { destination in
            guard let sdk = dataStore?.spvChannelsSdk,
                  let channelApi = dataStore?.spvChannelApi else { return false }
            var destDataStore = destination.router?.dataStore
            destDataStore?.spvChannelsSdk = sdk
            destDataStore?.spvChannelApi = channelApi
            return true
        }
    }

    func routeToMessages() {
        coordinator?.open(Scenes.Messaging) { destination in
            guard let sdk = dataStore?.spvChannelsSdk,
                  let messagingApi = dataStore?.spvMessagingApi else { return false }
            var destDataStore = destination.router?.dataStore
            destDataStore?.spvChannelsSdk = sdk
            destDataStore?.spvMessagingApi = messagingApi
            return true
        }
    }

}
