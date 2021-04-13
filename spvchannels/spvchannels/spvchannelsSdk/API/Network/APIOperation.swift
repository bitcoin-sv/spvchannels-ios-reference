//
//  APIOperation.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Abstraction protocol for performing API call operation (high level)
protocol OperationProtocol {
    associatedtype Output

    var request: RequestProtocol { get }
    func execute(in requestDispatcher: RequestDispatcherProtocol, completion: @escaping (Output) -> Void)
    func cancel()
}

enum OperationResult {
    case data(Data?, _ : HTTPURLResponse?)
    case error(Error?, _ : HTTPURLResponse?)
}

/// Concrete class for executing network API call operation
class APIOperation: OperationProtocol {
    typealias Output = OperationResult

    private var task: URLSessionDataTaskProtocol?
    internal var request: RequestProtocol
    init(_ request: RequestProtocol) {
        self.request = request
    }

    func cancel() {
        task?.cancel()
    }

    func execute(in requestDispatcher: RequestDispatcherProtocol, completion: @escaping (OperationResult) -> Void) {
        task = requestDispatcher.execute(request: request) { result in
            completion(result)
        }
    }
}
