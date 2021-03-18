//
//  SpvApiWorker.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Alamofire

class SpvApiWorker {
    var httpRequestManager: HttpRequestManager = SpvHttpRequestManager()

    typealias ErrorCallback = (SpvError?) -> Void

    func execute() {
        let method = getMethod()
        let url = getUrl()
        let headers = getHeaders()
        let parameters = getParameters()

        let request = httpRequestManager.request(method, url: url, headers: headers, parameters: parameters)
        request.run { response in
            DispatchQueue.global(qos: .background).async {
                self.processResponse(response: response)
                DispatchQueue.main.async {
                    self.apiCallDidFinish(response: response)
                }
            }
        }
    }

    func processResponse(response: HttpResponse) { }

    func apiCallDidFinish(response: HttpResponse) { }
    func getUrl() -> String { return "" }
    func getMethod() -> HttpMethod { return .get }
    func getParameters() -> [String: Any] { return [:] }
    func getHeaders() -> [String: String] { return [:] }
}
