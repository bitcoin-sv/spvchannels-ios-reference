//
//  HomeInteractor.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

final class HomeInteractor: HomeViewActions, HomeDataStore {

    typealias Models = HomeModels

    var presenter: HomeActionResponses?

    // MARK: - DataStore properties
    var spvChannelsSdk: SpvChannelsSdk?
    var spvChannelApi: SpvChannelApi?
    var spvMessagingApi: SpvMessagingApi?

    // MARK: - ViewActions Methods
    func loadSavedCredentials() {
        guard let baseUrl = UserDefaults.standard.baseUrl,
              let accountId = UserDefaults.standard.accountId,
              let username = UserDefaults.standard.username,
              let password = UserDefaults.standard.password
        else { return }
        presenter?.passSavedCredentials(actionResponse: .init(baseUrl: baseUrl,
                                                              accountId: accountId,
                                                              username: username,
                                                              password: password))
    }

    func saveCredentials(baseUrl: String,
                         accountId: String,
                         username: String,
                         password: String) {
        UserDefaults.standard.baseUrl = baseUrl
        UserDefaults.standard.accountId = accountId
        UserDefaults.standard.username = username
        UserDefaults.standard.password = password
    }

    func createSdkAndChannelApi(viewAction: HomeModels.CreateSdkAndChannelApi.ViewAction) {
        spvChannelsSdk = nil
        spvChannelApi = nil
        let firebase = FirebaseConfig(projectId: "pid", appId: "appid", apiKey: "apikey")
        spvChannelsSdk = SpvChannelsSdk(firebase: firebase, baseUrl: viewAction.baseUrl)
        saveCredentials(baseUrl: viewAction.baseUrl,
                        accountId: viewAction.accountId,
                        username: viewAction.username,
                        password: viewAction.password)
        spvChannelApi = spvChannelsSdk?.channelWithCredentials(accountId: viewAction.accountId,
                                                              username: viewAction.username,
                                                              password: viewAction.password)
        if spvChannelsSdk == nil {
            presenter?.presentError(errorMessage: "Could not initialize SPV Channels SDK")
        } else if spvChannelApi != nil {
            presenter?.createSdkAndChannelApi(actionResponse: .init(baseUrl: viewAction.baseUrl,
                                                                    accountId: viewAction.accountId,
                                                                    username: viewAction.username,
                                                                    password: viewAction.password))
        } else {
            presenter?.presentError(errorMessage: "Could not initialize Channels API")
        }
    }

    func createMessagingApiAndOpen(viewAction: HomeModels.CreateMessagingApi.ViewAction) {
        spvMessagingApi = nil
        let encryption = SpvNoOpEncryption()
        spvMessagingApi = spvChannelsSdk?.messagingWithToken(channelId: viewAction.channelId,
                                                             token: viewAction.tokenId,
                                                             encryption: encryption)
        if spvChannelsSdk == nil {
            presenter?.presentError(errorMessage: "Initialize SPV Channels SDK first")
        } else if spvMessagingApi != nil {
            presenter?.createMessagingApiAndOpen(actionResponse: .init(channelId: viewAction.channelId,
                                                                       tokenId: viewAction.tokenId))
        } else {
            presenter?.presentError(errorMessage: "Could not instantiate Messaging API")
        }
    }

}
