//
//  MessagingPresenter.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

final class MessagingPresenter: MessagingActionResponses {

    typealias Models = MessagingModels
    weak var viewController: MessagingResponseDisplays?

    // MARK: - Action Responses
    func presentChannelInfo(actionResponse: Models.GetChannelInfo.ActionResponse) {
        viewController?.displayChannelInfo(responseDisplay: .init(channelId: actionResponse.channelId,
                                                                  tokenId: actionResponse.tokenId))
    }

    func presentActionResults<T: Encodable>(actionResponse: Models.PerformApiAction.ActionResponse<T>) {
        let jsonString = makeJsonResult(result: actionResponse.result)
        viewController?.displayActionResults(responseDisplay: .init(result: jsonString))
    }

    func presentError(errorMessage: String) {
        viewController?.displayErrorMessage(errorMessage: errorMessage)
    }

    // MARK: - Utility helper
    private func makeJsonResult<T: Encodable>(result: Result<T, Error>) -> String {
        var resultStr: String
        switch result {
        case .success(let item):
            resultStr = item.jsonString()
        case .failure(let error):
            resultStr = "ERROR: " + APIError.getErrorDescription(from: error)
        }
        return resultStr
    }

}
