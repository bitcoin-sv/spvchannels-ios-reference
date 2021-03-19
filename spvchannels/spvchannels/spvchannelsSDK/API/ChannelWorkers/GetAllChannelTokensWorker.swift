//
//  GetAllChannelTokensWorker.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class GetAllChannelTokensWorker: SpvApiWorker {
    typealias Callback = (Result<[ChannelToken], SpvError>) -> Void

    private var baseUrl: String = ""
    private var credentials: SpvCredentials

    private var callback: Callback?
    private var accountId: String = ""
    private var channelId: String = ""

    init(baseUrl: String, credentials: SpvCredentials) {
        self.baseUrl = baseUrl
        self.credentials = credentials
    }

    func execute(accountId: String, channelId: String, callback: @escaping Callback) {
        self.accountId = accountId
        self.channelId = channelId
        self.callback = callback
        execute()
    }

    override func getUrl() -> String {
        let params = ["accountId": accountId, "channelId": channelId]
        guard let partUrl = SpvClientApi.Endpoint.getAllChannelTokens
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
        return .get
    }

    override func processResponse(response: HttpResponse) {
        let str = response.responseString
        if let result: [ChannelToken] = .parse(from: str) {
            callback?(.success(result))
        } else {
            if let error = response.error {
                callback?(.failure(error))
            } else {
                callback?(.failure(.badRequest))
            }
        }
    }

}
