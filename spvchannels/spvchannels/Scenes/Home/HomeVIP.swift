//
//  HomeVIP.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension Scenes {
    static let Home = HomeViewController.self
}

protocol HomeViewActions {
    func loadSavedCredentials()
    func createSdkAndChannelApi(viewAction: HomeModels.CreateSdkAndChannelApi.ViewAction)
    func createMessagingApiAndOpen(viewAction: HomeModels.CreateMessagingApi.ViewAction)
}

protocol HomeActionResponses {
    func passSavedCredentials(actionResponse: HomeModels.LoadSavedCredentials.ResponseDisplay)
    func createSdkAndChannelApi(actionResponse: HomeModels.CreateSdkAndChannelApi.ActionResponse)
    func createMessagingApiAndOpen(actionResponse: HomeModels.CreateMessagingApi.ViewAction)
    func presentError(errorMessage: String)
}

protocol HomeResponseDisplays: AnyObject {
    func displaySavedCredentials(responseDisplay: HomeModels.LoadSavedCredentials.ResponseDisplay)
    func displayCreateSdkAndOpenChannels(responseDisplay: HomeModels.CreateSdkAndChannelApi.ResponseDisplay)
    func displayMessagingApiAndOpen(responseDisplay: HomeModels.CreateMessagingApi.ViewAction)
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
