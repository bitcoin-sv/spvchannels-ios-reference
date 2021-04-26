//
//  HomeInteractor.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import SpvChannelsSdk

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
        let onOpenNotification = { [weak self] (message: String, messageTime: String, channelId: String) -> Void in

            let displayMessage = """
            \(message)

            Message time: \(messageTime)

            Channel ID: \(channelId)
            """
            self?.presenter?.presentError(errorMessage: displayMessage)
        }
        let firebaseConfigFile = Bundle.main.path(forResource: Constants.firebaseConfigFile.rawValue,
                                                  ofType: "plist") ?? ""
        if let sdk = SpvChannelsSdk(firebaseConfig: firebaseConfigFile,
                                    baseUrl: viewAction.baseUrl,
                                    openNotification: onOpenNotification) {
            spvChannelsSdk = sdk
            UserDefaults.standard.baseUrl = viewAction.baseUrl
        }
        presenter?.createSdk(actionResponse: .init(result: spvChannelsSdk != nil))
    }

    func getFirebaseToken(viewAction: Models.GetFirebaseToken.ViewAction) {
        guard spvChannelsSdk != nil else {
            presenter?.getFirebaseToken(actionResponse: .init(token: "n/a"))
            return
        }
        let token = spvChannelsSdk?.firebaseToken ?? "n/a"
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

        var encryptionService: SpvEncryptionProtocol?
        if viewAction.encryption {
            if let encryptionClass = SpvLibSodiumEncryption(publicKeyString: Constants.bobPublicKey.rawValue,
                                                            secretKeyString: Constants.bobSecretKey.rawValue),
               encryptionClass.setEncryptionKey(recipientPublicKeyString: Constants.bobPublicKey.rawValue) {
                encryptionService = encryptionClass
            } else {
                presenter?.presentError(errorMessage: "Could not create encryption class and set key")
                return
            }
        } else {
            encryptionService = SpvNoOpEncryption()
        }

        if let messagingApi = spvChannelsSdk?.messagingWithToken(channelId: viewAction.channelId,
                                                                 token: viewAction.token,
                                                                 encryption: encryptionService) {
            spvMessagingApi = messagingApi
            UserDefaults.standard.channelId = viewAction.channelId
            UserDefaults.standard.token = viewAction.token
        }
        presenter?.createMessagingApi(actionResponse: .init(result: spvMessagingApi != nil))
    }

}
