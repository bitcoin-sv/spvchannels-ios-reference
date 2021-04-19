//
//  SpvMessagingApi.swift
//  spvChannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Class for executing Messaging API network calls
class SpvMessagingApi {
    let requestDispatcher: RequestDispatcherProtocol

    let channelId: String
    let token: String
    let encryptionService: SpvEncryptionProtocol

    private let notificationService: SpvFirebaseTokenApiProtocol?

    /**
     Class for executing Messaging API network calls
     The Messaging APIs allow account holders, third parties, or even general public to read from
     or write to a SPV channels server
     
     - parameter baseUrl: retrieved from the SpvChannelSdk class
     - parameter channelId: channel ID on the server
     - parameter token: channel token to use with bearer authentication
     - parameter encryption: class that provides encryption/decryption of message payload
     - parameter networkSession: class corresponding to NetworkSessionProtocol to use for calls
     - parameter notificationService: class corresponding to SpvFirebaseTokenApiProtocol to use for push token API
     - warning: The credentials provided are not checked at Channel API initialization time

     # Notes: #
     Providing your own class to networkSession allows you perform unit testing with mock network responses
     
     # Example #
     ```
     let msgApi = spvChannelsSdk?.messagingWithToken(channelId: channelId,
                                                     token: token)
     ```
     */
    init(baseUrl: String, channelId: String, token: String, notificationService: SpvFirebaseTokenApiProtocol?,
         encryption: SpvEncryptionProtocol, networkSession: NetworkSessionProtocol) {
        self.channelId = channelId
        self.token = token
        self.notificationService = notificationService
        self.encryptionService = encryption
        let baseUrlWithSuffix = baseUrl + "/api/v1/channel/\(channelId)"
        let env = SpvMessagingApiEnvironment(baseUrl: baseUrlWithSuffix,
                                            token: token)
        requestDispatcher = APIRequestDispatcher(environment: env, networkSession: networkSession)
    }

    convenience init(baseUrl: String, channelId: String, token: String,
                     notificationService: SpvFirebaseTokenApiProtocol? = nil, encryption: SpvEncryptionProtocol) {
        self.init(baseUrl: baseUrl, channelId: channelId, token: token, notificationService: notificationService,
                  encryption: encryption, networkSession: APINetworkSession())
    }
}

extension SpvMessagingApi: SpvMessagingApiProtocol {

    /**
     Registers current FCM token to receive push notification for current channel
     
     - parameter completion: Code block to execute with result when response is received
     - returns: A string with a value

     # Example #
     ```
     spvMessagingApi.registerForNotifications { result in
        if case let .success(data) = result {
            print(data)
        }
     }
     ```
     */
    func registerForNotifications(completion: @escaping StringResult) {
        guard let currentToken = UserDefaults.standard.firebaseToken else {
            completion(.failure(APIError.badRequest("No Firebase token stored")))
            return
        }
        notificationService?.registerFcmToken(fcmToken: currentToken, channelToken: token, completion: completion)
    }

    /**
     Deregisters current FCM token, stop receiving push notifications for current channel
     
     - parameter completion: Code block to execute with result when response is received
     - returns: A string with a value

     # Example #
     ```
     spvMessagingApi.deregisterNotifications { result in
        if case let .success(data) = result {
            print(data)
        }
     }
     ```
     */
    func deregisterNotifications(completion: @escaping StringResult) {
        guard let currentToken = UserDefaults.standard.firebaseToken else {
            completion(.failure(APIError.badRequest("No Firebase token stored")))
            return
        }
        notificationService?.deleteToken(oldToken: currentToken, channelId: channelId, completion: completion)
    }

    /**
     Retrieves the current max sequence in current channel
     
     - parameter completion: Code block to execute with result when response is received
     - returns: A string with a value

     # Notes: #
     Sequence is observed per access token

     # Example #
     ```
     spvMessagingApi.getMaxSequence { result in
        if case let .success(data) = result {
            print(data)
        }
     }
     ```
     */
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

