//
//  APIRequestDispatcher.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

protocol RequestDispatcherProtocol {
    init(environment: EnvironmentProtocol, networkSession: NetworkSessionProtocol)
    func execute(request: RequestProtocol,
                 completion: @escaping (OperationResult) -> Void) -> URLSessionDataTaskProtocol?
}

class APIRequestDispatcher: RequestDispatcherProtocol {
    private var environment: EnvironmentProtocol
    private var networkSession: NetworkSessionProtocol

    required init(environment: EnvironmentProtocol, networkSession: NetworkSessionProtocol) {
        self.environment = environment
        self.networkSession = networkSession
    }

    func execute(request: RequestProtocol,
                 completion: @escaping (OperationResult) -> Void) -> URLSessionDataTaskProtocol? {
        guard var urlRequest = request.urlRequest(with: environment) else {
            completion(.error(APIError.badRequest("Invalid URL for: \(request)"), nil))
            return nil
        }
        environment.headers?.forEach({ (key: String, value: String) in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        })

        var task: URLSessionDataTaskProtocol?
        task = networkSession.dataTask(with: urlRequest) { [weak self] (data, urlResponse, error) in
            self?.handleDataTaskResponse(data: data, urlResponse: urlResponse, error: error, completion: completion)
        }
        task?.resume()
        return task
    }

    private func handleDataTaskResponse(data: Data?, urlResponse: URLResponse?, error: Error?,
                                        completion: @escaping (OperationResult) -> Void) {
        guard let urlResponse = urlResponse as? HTTPURLResponse else {
            DispatchQueue.main.async {
                completion(OperationResult.error(error, nil))
            }
            return
        }
        let result = verify(data: data, urlResponse: urlResponse, error: error)
        switch result {
        case .success:
            DispatchQueue.main.async {
                completion(OperationResult.data(data, urlResponse))
            }
        case .failure(let error):
            DispatchQueue.main.async {
                completion(OperationResult.error(error, urlResponse))
            }
        }
    }

    private func verify(data: Any?, urlResponse: HTTPURLResponse, error: Error?) -> Result<Any, APIError> {
        switch urlResponse.statusCode {
        case 200...299:
            return .success(data ?? Data())
        case 400...599:
            return .failure(APIError.getError(from: urlResponse, error: error) ?? APIError.unknown)
        default:
            return .failure(APIError.unknown)
        }
    }
}
