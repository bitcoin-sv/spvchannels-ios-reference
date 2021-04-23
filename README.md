# SPV Channels iOS SDK

This repository contains SPV Channels iOS SDK. It contains the iOS client library for interacting with the SPV channels server and a simple demonstration app.

## Requirements

This SDK can only be used as part of iOS projects.

### Self-signed or untrusted SSL certificates on the SPV server

In order to connect to an SPV Channels server with a self-signed certificate during development and testing, a **DEBUG** build of the app will automatically override iOS system behaviour and accept otherwise denied untrusted SSL certificate.

## Installation

### CocoaPods

[CocoaPods](https://cocoapods.org) is a dependency manager for Cocoa projects. For usage and installation instructions, visit their website. To integrate SPV Channels SDK into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'SpvChannelsSdk', :git => 'https://github.com/bitcoin-sv/spvchannels-ios-reference.git'
```

## Building

### Building from Xcode

When using Xcode IDE using the CocoaPod generated workspace, building of the app will also build SDK, with no extra actions required.

### Building from command line

1. Use `Terminal` to navigate to the project directory
2. run `xcodebuild -workspace yourworkspacefile -scheme yourappname` in Terminal

Replace `yourworkspacefile` with the filename of your project workspace, and `yourappname` with the name of the build scheme of your app.

##### Example:

`xcodebuild -workspace SpvChannelsSdk.xcworkspace -scheme SpvChannelsSdk`

## SDK usage

In order to receive notifications when app is in background the Spv Channels SDK uses **Firebase Messaging**.
To enable this functionality to your app make sure you add the **Push Notifications** capability in the *Signing & Capabilities* section of the app target.

The entry point for using SPV channels is always `SpvChannelsSdk`. This class can be used to create an instance of the [Channels API](#channels-api)  object for channel management and [Messaging API](#messaging-api) for using Messaging APIs, respectively.

Firebase Messaging can be integrated by downloading the `GoogleService-Info.plist` file from the Firebase console, including it in the app bundle, and providing its filename to the SDK initialization. If you provide an empty string as `firebaseConfig` parameter or if the named file is not found in the app bundle, then the SDK will not attempt to initialize **Firebase** and push notifications will not be received.

In order to create an instance of the `SpvChannelsSdk` you will provide:
- firebaseConfig filename string (to setup notifications via FCM)
- base url to the API you want to connect to
- optionally, a closure or handler to be called when a push notification is being tapped

An example of initialization can be seen here. First get a path for the FCM configuration file:

```swift
let firebaseConfigFile = Bundle.main.path(forResource: "GoogleService-Info",
                                          ofType: "plist")
```

Then create an instance of SpvChannelsSdk:

```swift
let sdkInstance = SpvChannelsSdk(firebaseConfig: firebaseConfigFile,
                                 baseUrl: viewAction.baseUrl)
```

If you want to pass the notification handler as well:

```swift
let sdk = SpvChannelsSdk(firebaseConfig: firebaseConfigFile,
                         baseUrl: viewAction.baseUrl,
                         openNotification: openNotificationHandler)
```

### Channels API

After creating an instance of `SpvChannelsSdk` you can create a `Channel API` class, using the
`accountId`, `username` and `password`:

```swift
let channelApi = spvChannelsSdk?
    .channelWithCredentials(accountId: accountId,
                            username: username,
                            password: password)
```

The `channelApi` object contains methods specified in the channels documentation. All methods are asynchronous, return closures are called on the main thread.

### Messaging API

After creating an instance of `SpvChannelsSdk` you can create a `Messaging` object, using the channelId,
token and (optionally) the encryption::

```swift
let messagingApi = spvChannelsSdk?
        .messagingWithToken(channelId: channelId,
                            token: token)
```

As with the [Channels API](#channels-api), methods here are declared in the official documentation and are asynchronous, return closures are called on the main thread.


## Encryption

When creating an instance of Messaging API you can optionally specify encryption, by default, NoOpEncryption is
used (resulting in cleartext message payload). The SDK also includes [LibSodiumEncryption](#libsodium-encryption) class `SpvLibSodiumEncryption`. If you want to specify a custom encryption simply implement the `SpvEncryption` protocol, specifying the `encrypt` and `decrypt` functions. Both of these take a `Data` object as input and produce a `Data` object as output or `nil` if encryption or decryption failed. Then pass a reference to its instance to the Messaging API initializer. 

### libSodium Encryption

`SpvLibSodiumEncryption` class is an implementation of a sealed box [libSodium encryption](https://libsodium.gitbook.io/doc) and has several initialization and helper methods. When creating a new instance the following methods are available:

- *no parameters*: will generate a new ephemeral keypair
- `publicKey` and `secretKey`: lets you specify public and secret key as Data objects
- `publicKeyString` and `secretKeyString`: lets you specify public and secret key as Base64 encoded strings
- `serializedKeypair`: JSON structure, containing privateKey and publicKey fields as produced by the `exportKeys` helper

```swift
let encryptionClass = SpvLibSodiumEncryption()
```

After creating an instance several additional methods are available:

- `myPublicKeyString`: returns your public key as a Base64 encoded string, which can be shared with others so they can send you encrypted messages
- `myPublicKey`: returns your public key in a Data object
- `exportKeys`: returns a JSON structure with publicKey and privateKey as Base64 encoded strings
- `setEncryptionKey`: sets the key used for encryption, typically the public key of the recipient. Will accept a Data object as well as a Base64 encoded string

In order to be able to send a message with an encrypted payload, your public and private keys need to be set (or generated) as well as the recipients public key (via `setEncryptionKey`)

```swift
encryptionClass.setEncryptionKey(recipientPublicKeyString: somePubKeyBase64String)
```
