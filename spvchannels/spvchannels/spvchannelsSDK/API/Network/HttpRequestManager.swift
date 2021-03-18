//
//  HttpRequestManager.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class HttpRequestManager {
    func request(_ method: HttpMethod, url: String, headers: [String: String] = [:],
                 parameters: [String: Any] = [:], encoding: Encoding = .json) -> HttpRequest {
        return HttpRequest(method: method, url: url, headers: headers,
                           parameters: parameters, encoding: encoding)
    }
}
