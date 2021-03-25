//
//  FirebaseConfig.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import FirebaseMessaging

class FirebaseConfig {
    let projectId: String
    let appId: String
    let apiKey: String

    init(projectId: String, appId: String, apiKey: String) {
        self.projectId = projectId
        self.appId = appId
        self.apiKey = apiKey
    }
}
