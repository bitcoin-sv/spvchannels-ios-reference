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
    func passSavedCredentials(actionResponse: Models.LoadSavedCredentials.ActionResponse) {
        viewController?.displaySavedCredentials(responseDisplay: .init(baseUrl: actionResponse.baseUrl,
                                                                       accountId: actionResponse.accountId,
                                                                       username: actionResponse.username,
                                                                       password: actionResponse.password,
                                                                       channelId: actionResponse.channelId,
                                                                       token: actionResponse.token))
    }

    func createSdk(actionResponse: Models.CreateSdk.ActionResponse) {
        viewController?.displayCreateSdk(responseDisplay: .init(result: actionResponse.result))
    }

    func getFirebaseToken(actionResponse: Models.GetFirebaseToken.ActionResponse) {
        viewController?.displayFirebaseToken(responseDisplay: .init(token: actionResponse.token))
    }

    func createChannelApi(actionResponse: Models.CreateChannelApi.ActionResponse) {
        viewController?.displayCreateChannelApi(responseDisplay: .init(result: actionResponse.result))
    }

    func createMessagingApi(actionResponse: Models.CreateMessagingApi.ActionResponse) {
        viewController?.displayMessagingApi(responseDisplay: .init(result: actionResponse.result))
    }

    func presentError(errorMessage: String) {
        viewController?.displayErrorMessage(errorMessage: errorMessage)
    }

}
