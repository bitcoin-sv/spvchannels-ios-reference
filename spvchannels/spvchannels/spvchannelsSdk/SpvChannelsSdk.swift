//
//  SpvchannelsSDK.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import Firebase
import Foundation
import UIKit

class SpvChannelsSdk: NSObject {

    let baseUrl: String
    private var updateTokenService: SpvFirebaseTokenApi?
    private var openNotification: ((String, String) -> Void)?

    init?(firebaseConfig: String = "", baseUrl: String, openNotification: ((String, String) -> Void)? = nil) {
        self.baseUrl = baseUrl
        self.openNotification = openNotification
        super.init()
        if !firebaseConfig.isEmpty {
            if setupFirebaseMessaging(configFile: firebaseConfig) {
                updateTokenService = SpvFirebaseTokenApi(baseUrl: baseUrl)
            } else {
                return nil
            }
        }
    }

    func channelWithCredentials(accountId: String, username: String, password: String) -> SpvChannelApi {
        SpvChannelApi(baseUrl: baseUrl, accountId: accountId, username: username, password: password)
    }

    func messagingWithToken(channelId: String, token: String,
                            encryption: SpvEncryptionProtocol = SpvNoOpEncryption()) -> SpvMessagingApi {
        SpvMessagingApi(baseUrl: baseUrl, channelId: channelId, token: token, encryption: encryption)
    }

}

extension SpvChannelsSdk: UNUserNotificationCenterDelegate, MessagingDelegate {

    func setupFirebaseMessaging(configFile: String) -> Bool {
        let application = UIApplication.shared
        Messaging.messaging().delegate = nil
        UNUserNotificationCenter.current().delegate = nil
        application.unregisterForRemoteNotifications()
        FirebaseApp.app()?.delete({_ in})

        guard let firebaseOptions = FirebaseOptions.init(contentsOfFile: configFile) else {
            return false
        }
        // Needed to use Objective-C catch in a wrapper class to handle NSException that Firebase throws
        guard (try? ObjC.catch { [weak self] in
            guard let self = self else { return }
            FirebaseApp.configure(options: firebaseOptions)
            UNUserNotificationCenter.current().delegate = self
            UNUserNotificationCenter.current().requestAuthorization(
                options: [.alert, .badge, .sound],
                completionHandler: {_, _ in })
            application.registerForRemoteNotifications()
            Messaging.messaging().delegate = self
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.appWillEnterForeground),
                name: UIApplication.willEnterForegroundNotification,
                object: nil)
        }) != nil
        else {
            return false
        }
        return true
    }

    @objc func appWillEnterForeground() {
        guard let token = Messaging.messaging().fcmToken else { return }
        updateFcmTokenIfNeeded(token: token)
    }

    func updateFcmTokenIfNeeded(token: String) {
        let currentToken = UserDefaults.standard.firebaseToken
        if token != currentToken {
            UserDefaults.standard.firebaseToken = token
            updateTokenService?.updateFirebaseToken(token: token) { result in
                print("TOKEN UPDATE: ", result)
            }
        }
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        updateFcmTokenIfNeeded(token: fcmToken)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping
                                    (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.badge, .alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let message = response.notification.request.content.title
        let channelId = response.notification.request.content.body
        DispatchQueue.main.async { [weak self] in
            self?.openNotification?(message, channelId)
        }
        completionHandler()
    }

}
