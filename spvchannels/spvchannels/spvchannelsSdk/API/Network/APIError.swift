//
//  APIError.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

enum APIError: Error, CustomStringConvertible {
    case noData
    case unauthorized
    case forbidden
    case notFound
    case invalidResponse(String)
    case badRequest(String)
    case serverError(String)
    case parseError(String)
    case unknown

    static func getErrorDescription(from error: Error?) -> String {
        var errorMessage: String
        if let error = error as? APIError {
            errorMessage = error.description
        } else {
            errorMessage = error?.localizedDescription ?? APIError.unknown.description
        }
        return errorMessage
    }

    static func getError(from response: HTTPURLResponse?, error: Error?) -> APIError? {
        let errorMessage = error?.localizedDescription ?? ""
        guard let response = response else { return APIError.invalidResponse(errorMessage) }
        guard isErrorStatusCode(response.statusCode) else { return nil }
        switch response.statusCode {
        case 401: return APIError.unauthorized
        case 403: return APIError.forbidden
        case 404: return APIError.notFound
        case 500: return APIError.serverError(errorMessage)
        default: return APIError.badRequest(errorMessage)
        }
    }

    static fileprivate func isErrorStatusCode(_ statusCode: Int) -> Bool {
        if case 400 ... 599 = statusCode {
            return true
        }
        return false
    }

    var description: String {
        switch self {
        case .noData: return "No content"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Forbidden"
        case .notFound: return "Not found"
        case .invalidResponse: return "Invalid response"
        case .badRequest: return "Bad request"
        case .serverError: return "Server error"
        case .unknown: return "unknown"
        case .parseError(let message): return "Parsing error (\(message))"
        }
    }

}
