//
//  ChannelsVIP.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

extension Scenes {
    static let Channels = ChannelsViewController.self
}

protocol ChannelsViewActions {
    func performAction(viewAction: ChannelsModels.PerformApiAction.ViewAction)
}

protocol ChannelsActionResponses {
    func presentActionResults<T: Encodable>(actionResponse: ChannelsModels.PerformApiAction.ActionResponse<T>)
    func presentError(errorMessage: String)
}

protocol ChannelsResponseDisplays: AnyObject {
    func displayActionResults(responseDisplay: ChannelsModels.PerformApiAction.ResponseDisplay)
    func displayErrorMessage(errorMessage: String)
}

protocol ChannelsDataStore {
    var spvChannelsSdk: SpvChannelsSdk? { get set }
    var spvChannelApi: SpvChannelApi? { get set }
}

protocol ChannelsRoutes {
}

protocol ChannelsDataPassing {
    var dataStore: ChannelsDataStore? { get set }
}

typealias ChannelsRouterType = (ChannelsRoutes & ChannelsDataPassing & Coordinatable)
typealias ChannelsInteractorType = (ChannelsViewActions & ChannelsDataStore)
