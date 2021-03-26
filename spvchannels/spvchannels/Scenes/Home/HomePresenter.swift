//
//  HomePresenter.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

final class HomePresenter: HomeActionResponses {

    typealias Models = HomeModels
    weak var viewController: HomeResponseDisplays?

    // MARK: - ActionResponses
    func passSavedCredentials(actionResponse: HomeModels.LoadSavedCredentials.ResponseDisplay) {
        viewController?.displaySavedCredentials(responseDisplay: .init(baseUrl: actionResponse.baseUrl,
                                                                       accountId: actionResponse.accountId,
                                                                       username: actionResponse.username,
                                                                       password: actionResponse.password,
                                                                       channelId: actionResponse.channelId,
                                                                       token: actionResponse.token))
    }

    func createSdkAndChannelApi(actionResponse: HomeModels.CreateSdkAndChannelApi.ActionResponse) {
        viewController?.displayCreateSdkAndOpenChannels(responseDisplay: .init(baseUrl: actionResponse.baseUrl,
                                                                               accountId: actionResponse.accountId,
                                                                               username: actionResponse.username,
                                                                               password: actionResponse.password))
    }

    func createMessagingApiAndOpen(actionResponse: HomeModels.CreateMessagingApi.ViewAction) {
        viewController?.displayMessagingApiAndOpen(responseDisplay: .init(channelId: actionResponse.channelId,
                                                                          token: actionResponse.token))
    }

    func presentError(errorMessage: String) {
        viewController?.displayErrorMessage(errorMessage: errorMessage)
    }

}
