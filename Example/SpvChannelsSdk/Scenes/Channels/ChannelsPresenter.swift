//
//  ChannelsPresenter.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import SpvChannelsSdk

final class ChannelsPresenter: ChannelsActionResponses {

    typealias Models = ChannelsModels
    weak var viewController: ChannelsResponseDisplays?

    // MARK: - Action Responses
    func presentActionResults<T: Encodable>(actionResponse: Models.PerformApiAction.ActionResponse<T>) {
        let jsonString = makeJsonResult(result: actionResponse.result)
        viewController?.displayActionResults(responseDisplay: .init(result: jsonString))
    }

    func presentError(errorMessage: String) {
        viewController?.displayErrorMessage(errorMessage: errorMessage)
    }

    // MARK: - Utility helpers
    private func makeJsonResult<T: Encodable>(result: Result<T, Error>) -> String {
        var resultStr: String
        switch result {
        case .success(let channel):
            resultStr = channel.jsonString()
        case .failure(let error):
            resultStr = "ERROR: " + APIError.getErrorDescription(from: error)
        }
        return resultStr
    }

}
