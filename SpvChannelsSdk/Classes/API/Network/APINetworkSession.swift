//
//  APINetworkSession.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Network abstraction protocol for **dataTask** creation
public protocol NetworkSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol?
}

/// Network abstraction protocol for **dataTask** operation
public protocol URLSessionDataTaskProtocol {
    func resume()
    func cancel()
}

/// Conformance of built-in class to our Network abstraction protocol
extension URLSessionDataTask: URLSessionDataTaskProtocol {}

/**
 Network API abstraction class
 
 - parameter configuration: URLSessionConfiguration used to wrap all network calls into
 
 # Notes: #
 1. In DEBUG mode this class overrides system setting and accepts connections to self-signed SSL equipped servers
 
 */
class APINetworkSession: NSObject, URLSessionDelegate {
    var session: URLSession?

    override convenience init() {
        let sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration.timeoutIntervalForResource = 30
        self.init(configuration: sessionConfiguration)
    }

    public init(configuration: URLSessionConfiguration) {
        super.init()
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }

    #if DEBUG
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
    #endif

    deinit {
        session?.invalidateAndCancel()
        session = nil
    }
}

/// Provide conformance of this concrete class to our network abstraction protocol
extension APINetworkSession: NetworkSessionProtocol {

    func dataTask(with request: URLRequest,
                  completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol? {
        let dataTask = session?.dataTask(with: request) { (data, response, error) in
            completionHandler(data, response, error)
        }
        return dataTask
    }
}
