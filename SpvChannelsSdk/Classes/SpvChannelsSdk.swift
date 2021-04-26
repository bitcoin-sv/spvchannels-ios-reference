//
//  SpvchannelsSDK.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import FirebaseCore
import FirebaseMessaging
import UIKit

/// SPV Channels SDK main entry point
public class SpvChannelsSdk: NSObject {
    /// Closure that notifies your app when user interacts with a push notification
    public typealias PushNotificationClosure = (String, String, String) -> Void
    /// Base URL of SPV Channels server
    public let baseUrl: String
    public var firebaseToken: String? {
        notificationService?.fcmToken
    }

    private var notificationService: SpvFirebaseTokenApiProtocol?
    private var openNotification: ((String, String, String) -> Void)?
    private var gcmSenderId: String?

    /**
     - parameter firebaseConfig: a file url with FireBase configuration to use for messaging
     - parameter baseUrl: the base url of the SPV channels server
     - parameter openNotification: optional closure that runs when user interacts with a push notification
     - returns: SpvChannelsSdk instance with access to initializing Channel API and Messaging API
     - warning: If you are instantiating several SDK instances, use separate Firebase configurations for each of them

     # Notes: #
     1.  If you don't provide Firebase configuration file, the SDK will not initialize Firebase messaging
     2.  If you provide Firebase configuration file and initializing Firebase fails then Channels SDK will also fail
     3.  If you do not provide push notification closure, SDK will not signal you when user interacts with notification

     # Example #
     ```
     let myChannelsSdk = SpvChannelsSdk("https://10.0.0.1:5010")
     ```
     */

    public init?(firebaseConfig: String = "", baseUrl: String, openNotification: PushNotificationClosure? = nil) {
        guard let url = URL(string: baseUrl) else {
            return nil
        }
        let absolutePath = url.absoluteString
        self.baseUrl = absolutePath.hasSuffix("/") ? absolutePath : absolutePath + "/"
        super.init()
        self.openNotification = openNotification
        if !firebaseConfig.isEmpty {
            if setupFirebaseMessaging(configFile: firebaseConfig) {
                notificationService = SpvFirebaseTokenApi(baseUrl: baseUrl)
            } else {
                return nil
            }
        }
    }

    /**
     Creates and returns a new Channel API class with given credentials
     
     - parameter accountId: the ID of the account on the SPV channels server for which the channels should be managed
     - parameter username: the username on the server to use with channel authentication
     - parameter password: the password on the server to use with channel authentication
     - returns: SpvChannelApi object with API accessor methods
     - warning: The credentials provided are not checked at Channel API initialization time
     
     # Example #
     ```
     let myChannelApi = channelWithCredentials(accountId: "1",
                                               username: "joe",
                                               password: "secret")
     ```
     */
    public func channelWithCredentials(accountId: String, username: String, password: String) -> SpvChannelApi {
        SpvChannelApi(baseUrl: baseUrl, accountId: accountId, username: username, password: password)
    }

    /**
     Creates and returns a new Messaging API class for a given channelId and authorization token
     
     - parameter channelId: the ID of the channel on the SPV channels server to create messaging API for
     - parameter token: the token to use for authorization
     - parameter encryption: the encryption class to use for payload processing
     - returns: SpvMessagingApi object with API accessor methods
     - warning: The credentials provided are not checked at Messaging API initialization time
     
     
     # Notes: #
     If you do not provide encryption class (nil) it will default to no encryption by way of SpvNoOpEncryption class
     
     # Example #
     ```
     let myMessagingApi = messagingWithToken(channelId: "XYZ123",
                                             token: "ABC456DEF")
     ```
     */
    public func messagingWithToken(channelId: String, token: String,
                                   encryption: SpvEncryptionProtocol?) -> SpvMessagingApi {
        let encryptionService: SpvEncryptionProtocol = encryption ?? SpvNoOpEncryption()
        return SpvMessagingApi(baseUrl: baseUrl, channelId: channelId, token: token,
                               notificationService: notificationService, encryption: encryptionService)
    }

}

