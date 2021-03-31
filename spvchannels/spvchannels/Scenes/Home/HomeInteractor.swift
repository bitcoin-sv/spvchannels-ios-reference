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
        let baseUrl = UserDefaults.standard.baseUrl ?? ""
        let accountId = UserDefaults.standard.accountId ?? ""
        let username = UserDefaults.standard.username ?? ""
        let password = UserDefaults.standard.password ?? ""
        let channelId = UserDefaults.standard.channelId ?? ""
        let token = UserDefaults.standard.token ?? ""
        presenter?.passSavedCredentials(actionResponse: .init(baseUrl: baseUrl,
                                                              accountId: accountId,
                                                              username: username,
                                                              password: password,
                                                              channelId: channelId,
                                                              token: token))
    }

    func createSdk(viewAction: Models.CreateSdk.ViewAction) {
        spvChannelsSdk = nil
        let firebaseConfigFile = Bundle.main
            .path(forResource: "SPV-FCM-GoogleService-Info",
                  ofType: "plist") ?? ""
        if let sdk = SpvChannelsSdk(firebaseConfig: firebaseConfigFile,
                                    baseUrl: viewAction.baseUrl) {
            spvChannelsSdk = sdk
            UserDefaults.standard.baseUrl = viewAction.baseUrl
        }
        presenter?.createSdk(actionResponse: .init(result: spvChannelsSdk != nil))
    }

    func getFirebaseToken(viewAction: Models.GetFirebaseToken.ViewAction) {
        let token = UserDefaults.standard.firebaseToken ?? "n/a"
        presenter?.getFirebaseToken(actionResponse: .init(token: token))
    }

    func createChannelApi(viewAction: Models.CreateChannelApi.ViewAction) {
        guard spvChannelsSdk != nil else {
            presenter?.presentError(errorMessage: "Initialize SPV Channels SDK first")
            return
        }
        spvChannelApi = nil
        if let channelApi = spvChannelsSdk?.channelWithCredentials(accountId: viewAction.accountId,
                                                              username: viewAction.username,
                                                              password: viewAction.password) {
            spvChannelApi = channelApi
            UserDefaults.standard.accountId = viewAction.accountId
            UserDefaults.standard.username = viewAction.username
            UserDefaults.standard.password = viewAction.password
        }
        presenter?.createChannelApi(actionResponse: .init(result: spvChannelApi != nil))
    }

    func createMessagingApi(viewAction: Models.CreateMessagingApi.ViewAction) {
        guard spvChannelsSdk != nil else {
            presenter?.presentError(errorMessage: "Initialize SPV Channels SDK first")
            return
        }

        spvMessagingApi = nil
        guard let encryption = SpvLibSodiumEncryption(publicKeyString: Constants.bobPublicKey.rawValue,
                                                      secretKeyString: Constants.bobSecretKey.rawValue) else {
            presenter?.presentError(errorMessage: "Could not instantiate LibSodiumEncryption")
            return
        }
        guard encryption.setEncryptionKey(recipientPublicKeyString: Constants.bobPublicKey.rawValue) else {
            presenter?.presentError(errorMessage: "Could not set encryption key")
            return
        }

        if let messagingApi = spvChannelsSdk?.messagingWithToken(channelId: viewAction.channelId,
                                                                 token: viewAction.token,
                                                                 encryption: encryption) {
            spvMessagingApi = messagingApi
            UserDefaults.standard.channelId = viewAction.channelId
            UserDefaults.standard.token = viewAction.token
        }
        presenter?.createMessagingApi(actionResponse: .init(result: spvMessagingApi != nil))
    }

}
