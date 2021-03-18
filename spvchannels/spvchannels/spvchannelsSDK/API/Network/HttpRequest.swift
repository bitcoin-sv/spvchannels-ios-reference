//
//  HttpRequest.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Alamofire
import Foundation

public enum HttpMethod: String {
    case options = "OPTIONS"
    case get = "GET"
    case head = "HEAD"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case trace = "TRACE"
    case connect = "CONNECT"
}

enum Encoding {
    case url, json
}

struct HttpResponse {
    var statusCode = 0
    var responseString = ""
    var responseValue: Any?
    var error: SpvError?
    var request: URLRequest?
    var response: HTTPURLResponse?
    var data: Data?
}

class HttpRequest {
    let method: HttpMethod
    let url: String
    var headers: [String: String]
    let parameters: [String: Any]
    let encoding: Encoding

    var data: [String: Data] = [:]

    init(method: HttpMethod, url: String, headers: [String: String] = [:],
         parameters: [String: Any] = [:], encoding: Encoding = .json) {
        self.method = method
        self.url = url
        self.headers = headers
        self.parameters = parameters
        self.encoding = encoding
    }

    func add(dataContent: Data?, key: String) {
        data[key] = dataContent
    }

    func run(completion: @escaping ((HttpResponse) -> Void)) {
        let alamofireMethod = HttpRequest.getAlamofireMethod(from: method)
        let alamofireEncoding = HttpRequest.getAlamofireEncoding(from: encoding, method: method)
        Alamofire.request(url, method: alamofireMethod, parameters: parameters,
                          encoding: alamofireEncoding, headers: headers).responseJSON { response in
                            let httpResponse = self.getHttpResponse(from: response)
                            completion(httpResponse)
        }
    }

    func getHttpResponse(from response: DataResponse<Any>?) -> HttpResponse {
        guard let response = response else {
            return HttpResponse()
        }

        var httpResponse = HttpResponse()
        httpResponse.statusCode = response.response?.statusCode ?? -1
        httpResponse.request = response.request
        httpResponse.response = response.response
        httpResponse.responseValue = response.value
        httpResponse.data = response.data

        if let data = response.data, let responseString = String(data: data, encoding: String.Encoding.utf8) {
            httpResponse.responseString = responseString
        }

        httpResponse.error = ErrorManager.getError(from: response.response, data: response.data,
                                                   error: response.error)

        return httpResponse
    }

    static func getAlamofireEncoding(from encoding: Encoding, method: HttpMethod) -> ParameterEncoding {
        guard method != .get else {
            return URLEncoding.default
        }
        switch encoding {
        case .url:
            return URLEncoding.default
        case .json:
            return JSONEncoding.default
        }
    }

    static func getAlamofireMethod(from method: HttpMethod) -> HTTPMethod {
        guard let httpMethod = HTTPMethod(rawValue: method.rawValue) else {
            return .get
        }

        return httpMethod
    }
}
