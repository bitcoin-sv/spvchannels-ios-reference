//
//  SpvHttpRequestManager.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation

class SpvHttpRequestManager: HttpRequestManager {
    override func request(_ method: HttpMethod, url: String, headers: [String: String] = [:],
                          parameters: [String: Any] = [:], encoding: Encoding = .json) -> HttpRequest {
        return SpvHttpRequest(method: method,
                                      url: url,
                                      headers: headers,
                                      parameters: parameters,
                                      encoding: encoding)
    }
}