    /**
     Retrieves all messages from current channel, optionally filtered to just unread
     
     - parameter unread: Whether to retrieve all or unread messages only
     - parameter completion: Code block to execute with result when response is received
     - returns: An array of messages in type [Message]

     # Notes: #
     Message payloads will automatically be decrypted. Upon decryption failure on any of the
     payloads the call will fail.

     # Example #
     ```
     spvMessagingApi.getAllMessages(unread: true) { result in
        if case let .success(data) = result {
            print(data.count)
        }
     }
     ```
     */
    func getAllMessages(unread: Bool, completion: @escaping MessagesResult) {
        let messagingRequest = MessagingEndpoint.getAllMessages(unread: unread)
        let operation = APIOperation(messagingRequest)
        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data(let data, _):
                if let data = data,
                   let result: [Message] = .parse(from: data) {
                    let decrypted = result.compactMap({ $0.decrypted(with: self.encryptionService) })
                    if result.count != decrypted.count {
                        completion(.failure(APIError.encryptionError))
                    } else {
                        completion(.success(decrypted))
                    }
                } else {
                    completion(.failure(APIError.parseError("JSON error")))
                }
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    /**
     Marks a message as read or unread, optionally mark older messages as well
     
     - parameter sequenceId: Message sequence number
     - parameter read: whether to mark message(s) as read or unread
     - parameter older: whether to mark older messages as well
     - parameter completion: Code block to execute with result when response is received
     - returns: success or failure status

     # Example #
     ```
     spvMessagingApi.markMessageRead(sequenceId: seqId,
                                     read: true,
                                     older: false) { result in
        if case .success = result {
            print("message marked successfully")
        }
     }
     ```
     */
    func markMessageRead(sequenceId: String, read: Bool, older: Bool, completion: @escaping StringResult) {
        let bodyParameters: [String: Any] = ["read": read]
        let urlParameters: [String: Any] = ["older": older]
        let messagingRequest = MessagingEndpoint.markMessageRead(sequenceId: sequenceId,
                                                                 urlParameters: urlParameters,
                                                                 bodyParameters: bodyParameters)
        let operation = APIOperation(messagingRequest)

        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data:
                completion(.success("OK"))
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    /**
     Delete a message from a channel
     
     - parameter sequenceId: Message sequence number to delete
     - parameter completion: Code block to execute with result when response is received
     - warning: There is no undo for this operation!
     - returns: success or failure status

     # Example #
     ```
     spvMessagingApi.deleteMessage(sequenceId: seqId) { result in
        if case .success = result {
            print("message deleted successfully")
        }
     }
     ```
     */
    func deleteMessage(sequenceId: String, completion: @escaping StringResult) {
        let messagingRequest = MessagingEndpoint.deleteMessage(sequenceId: sequenceId)
        let operation = APIOperation(messagingRequest)

        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data:
                completion(.success("OK"))
            case .error(let error, _):
                operation.cancel()
                completion(.failure(error ?? APIError.unknown))
            }
        }
    }

    /**
     Sends a message to a channel
     
     - parameter contentType: Message payload MIME content-type to be used
     - parameter payload: Message payload contents
     - parameter completion: Code block to execute with result when response is received
     - returns: Single message with metadata and payload in type Message

     # Notes: #
     Message payload will automatically be encrypted. If encryption fails, the call will fail and nothing is sent.

     # Example #
     ```
     let contentType = "text/plain"
     let messagePayload = "Lorem ipsum".data(using: .utf8)!
     
     spvMessagingApi.sendMessage(contentType: contentType,
                                 payload: messagePayload) { result in
        if case let .success(data) = result {
            print(data.received)
        }
     }
     ```
     */
    func sendMessage(contentType: String, payload: Data, completion: @escaping MessageResult) {
        guard let encrypted = encryptionService.encrypt(input: payload) else {
            completion(.failure(APIError.encryptionError))
            return
        }
        let messagingRequest = MessagingEndpoint.sendMessage(contentType: contentType, payload: encrypted)
        let operation = APIOperation(messagingRequest)

        operation.execute(in: requestDispatcher) { result in
            switch result {
            case .data(let data, _):
                if let data = data,
                   let result: Message = .parse(from: data) {
                    completion(.success(result))
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
