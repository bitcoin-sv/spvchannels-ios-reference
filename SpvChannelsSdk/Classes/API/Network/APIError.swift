//
//  APIError.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

/// Definition of API errors
public enum APIError: Error, CustomStringConvertible {
    case noData
    case unauthorized
    case forbidden
    case notFound
    case conflict
    case payloadTooLarge
    case invalidResponse(String)
    case badRequest(String)
    case serverError(String)
    case insufficientStorage
    case parseError(String)
    case unknown
    case encryptionError

    public static func getErrorDescription(from error: Error?) -> String {
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
        case 400: return APIError.badRequest(errorMessage)
        case 401: return APIError.unauthorized
        case 403: return APIError.forbidden
        case 404: return APIError.notFound
        case 409: return APIError.conflict
        case 413: return APIError.payloadTooLarge
        case 500: return APIError.serverError(errorMessage)
        case 507: return APIError.insufficientStorage
        default: return APIError.unknown
        }
    }

    static fileprivate func isErrorStatusCode(_ statusCode: Int) -> Bool {
        (400...599).contains(statusCode)
    }

    public var description: String {
        switch self {
        case .noData: return "No content"
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Forbidden"
        case .notFound: return "Not found"
        case .invalidResponse: return "Invalid response"
        case .badRequest(let message): return "Bad request - (\(message))"
        case .serverError: return "Server error"
        case .unknown: return "unknown"
        case .parseError(let message): return "Parsing error (\(message))"
        case .conflict: return "Conflict - sequencing failure"
        case .payloadTooLarge: return "Payload error - Message too large"
        case .insufficientStorage: return "Storage error - Server storage quota exceeded"
        case .encryptionError: return "Payload encryption failed"
        }
    }

}
