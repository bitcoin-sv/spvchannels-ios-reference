//
//  ChannelsPresenter.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

final class ChannelsPresenter: ChannelsActionResponses {

    typealias Models = ChannelsModels
    weak var viewController: ChannelsResponseDisplays?

    func presentActionResults<T: Encodable>(actionResponse: Models.PerformApiAction.ActionResponse<T>) {
        let jsonString = makeJsonResult(result: actionResponse.result)
        viewController?.displayActionResults(responseDisplay: .init(result: jsonString))
    }

    func presentError(errorMessage: String) {
        viewController?.displayErrorMessage(errorMessage: errorMessage)
    }

    // MARK: - Utility helper
    func makeJsonResult<T: Encodable>(result: Result<T, Error>) -> String {
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
