//
//  SpvHttpRequest.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Alamofire
import Foundation

class SpvHttpRequest: HttpRequest {
    override func run(completion: @escaping ((HttpResponse) -> Void)) {
        super.run { response in
            completion(response)
        }
    }

    override func getHttpResponse(from response: DataResponse<Any>?) -> HttpResponse {
        let httpResponse = super.getHttpResponse(from: response)

        #if DEBUG
        if let error = httpResponse.error {
            print("--------    HTTP ERROR:    --------")
            print(httpResponse.request?.url?.absoluteString ?? "")
            print("Status code: \(httpResponse.statusCode)")
            print(error)
            print(httpResponse.responseString)
            print("-----------------------------------")
        }
        #endif

        return httpResponse
    }

}
