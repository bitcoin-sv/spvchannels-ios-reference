//
//  SpvchannelsSDK.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Foundation
import UIKit

class SpvChannelsSdk {

    private let firebase: FirebaseConfig
    let baseUrl: String

    var onForeground: (() -> Void)?
    var onBackground: (() -> Void)?

    init(firebase: FirebaseConfig, baseUrl: String) {
        self.firebase = firebase
        self.baseUrl = baseUrl

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterForeground),
            name: UIApplication.willEnterForegroundNotification,
            object: nil)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(appWillEnterBackground),
            name: UIApplication.willResignActiveNotification,
            object: nil)
    }

    func channelWithCredentials(accountId: String, username: String, password: String) -> SpvChannelApi {
        SpvChannelApi(baseUrl: baseUrl, accountId: accountId, username: username, password: password)
    }

    func messagingWithToken(channelId: String, token: String, encryption: SpvEncryptionProtocol) -> SpvMessagingApi {
        SpvMessagingApi(baseUrl: baseUrl, channelId: channelId, token: token, encryption: encryption)
    }

    @objc func appWillEnterForeground() {
        onForeground?()
    }

    @objc func appWillEnterBackground() {
        onBackground?()
    }
}
