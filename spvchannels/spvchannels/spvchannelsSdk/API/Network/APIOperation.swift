//
//  APIOperation.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

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

class APIOperation: OperationProtocol {
    typealias Output = OperationResult

    private var task: URLSessionTask?
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