extension SpvChannelsSdk: UNUserNotificationCenterDelegate, MessagingDelegate {
    public typealias StringResult = (Result<String, Error>) -> Void

    /// Initializes Firebase messaging, sets up push notification authorization and registers for receiving
    /// Also listens for app lifecycle events for refresh FCM token upon app becoming active
    private func setupFirebaseMessaging(configFile: String) -> Bool {
        let application = UIApplication.shared
        gcmSenderId = nil
        Messaging.messaging().delegate = nil
        UNUserNotificationCenter.current().delegate = nil
        application.unregisterForRemoteNotifications()
        FirebaseApp.app()?.delete {_ in }

        guard let firebaseOptions = FirebaseOptions(contentsOfFile: configFile) else {
            return false
        }
        // Needed to use Objective-C catch in a wrapper class to handle NSException that Firebase throws
        guard (try? ObjC.catch { [weak self] in
            guard let self = self else { return }
            FirebaseApp.configure(options: firebaseOptions)
            self.gcmSenderId = firebaseOptions.gcmSenderID
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
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(self.appWillResignActive),
                name: UIApplication.willResignActiveNotification,
                object: nil)
        }) != nil
        else {
            return false
        }
        return true
    }

    /// When app becomes active, check for any FCM token change
    @objc func appWillEnterForeground() {
        guard let newToken = Messaging.messaging().fcmToken else { return }
        notificationService?.receivedNewToken(newToken: newToken)
    }

    /// When app becomes goes to background, check for any FCM token change
    @objc func appWillResignActive() {
        guard let newToken = Messaging.messaging().fcmToken else { return }
        notificationService?.receivedNewToken(newToken: newToken)
    }

    /// Received a FCM token, update it if needed
    public func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        notificationService?.receivedNewToken(newToken: fcmToken)
    }

    /// Disables notifications for all channels by deregistering an existing FCM token
    public func disableAllNotifications(completion: @escaping StringResult) {
        guard let fcmToken = notificationService?.fcmToken else {
            completion(.failure(APIError.badRequest("Firebase token has not been received yet")))
            return
        }
        notificationService?.deleteToken(oldToken: fcmToken, completion: completion)
    }

    /// Received the Apple push notification token, associate it with FCM messaging
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        notificationService?.updateTokenIfStoredDifferent()
    }

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping
                                        (UNNotificationPresentationOptions) -> Void) {
        guard UIApplication.shared.applicationState == .active else {
            completionHandler([[.alert, .badge, .sound]])
            return
        }
        let title = notification.request.content.title
        let body = notification.request.content.body
        handleReceivedNotification(title: title, body: body, userInfo: notification.request.content.userInfo)
        completionHandler([])
    }

    /// Handle received remote notification
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        Messaging.messaging().appDidReceiveMessage(userInfo)
        let title: String = userInfo["message"] as? String ?? "n/a"
        let body: String = userInfo["time"] as? String ?? "n/a"
        handleReceivedNotification(title: title, body: body, userInfo: userInfo)
        completionHandler(.newData)
    }

    /// User interacted with a received push notification
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       didReceive response: UNNotificationResponse,
                                       withCompletionHandler completionHandler: @escaping () -> Void) {
        let title = response.notification.request.content.title
        let body = response.notification.request.content.body
        handleReceivedNotification(title: title, body: body, userInfo: response.notification.request.content.userInfo)
        completionHandler()
    }

    /// Call closure to respond to push notification
    private func handleReceivedNotification(title: String, body: String, userInfo: [AnyHashable: Any]) {
        guard let sender = userInfo["google.c.sender.id"] as? String,
              sender == gcmSenderId else { return }
        let channelId = userInfo["channelId"] as? String ?? "n/a"
        DispatchQueue.main.async { [weak self] in
            self?.openNotification?(title, body, channelId)
        }
    }

}
