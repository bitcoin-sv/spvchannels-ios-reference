//
//  SpvError.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

enum SpvError: Error, CustomStringConvertible {
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case badRequest
    case noContent

    var description: String {
        switch self {
        case .unauthorized: return "Unauthorized"
        case .forbidden: return "Forbidden"
        case .notFound: return "Not found"
        case .serverError: return "Server error"
        case .badRequest: return "Bad request"
        case .noContent: return "No content"
        }
    }
}
