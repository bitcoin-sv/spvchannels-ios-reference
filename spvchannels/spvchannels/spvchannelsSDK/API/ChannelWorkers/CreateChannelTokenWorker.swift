//
//  CreateChannelTokenWorker.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class CreateChannelTokenWorker: SpvApiWorker {
    typealias Callback = (Result<ChannelToken, SpvError>) -> Void

    private var baseUrl: String = ""
    private var credentials: SpvCredentials

    private var callback: Callback?
    private var accountId: String = ""
    private var channelId: String = ""
    private var tokenRequest = CreateTokenRequest(canRead: true, canWrite: true, description: "")

    init(baseUrl: String, credentials: SpvCredentials) {
        self.baseUrl = baseUrl
        self.credentials = credentials
    }

    func execute(accountId: String, channelId: String, tokenRequest: CreateTokenRequest, callback: @escaping Callback) {
        self.accountId = accountId
        self.channelId = channelId
        self.tokenRequest = tokenRequest
        self.callback = callback
        execute()
    }

    override func getUrl() -> String {
        let params = ["accountId": accountId, "channelId": channelId]
        guard let partUrl = SpvClientAPI.Endpoint.createChannelToken
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

    override func getParameters() -> [String: Any] {
        return [
            "description": tokenRequest.description,
            "can_read": tokenRequest.canRead,
            "can_write": tokenRequest.canWrite
        ]
    }

    override func getMethod() -> HttpMethod {
        return .post
    }

    override func processResponse(response: HttpResponse) {
        let str = response.responseString
        if let result = ChannelToken.parse(from: str, type: ChannelToken.self) {
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
