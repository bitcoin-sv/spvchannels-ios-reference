//
//  HomeVIP.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import SpvChannelsSdk

/// Home Scene definition and use case methods as per Clean Swift architecture
extension Scenes {
    static let Home = HomeViewController.self
}

protocol HomeViewActions {
    func loadSavedCredentials()
    func createSdk(viewAction: HomeModels.CreateSdk.ViewAction)
    func createChannelApi(viewAction: HomeModels.CreateChannelApi.ViewAction)
    func createMessagingApi(viewAction: HomeModels.CreateMessagingApi.ViewAction)
    func getFirebaseToken(viewAction: HomeModels.GetFirebaseToken.ViewAction)
}

protocol HomeActionResponses {
    func passSavedCredentials(actionResponse: HomeModels.LoadSavedCredentials.ActionResponse)
    func createSdk(actionResponse: HomeModels.CreateSdk.ActionResponse)
    func createChannelApi(actionResponse: HomeModels.CreateChannelApi.ActionResponse)
    func createMessagingApi(actionResponse: HomeModels.CreateMessagingApi.ActionResponse)
    func getFirebaseToken(actionResponse: HomeModels.GetFirebaseToken.ActionResponse)
    func presentError(errorMessage: String)
}

protocol HomeResponseDisplays: AnyObject {
    func displaySavedCredentials(responseDisplay: HomeModels.LoadSavedCredentials.ResponseDisplay)
    func displayCreateSdk(responseDisplay: HomeModels.CreateSdk.ResponseDisplay)
    func displayCreateChannelApi(responseDisplay: HomeModels.CreateChannelApi.ResponseDisplay)
    func displayMessagingApi(responseDisplay: HomeModels.CreateMessagingApi.ResponseDisplay)
    func displayFirebaseToken(responseDisplay: HomeModels.GetFirebaseToken.ResponseDisplay)
    func displayErrorMessage(errorMessage: String)
}

protocol HomeDataStore {
    var spvChannelsSdk: SpvChannelsSdk? { get }
    var spvChannelApi: SpvChannelApi? { get }
    var spvMessagingApi: SpvMessagingApi? { get }
}

protocol HomeRoutes {
    func routeToChannels()
    func routeToMessages()
}

protocol HomeDataPassing {
    var dataStore: HomeDataStore? { get }
}

typealias HomeRouterType = (HomeRoutes & HomeDataPassing & Coordinatable)
