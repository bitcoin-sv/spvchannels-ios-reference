//
//  ErrorManager.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class ErrorManager {
    static func getError(from response: HTTPURLResponse?, data: Data?, error: Error?) -> SpvError? {
        if let error = error as? URLError, error.code == .notConnectedToInternet {
            return SpvError.serverError
        }
        guard let response = response else { return SpvError.badRequest }
        guard isErrorStatusCode(response.statusCode) else { return nil }

        switch response.statusCode {
        case 401: return SpvError.unauthorized
        case 403: return SpvError.forbidden
        case 404: return SpvError.notFound
        case 500: return SpvError.serverError
        default: return SpvError.badRequest
        }
    }
    static fileprivate func isErrorStatusCode(_ statusCode: Int) -> Bool {
        if case 400 ... 599 = statusCode {
            return true
        }
        return false
    }
}
