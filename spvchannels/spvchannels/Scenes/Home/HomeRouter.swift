//
//  HomeRouter.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

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
                  let channelApi = dataStore?.spvMessagingApi else { return false }
            var destDataStore = destination.router?.dataStore
            destDataStore?.spvChannelsSdk = sdk
            destDataStore?.spvMessagingApi = channelApi
            return true
        }
    }

}
