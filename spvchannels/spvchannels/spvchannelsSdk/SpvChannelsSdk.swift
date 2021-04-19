//
//  SpvchannelsSDK.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import Firebase
import UIKit

/// SPV Channels SDK main entry point
class SpvChannelsSdk: NSObject {
    /// Closure that notifies your app when user interacts with a push notification
    typealias PushNotificationClosure = (String, String) -> Void
    /// Base URL of SPV Channels server
    let baseUrl: String
    private var notificationService: SpvFirebaseTokenApi?
    private var openNotification: ((String, String) -> Void)?

    private var fcmToken: String? {
        didSet {
            updateFcmTokenIfNeeded(oldToken: oldValue, newToken: fcmToken)
        }
    }

    private var storedToken: String? {
        UserDefaults.standard.firebaseToken
    }

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

    init?(firebaseConfig: String = "", baseUrl: String, openNotification: PushNotificationClosure? = nil) {
        self.baseUrl = baseUrl
        self.openNotification = openNotification
        super.init()
        if let stored = storedToken {
            self.fcmToken = stored
        }
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
    func channelWithCredentials(accountId: String, username: String, password: String) -> SpvChannelApi {
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
     If you do not provide encryption class it will default to no encryption by way of SpvNoOpEncryption class
     
     # Example #
     ```
     let myMessagingApi = messagingWithToken(channelId: "XYZ123",
                                             token: "ABC456DEF")
     ```
     */
    func messagingWithToken(channelId: String, token: String,
                            encryption: SpvEncryptionProtocol = SpvNoOpEncryption()) -> SpvMessagingApi {
        SpvMessagingApi(baseUrl: baseUrl, channelId: channelId, token: token,
                        notificationService: notificationService, encryption: encryption)
    }

}

extension SpvChannelsSdk: UNUserNotificationCenterDelegate, MessagingDelegate {
    typealias StringResult = (Result<String, Error>) -> Void

    /// Initializes Firebase messaging, sets up push notification authorization and registers for receiving
    /// Also listens for app lifecycle events for refresh FCM token upon app becoming active
    private func setupFirebaseMessaging(configFile: String) -> Bool {
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
        if newToken != fcmToken {
            fcmToken = newToken
        }
        updateFcmTokenIfNeeded()
    }

    /// When app becomes goes to background, check for any FCM token change
    @objc func appWillResignActive() {
        guard let newToken = Messaging.messaging().fcmToken else { return }
        if newToken != fcmToken {
            fcmToken = newToken
        }
        updateFcmTokenIfNeeded()
    }

    /// Received a FCM token, update it if needed
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        guard let fcmToken = fcmToken else { return }
        self.fcmToken = fcmToken
    }

    /// Disables notifications for all channels by deregistering an existing FCM token
    func disableAllNotifications(completion: @escaping StringResult) {
        guard let fcmToken = fcmToken else {
            completion(.failure(APIError.badRequest("Firebase token cannot be nil")))
            return
        }
        notificationService?.deleteToken(oldToken: fcmToken, completion: completion)
    }

    /// Update FCM token on back-end so if current FCM token differs from stored token
    private func updateFcmTokenIfNeeded() {
        updateFcmTokenIfNeeded(oldToken: storedToken, newToken: fcmToken)
    }

    /// Register new FCM token with back-end so messages will be able to be addressed to this device
    private func updateFcmTokenIfNeeded(oldToken: String?, newToken: String?) {
        guard let oldToken = oldToken, let newToken = newToken else { return }
        if newToken != oldToken || storedToken != newToken {
            notificationService?.updateToken(oldToken: oldToken, fcmToken: newToken) { result in
                if case .success = result {
                    UserDefaults.standard.firebaseToken = newToken
                }
            }
        }
    }

    /// Received the Apple push notification token, associate it with FCM messaging
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        updateFcmTokenIfNeeded()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping
                                    (UNNotificationPresentationOptions) -> Void) {
        completionHandler([[.badge, .alert, .sound]])
    }

    /// User interacted with a received push notification, call any provided response code block
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
