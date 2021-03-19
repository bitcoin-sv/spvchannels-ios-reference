//
//  ChannelsViewController.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

extension Scenes {
    static let Channels = ChannelsViewController.self
}

class ChannelsViewController: UIViewController, Coordinatable {

    var coordinator: SceneCoordinator?
    var channelAction = SpvClientAPI.Endpoint.getAllChannels {
        didSet {
            setupActionButton()
        }
    }

    private lazy var stack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        stack.distribution = .fill
        stack.alignment = .fill
        return stack
    }()

    private lazy var displayTextField: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.isEditable = false
        return textView
    }()

    private lazy var bottomStack: UIStackView = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.constraintHeight(height: 40)
        stack.spacing = 10
        stack.axis = .horizontal
        return stack
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.constraintHeight(height: 40)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()

    private lazy var goButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("GO", for: .normal)
        button.constraintHeight(height: 40)
        button.constraintWidth(width: view.bounds.width / 4)
        button.backgroundColor = .darkGray
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(goAction(_:)), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActionButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    private func setupUI() {
        title = "Channels API"
        edgesForExtendedLayout = []
        view.addSubview(stack)
        stack.pin(to: view, insets: .init(top: 10, left: 10.0, bottom: 40, right: 10.0))
        stack.addArrangedSubview(displayTextField)

        stack.addArrangedSubview(bottomStack)
        bottomStack.addArrangedSubview(actionButton)
        bottomStack.addArrangedSubview(goButton)
    }

    private func setupActionButton() {
        actionButton.setTitle(channelAction.actionTitle, for: .normal)
    }

    private func presentActionsSheet() {
        let actionsSheet = UIAlertController()
        SpvClientAPI.Endpoint.allCases.forEach { action in
            actionsSheet.addAction(.init(title: action.actionTitle,
                                         style: .default, handler: { [weak self] _ in
                                            guard let self = self else { return }
                                            self.channelAction = action
                                         }))
        }
        actionsSheet.addAction(.init(title: "Cancel", style: .cancel) { _ in
            actionsSheet.dismiss(animated: true, completion: nil)
        })
        present(actionsSheet, animated: true, completion: nil)
    }

    @objc func buttonAction(_ sender: UIButton) {
        presentActionsSheet()
    }

    @objc func goAction(_ sender: UIButton) {
        switch channelAction {
        case .getAllChannels: getAllChannels()
        case .getChannel: getChannel()
        case .createChannel: createChannel()
        case .amendChannel: amendChannel()
        case .deleteChannel: deleteChannel()
        case .getAllChannelTokens: getAllChannelTokens()
        case .getChannelToken: getChannelToken()
        case .createChannelToken: createChannelToken()
        case .revokeChannelToken: revokeChannelToken()
        }
    }

    private func getAllChannels() {
        let accountId = "123"
        coordinator?.spvChannels?.networkService
            .getAllChannels(accountId: accountId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.displayTextField.text = toJson(data)
                case .failure(let error):
                    self.displayTextField.text = error.description
                }
            }
        }
    }

    private func getChannel() {
        let accountId = "123"
        let channelId = "234"
        coordinator?.spvChannels?.networkService
            .getChannel(accountId: accountId, channelId: channelId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.displayTextField.text = toJson(data)
                case .failure(let error):
                    self.displayTextField.text = error.description
                }
            }
        }
    }

    private func createChannel() {
        let accountId = "123"
        coordinator?.spvChannels?.networkService
            .createChannel(accountId: accountId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.displayTextField.text = toJson(data)
                case .failure(let error):
                    self.displayTextField.text = error.description
                }
            }
        }
    }

    private func amendChannel() {
        let accountId = "123"
        let channelId = "234"
        let permissions = ChannelPermissions(publicRead: true, publicWrite: true, locked: false)
        coordinator?.spvChannels?.networkService
            .amendChannel(accountId: accountId, channelId: channelId, permissions: permissions) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success:
                        self.displayTextField.text = "SUCCESS"
                    case .failure(let error):
                        self.displayTextField.text = error.description
                    }
                }
            }
    }

    private func deleteChannel() {
        let accountId = "123"
        let channelId = "234"
        coordinator?.spvChannels?.networkService
            .deleteChannel(accountId: accountId, channelId: channelId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.displayTextField.text = "SUCCESS"
                case .failure(let error):
                    self.displayTextField.text = error.description
                }
            }
        }
    }

    private func getAllChannelTokens() {
        let accountId = "123"
        let channelId = "234"
        coordinator?.spvChannels?.networkService
            .getAllChannelTokens(accountId: accountId, channelId: channelId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.displayTextField.text = toJson(data)
                case .failure(let error):
                    self.displayTextField.text = error.description
                }
            }
        }
    }

    private func getChannelToken() {
        let accountId = "123"
        let channelId = "234"
        let tokenId = "abcde"
        coordinator?.spvChannels?.networkService
            .getChannelToken(accountId: accountId, channelId: channelId, tokenId: tokenId) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.displayTextField.text = toJson(data)
                case .failure(let error):
                    self.displayTextField.text = error.description
                }
            }
        }
    }

    private func createChannelToken() {
        let accountId = "123"
        let channelId = "234"
        let tokenRequest = CreateTokenRequest(canRead: true, canWrite: true, description: "description")
        coordinator?.spvChannels?.networkService
            .createChannelToken(accountId: accountId, channelId: channelId, tokenRequest: tokenRequest) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.displayTextField.text = toJson(data)
                case .failure(let error):
                    self.displayTextField.text = error.description
                }
            }
        }
    }

    private func revokeChannelToken() {
        let accountId = "123"
        let channelId = "234"
        let channelToken = "abcde"
        coordinator?.spvChannels?.networkService
            .revokeChannelToken(accountId: accountId, channelId: channelId, tokenId: channelToken) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self.displayTextField.text = "SUCCESS"
                case .failure(let error):
                    self.displayTextField.text = error.description
                }
            }
        }
    }

}
