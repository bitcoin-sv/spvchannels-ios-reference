//
//  AmendChannelWorker.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class AmendChannelWorker: SpvApiWorker {
    typealias Callback = (Result<Void, SpvError>) -> Void

    private var baseUrl: String = ""
    private var credentials: SpvCredentials

    private var callback: Callback?
    private var accountId: String = ""
    private var channelId: String = ""
    private var channelPermissions = ChannelPermissions(publicRead: true, publicWrite: true, locked: false)

    init(baseUrl: String, credentials: SpvCredentials) {
        self.baseUrl = baseUrl
        self.credentials = credentials
    }

    func execute(accountId: String, channelId: String, permissions: ChannelPermissions, callback: @escaping Callback) {
        self.accountId = accountId
        self.channelId = channelId
        self.channelPermissions = permissions
        self.callback = callback
        execute()
    }

    override func getUrl() -> String {
        let params = ["accountId": accountId, "channelId": channelId]
        guard let partUrl = SpvClientApi.Endpoint.amendChannel
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
            "public_read": channelPermissions.publicRead,
            "public_write": channelPermissions.publicWrite,
            "locked": channelPermissions.locked
        ]
    }

    override func getMethod() -> HttpMethod {
        return .post
    }

    override func processResponse(response: HttpResponse) {
        if let error = response.error {
            callback?(.failure(error))
        } else {
            callback?(.success(()))
        }
    }

}
