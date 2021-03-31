//
//  HomeViewController.swift
//  spvchannels
//  Created by Equaleyes Solutions
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
    private lazy var baseUrlTextField = RoundedTextField(placeholder: "Enter base url")

    private lazy var accountIdStack = UIStackView(views: [UILabel(text: "Account ID:"), accountIdTextField],
                                                  distribution: .fillProportionally)
    private lazy var accountIdTextField = RoundedTextField(placeholder: "Enter account ID")

    private lazy var usernameStack = UIStackView(views: [UILabel(text: "Username:"), usernameTextField],
                                                 distribution: .fillProportionally)
    private lazy var usernameTextField = RoundedTextField(placeholder: "Enter username")

    private lazy var passwordStack = UIStackView(views: [UILabel(text: "Password:"), passwordTextField],
                                                 distribution: .fillProportionally)

    private lazy var passwordTextField = RoundedTextField(placeholder: "Enter password")
    private lazy var createSdkButton = RoundedButton(title: "INITIALIZE SPV CHANNELS SDK",
                                                           action: #selector(createSdkAction),
                                                           target: self)
    private lazy var openChannelsAPIButton = RoundedButton(title: "OPEN CHANNELS API",
                                                           action: #selector(openChannelsApiAction),
                                                           target: self)

    private lazy var channelIdTextField = RoundedTextField(placeholder: "Enter channel ID")
    private lazy var channelTokenTextField = RoundedTextField(placeholder: "Enter channel token")
    private lazy var openMessagingAPIButton = RoundedButton(title: "OPEN MESSAGING API",
                                                           action: #selector(openMessagingAction),
                                                           target: self)

    private lazy var firebaseTokenLabel = UILabel(text: "Firebase token:")

    private lazy var firebaseToken = { () -> UITextView in
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
                                                 openMessagingAPIButton,
                                                 separator4,
                                                 firebaseTokenLabel,
                                                 firebaseToken],
                                         axis: .vertical)

    private func setupUI() {
        view.addSubview(stack)
        stack.pin(to: view, insets: .init(top: 40, left: 10.0, bottom: 40, right: 10.0))
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
        guard let baseUrl = baseUrlTextField.text else {
            displayAlertMessage(message: "Please fill base URL")
            return
        }
        interactor?.createSdk(viewAction: .init(baseUrl: baseUrl))
    }

    @objc func openChannelsApiAction(_ sender: UIButton) {
        guard let accountId = accountIdTextField.text,
              let userName = usernameTextField.text,
              let password = passwordTextField.text else {
            displayAlertMessage(message: "Please fill all required fields")
            return
        }
        interactor?.createChannelApi(viewAction: .init(accountId: accountId,
                                                       username: userName,
                                                       password: password))
    }

    @objc func openMessagingAction(_ sender: UIButton) {
        let channelId = channelIdTextField.text ?? ""
        let channelToken = channelTokenTextField.text ?? ""
        interactor?.createMessagingApi(viewAction: .init(channelId: channelId,
                                                         token: channelToken))
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

}
