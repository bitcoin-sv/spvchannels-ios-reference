//
//  RevokeChannelTokenWorker.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class RevokeChannelTokenWorker: SpvApiWorker {
    typealias Callback = (Result<Void, SpvError>) -> Void

    private var baseUrl: String = ""
    private var credentials: SpvCredentials

    private var callback: Callback?
    private var accountId: String = ""
    private var channelId: String = ""
    private var tokenId: String = ""

    init(baseUrl: String, credentials: SpvCredentials) {
        self.baseUrl = baseUrl
        self.credentials = credentials
    }

    func execute(accountId: String, channelId: String, tokenId: String, callback: @escaping Callback) {
        self.accountId = accountId
        self.channelId = channelId
        self.tokenId = tokenId
        self.callback = callback
        execute()
    }

    override func getUrl() -> String {
        let params = ["accountId": accountId, "channelId": channelId, "tokenId": tokenId]
        guard let partUrl = SpvClientApi.Endpoint.revokeChannelToken
                .buildUrl(params: params, queries: [:]) else { return "" }
        return baseUrl.appending(partUrl.absoluteString)
    }

    override func getHeaders() -> [String: String] {
        if let basicAuth = credentials.basicAuth() {
            return ["Authorization": basicAuth]
        } else {
            return [:]
        }
    }

    override func getMethod() -> HttpMethod {
        return .delete
    }

    override func processResponse(response: HttpResponse) {
        if let error = response.error {
            callback?(.failure(error))
        } else {
            callback?(.success(()))
        }
    }

}
