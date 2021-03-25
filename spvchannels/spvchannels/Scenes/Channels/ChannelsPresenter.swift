//
//  ChannelsPresenter.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

final class ChannelsPresenter: ChannelsActionResponses {

    typealias Models = ChannelsModels
    weak var viewController: ChannelsResponseDisplays?

    func presentActionResults(actionResponse: Models.PerformApiAction.ActionResponse) {
        viewController?.displayActionResults(responseDisplay: .init(result: actionResponse.result))
    }

    func presentError(errorMessage: String) {
        viewController?.displayErrorMessage(errorMessage: errorMessage)
    }

}
