//
//  HomeViewController.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

final class HomeViewController: UIViewController, Coordinatable, Instantiatable, HomeResponseDisplays {

    static func instantiate() -> Self? {
        Self()
    }

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

    private lazy var separator = UIView(height: 3, backgroundColor: .darkGray)

    private lazy var titleLabel: UILabel = {
        let label = UILabel(text: "SPV Channels SDK test app")
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.constraintHeight(height: 40)
        return label
    }()

    private lazy var baseUrlTextField = RoundedTextField(placeholder: "Enter base url")
    private lazy var accountIdTextField = RoundedTextField(placeholder: "Enter account ID")
    private lazy var usernameTextField = RoundedTextField(placeholder: "Enter username")
    private lazy var passwordTextField = RoundedTextField(placeholder: "Enter password")
    private lazy var openChannelsAPIButton = RoundedButton(title: "OPEN CHANNELS API",
                                                           action: #selector(openChannelsApiAction),
                                                           target: self)

    private lazy var channelIdTextField = RoundedTextField(placeholder: "Enter channel ID")
    private lazy var channelTokenTextField = RoundedTextField(placeholder: "Enter channel token")
    private lazy var openMessagingAPIButton = RoundedButton(title: "OPEN MESSAGING API",
                                                           action: #selector(openMessagingAction),
                                                           target: self)

    private lazy var stack = UIStackView(views: [titleLabel,
                                                 separator,
                                                 baseUrlTextField,
                                                 accountIdTextField,
                                                 usernameTextField,
                                                 passwordTextField,
                                                 openChannelsAPIButton,
                                                 channelIdTextField,
                                                 channelTokenTextField,
                                                 openMessagingAPIButton,
                                                 spacer],
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
    @objc func openChannelsApiAction(_ sender: UIButton) {
        guard let baseUrl = baseUrlTextField.text,
              let accountId = accountIdTextField.text,
              let userName = usernameTextField.text,
              let password = passwordTextField.text else {
            displayAlertMessage(message: "Please fill all required fields")
            return
        }
        interactor?.createSdkAndChannelApi(viewAction: .init(baseUrl: baseUrl,
                                                             accountId: accountId,
                                                             username: userName,
                                                             password: password))
    }

    @objc func openMessagingAction(_ sender: UIButton) {
        let channelId = channelIdTextField.text ?? ""
        let channelToken = channelTokenTextField.text ?? ""
        interactor?.createMessagingApiAndOpen(viewAction: .init(channelId: channelId,
                                                                tokenId: channelToken))
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
    }

    func displayCreateSdkAndOpenChannels(responseDisplay: Models.CreateSdkAndChannelApi.ResponseDisplay) {
        router?.routeToChannels()
    }

    func displayMessagingApiAndOpen(responseDisplay: Models.CreateMessagingApi.ViewAction) {
        router?.routeToMessages()
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
