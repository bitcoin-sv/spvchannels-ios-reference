//
//  MessagingVIP.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension Scenes {
    static let Messaging = MessagingViewController.self
}

protocol MessagingViewActions {
    func getChannelInfo(viewAction: MessagingModels.GetChannelInfo.ViewAction)
    func performAction(viewAction: MessagingModels.PerformApiAction.ViewAction)
}

protocol MessagingActionResponses {
    func presentChannelInfo(actionResponse: MessagingModels.GetChannelInfo.ActionResponse)
    func presentActionResults<T: Encodable>(actionResponse: MessagingModels.PerformApiAction.ActionResponse<T>)
    func presentError(errorMessage: String)
}

protocol MessagingResponseDisplays: AnyObject {
    func displayChannelInfo(responseDisplay: MessagingModels.GetChannelInfo.ResponseDisplay)
    func displayActionResults(responseDisplay: MessagingModels.PerformApiAction.ResponseDisplay)
    func displayErrorMessage(errorMessage: String)
}

protocol MessagingDataStore {
    var spvChannelsSdk: SpvChannelsSdk? { get set }
    var spvMessagingApi: SpvMessagingApi? { get set }
}

protocol MessagingRoutes {
}

protocol MessagingDataPassing {
    var dataStore: MessagingDataStore? { get set }
}

typealias MessagingRouterType = (MessagingRoutes & MessagingDataPassing & Coordinatable)
typealias MessagingInteractorType = (MessagingViewActions & MessagingDataStore)
typealias MessagingViewControllerType = (MessagingResponseDisplays & MessagingDataPassing)
