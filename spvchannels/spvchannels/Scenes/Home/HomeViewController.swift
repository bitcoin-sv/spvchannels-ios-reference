//
//  HomeViewController.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import UIKit

final class HomeViewController: UIViewController, Coordinatable, CleanVIP, HomeResponseDisplays {

    weak var coordinator: SceneCoordinator? {
        didSet {
            router?.coordinator = coordinator
        }
    }

    // MARK: - Setup VIP
    typealias Models = HomeModels

    var interactor: HomeViewActions?
    var router: HomeRouterType?

    internal func setupVIP() {
        let viewController = self
        let interactor = HomeInteractor()
        let presenter = HomePresenter()
        let router = HomeRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - UI elements
    private lazy var spacer: UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        return spacer
    }()

    private lazy var separator1 = UIView(height: 2, backgroundColor: .darkGray)
    private lazy var separator2 = UIView(height: 2, backgroundColor: .darkGray)
    private lazy var separator3 = UIView(height: 2, backgroundColor: .darkGray)
    private lazy var separator4 = UIView(height: 2, backgroundColor: .darkGray)

    private lazy var titleLabel: UILabel = {
        let label = UILabel(text: "SPV Channels SDK test app")
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.constraintHeight(height: 40)
        return label
    }()

    private lazy var baseUrlStack = UIStackView(views: [UILabel(text: "Base URL:"), baseUrlTextField],
                                                distribution: .fillProportionally)
    private lazy var baseUrlTextField = UITextField(placeholder: "Enter base url")

    private lazy var accountIdStack = UIStackView(views: [UILabel(text: "Account ID:"), accountIdTextField],
                                                  distribution: .fillProportionally)
    private lazy var accountIdTextField = UITextField(placeholder: "Enter account ID")

    private lazy var usernameStack = UIStackView(views: [UILabel(text: "Username:"), usernameTextField],
                                                 distribution: .fillProportionally)
    private lazy var usernameTextField = UITextField(placeholder: "Enter username")

    private lazy var passwordStack = UIStackView(views: [UILabel(text: "Password:"), passwordTextField],
                                                 distribution: .fillProportionally)

    private lazy var passwordTextField = UITextField(placeholder: "Enter password")
    private lazy var createSdkButton = UIButton(title: "INITIALIZE SPV CHANNELS SDK",
                                                           action: #selector(createSdkAction),
                                                           target: self)
    private lazy var openChannelsAPIButton = UIButton(title: "OPEN CHANNELS API",
                                                           action: #selector(openChannelsApiAction),
                                                           target: self)

    private lazy var channelIdTextField = UITextField(placeholder: "Enter channel ID")
    private lazy var channelTokenTextField = UITextField(placeholder: "Enter channel token")
    private lazy var encryptionSwitch = UISwitch(value: false)
    private lazy var encryptionStack = UIStackView(views: [UILabel(text: "libSodium Encryption"),
                                                           encryptionSwitch])
    private lazy var openMessagingAPIButton = UIButton(title: "OPEN MESSAGING API",
                                                           action: #selector(openMessagingAction),
                                                           target: self)

    private lazy var firebaseTokenLabel = UILabel(text: "Firebase token:")

    private lazy var firebaseToken: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.isEditable = false
        return textView
    }()

    private lazy var stack = UIStackView(views: [titleLabel,
                                                 separator1,
                                                 baseUrlStack,
                                                 createSdkButton,
                                                 separator2,
                                                 accountIdStack,
                                                 usernameStack,
                                                 passwordStack,
                                                 openChannelsAPIButton,
                                                 separator3,
                                                 channelIdTextField,
                                                 channelTokenTextField,
                                                 encryptionStack,
                                                 openMessagingAPIButton,
                                                 separator4,
                                                 firebaseTokenLabel,
                                                 firebaseToken],
                                         axis: .vertical)

    private func setupUI() {
        view.addSubview(stack)
        stack.pin(to: view, insets: .init(top: 40, left: 10.0, bottom: 40, right: 10.0))
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        (view.getAllSubviews() as [UITextField]).forEach { $0.delegate = self }
    }

    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadSavedCredentials()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - ViewActions
    @objc func createSdkAction(_ sender: UIButton) {
        hideKeyboard()
        guard let baseUrl = baseUrlTextField.text else {
            displayAlertMessage(message: "Please fill base URL")
            return
        }
        interactor?.createSdk(viewAction: .init(baseUrl: baseUrl))
    }

    @objc func openChannelsApiAction(_ sender: UIButton) {
        hideKeyboard()
        guard let accountId = accountIdTextField.text,
              !accountId.isEmpty,
              let userName = usernameTextField.text,
              !userName.isEmpty,
              let password = passwordTextField.text,
              !password.isEmpty else {
            displayAlertMessage(message: "Please fill all required fields")
            return
        }
        interactor?.createChannelApi(viewAction: .init(accountId: accountId,
                                                       username: userName,
                                                       password: password))
    }

    @objc func openMessagingAction(_ sender: UIButton) {
        guard let channelId = channelIdTextField.text,
              !channelId.isEmpty,
              let channelToken = channelTokenTextField.text,
              !channelToken.isEmpty else {
            displayAlertMessage(message: "Please fill all required fields")
            return
        }
        let encryption = encryptionSwitch.isOn
        interactor?.createMessagingApi(viewAction: .init(channelId: channelId,
                                                         token: channelToken,
                                                         encryption: encryption))
    }

    private func loadSavedCredentials() {
        interactor?.loadSavedCredentials()
    }

    // MARK: - DisplayResponses

    func displaySavedCredentials(responseDisplay: Models.LoadSavedCredentials.ResponseDisplay) {
        baseUrlTextField.text = responseDisplay.baseUrl
        accountIdTextField.text = responseDisplay.accountId
        usernameTextField.text = responseDisplay.username
        passwordTextField.text = responseDisplay.password
        channelIdTextField.text = responseDisplay.channelId
        channelTokenTextField.text = responseDisplay.token
    }

    func displayCreateSdk(responseDisplay: Models.CreateSdk.ResponseDisplay) {
        if responseDisplay.result {
            displayAlertMessage(message: "SPV Channels SDK initialized successfully")
            interactor?.getFirebaseToken(viewAction: .init())
        } else {
            displayErrorMessage(errorMessage: "SPV Channels SDK initialization failed")
        }
    }

    func displayFirebaseToken(responseDisplay: Models.GetFirebaseToken.ResponseDisplay) {
        firebaseToken.text = responseDisplay.token
    }
    func displayCreateChannelApi(responseDisplay: Models.CreateChannelApi.ResponseDisplay) {
        if responseDisplay.result {
            router?.routeToChannels()
        } else {
            displayErrorMessage(errorMessage: "Channels API initialization failed")
        }
    }

    func displayMessagingApi(responseDisplay: Models.CreateMessagingApi.ResponseDisplay) {
        if responseDisplay.result {
            router?.routeToMessages()
        } else {
            displayErrorMessage(errorMessage: "Messaging API initialization failed")
        }
    }

    func displayErrorMessage(errorMessage: String) {
        displayAlertMessage(message: errorMessage)
    }

    // MARK: - Additional Helpers
    private func displayAlertMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        textField.resignFirstResponder()
        return true
    }
}
