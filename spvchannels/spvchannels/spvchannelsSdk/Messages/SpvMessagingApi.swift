//
//  SpvMessagingApi.swift
//  spvChannels
//  Created by Equaleyes Solutions
//

import Foundation

class SpvMessagingApi {
    let channelId: String
    let token: String
    let encryptionService: SpvEncryptionProtocol

    let requestDispatcher: RequestDispatcherProtocol

    init(baseUrl: String, channelId: String, token: String, encryption: SpvEncryptionProtocol,
         networkSession: NetworkSessionProtocol = APINetworkSession()) {
        self.channelId = channelId
        self.token = token
        self.encryptionService = encryption
        let baseUrlWithSuffix = baseUrl + "/api/v1/channel/\(channelId)"
        let env = SpvMessagingApiEnvironment(baseUrl: baseUrlWithSuffix,
                                            token: token)
        requestDispatcher = APIRequestDispatcher(environment: env,
                                                 networkSession: networkSession)
    }
}

extension SpvMessagingApi: SpvMessagingApiProtocol {

    func getMaxSequence(completion: @escaping StringResult) {
        let messagingRequest = MessagingEndpoint.getMaxSequence
        let operation = APIOperation(messagingRequest)

        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data(_, let urlResponse):
                if let value = urlResponse?.value(forHTTPHeaderField: "ETag") {
                    completion(.success(value))
                } else {
                    completion(.failure(APIError.invalidResponse("No ETag header value")))
                }
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    func getAllMessages(unread: Bool, completion: @escaping MessageResult) {
        let messagingRequest = MessagingEndpoint.getAllMessages(unread: unread)
        let operation = APIOperation(messagingRequest)
        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data(let data, _):
                if let data = data,
                   let result: [Message] = .parse(from: data) {
                    let decrypted = result.map { $0.decrypted(with: self.encryptionService) }
                    completion(.success(decrypted))
                } else {
                    completion(.failure(APIError.parseError("JSON error")))
                }
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

}
