//
//  HomeViewController.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

extension Scenes {
    static let Home = HomeViewController.self
}

class HomeViewController: UIViewController, Coordinatable {

    var coordinator: SceneCoordinator?

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()

    private lazy var spacer: UIView = {
        let spacer = UIView()
        spacer.translatesAutoresizingMaskIntoConstraints = false
        return spacer
    }()

    private lazy var separator: UIView = {
        let separator = UIView()
        separator.translatesAutoresizingMaskIntoConstraints = false
        separator.constraintHeight(height: 3)
        separator.backgroundColor = .darkGray
        return separator
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "SPV Channels SDK test app"
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.constraintHeight(height: 40)
        return label
    }()

    private lazy var baseUrlTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.placeholder = "Enter base url"
        textField.borderStyle = .roundedRect
        textField.constraintHeight(height: 40)
        return textField
    }()

    private lazy var accountIdTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.constraintHeight(height: 40)
        textField.placeholder = "Enter account ID"
        return textField
    }()

    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.constraintHeight(height: 40)
        textField.placeholder = "Enter username"
        return textField
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.constraintHeight(height: 40)
        textField.placeholder = "Enter password"
        return textField
    }()

    private lazy var openChannelsAPIButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OPEN CHANNELS API", for: .normal)
        button.constraintHeight(height: 40)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(openChannelsApiAction), for: .touchUpInside)
        return button
    }()

    private lazy var channelIdTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.constraintHeight(height: 40)
        textField.placeholder = "Enter channel ID"
        return textField
    }()

    private lazy var channelTokenTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.autocorrectionType = .no
        textField.autocapitalizationType = .none
        textField.borderStyle = .roundedRect
        textField.constraintHeight(height: 40)
        textField.placeholder = "Enter channel token"
        return textField
    }()

    private lazy var openMessagesAPIButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("OPEN MESSAGES API", for: .normal)
        button.constraintHeight(height: 40)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(openMessagesAction(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func setupUI() {
        view.addSubview(stack)
        stack.pin(to: view, insets: .init(top: 40, left: 10.0, bottom: 40, right: 10.0))
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(separator)
        stack.addArrangedSubview(baseUrlTextField)
        stack.addArrangedSubview(accountIdTextField)
        stack.addArrangedSubview(usernameTextField)
        stack.addArrangedSubview(passwordTextField)
        stack.addArrangedSubview(openChannelsAPIButton)
        stack.addArrangedSubview(channelIdTextField)
        stack.addArrangedSubview(channelTokenTextField)
        stack.addArrangedSubview(openMessagesAPIButton)
        stack.addArrangedSubview(spacer)

        baseUrlTextField.text = UserDefaults.standard.baseUrl
        accountIdTextField.text = UserDefaults.standard.accountId
        usernameTextField.text = UserDefaults.standard.userName
        passwordTextField.text = UserDefaults.standard.password
    }

    private func displayAlertMessage(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }

    @objc func openChannelsApiAction(_ sender: UIButton) {
        guard let baseUrl = baseUrlTextField.text,
              let accountId = accountIdTextField.text,
              let userName = usernameTextField.text,
              let password = passwordTextField.text else {
            displayAlertMessage(message: "Please fill all required fields")
            return
        }
        let credentials = SpvCredentials(accountId: accountId, userName: userName, password: password)
        UserDefaults.standard.baseUrl = baseUrl
        UserDefaults.standard.accountId = accountId
        UserDefaults.standard.userName = userName
        UserDefaults.standard.password = password
        coordinator?.spvChannels = SpvChannels(baseUrl: baseUrl, credentials: credentials)
        coordinator?.open(Scenes.Channels) { _ in true }
    }

    @objc func openMessagesAction(_ sender: UIButton) {
        guard coordinator?.spvChannels != nil else {
            displayAlertMessage(message: "Please initialize Channel API first")
            return
        }
        // Save channelID and channel token
    }
}
