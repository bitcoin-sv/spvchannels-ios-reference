//
//  CreateChannelsWorker.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class CreateChannelWorker: SpvApiWorker {
    typealias Callback = (Result<ChannelInfo, SpvError>) -> Void

    private var baseUrl: String = ""
    private var credentials: SpvCredentials

    private var callback: Callback?
    private var accountId: String = ""

    init(baseUrl: String, credentials: SpvCredentials) {
        self.baseUrl = baseUrl
        self.credentials = credentials
    }

    func execute(accountId: String, callback: @escaping Callback) {
        self.accountId = accountId
        self.callback = callback
        execute()
    }

    override func getUrl() -> String {
        let params = ["accountId": accountId]
        guard let partUrl = SpvClientApi.Endpoint.createChannel
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
        return .post
    }

    override func processResponse(response: HttpResponse) {
        let str = response.responseString
        if let result: ChannelInfo = .parse(from: str) {
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
