//
//  MessagesViewController.swift
//  spvMessaging
//  Created by Equaleyes Solutions
//

import UIKit

enum MessagesAPI: CaseIterable {
    case getMaxMessageSequence
    case writeMessage
    case getMessages
    case markMessageAsReadOrUnread
    case deleteMessage

    var actionTitle: String {
        switch self {
        case .getMaxMessageSequence:
            return "Get Max Message Sequence"
        case .writeMessage:
            return "Write Message"
        case .getMessages:
            return "Get Messages"
        case .markMessageAsReadOrUnread:
            return "Mark Message As Read"
        case .deleteMessage:
            return "Delete Message"
        }
    }
}

class MessagingViewController: UIViewController, Instantiatable, Coordinatable, MessagingResponseDisplays {

    static func instantiate() -> Self? {
        Self()
    }

    weak var coordinator: SceneCoordinator? {
        didSet {
            router?.coordinator = coordinator
        }
    }

    // MARK: - Setup VIP
    typealias Models = MessagingModels

    var interactor: MessagingViewActions?
    var router: MessagingRouterType?

    internal func setupVIP() {
        let viewController = self
        let interactor = MessagingInteractor()
        let presenter = MessagingPresenter()
        let router = MessagingRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - UI elements
    private lazy var channelIdLabel = UILabel(text: "Channel:", tag: 1)
    private lazy var tokenIdLabel = UILabel(text: "Token:", tag: 1)
    private lazy var channelInfoStack = UIStackView(views: [channelIdLabel, tokenIdLabel], axis: .vertical, tag: 1)
    private lazy var actionButton = RoundedButton(action: #selector(selectAction), target: self, tag: 1)
    private lazy var contentTypeTextField = RoundedTextField(text: "text/plain")
    private lazy var messagePayloadTextField = RoundedTextField(placeholder: "Message payload")
    private lazy var unreadOnlyUISwitch = UISwitch(value: false)
    private lazy var unreadOnlyStack = UIStackView(views: [UILabel(text: "Unread messages only"),
                                                           unreadOnlyUISwitch])
    private lazy var messageIdLabel = UILabel(text: "Message ID")
    private lazy var messageIdTextField = RoundedTextField(placeholder: "Enter message ID")
    private lazy var messageReadStatusSwitch = UISwitch(value: false)
    private lazy var messageReadStatusStack = UIStackView(views: [UILabel(text: "Set message as read/unread"),
                                                                  messageReadStatusSwitch])
    private lazy var markOlderMessagesSwitch = UISwitch(value: false)
    private lazy var markOlderMessagesStack = UIStackView(views: [
        UILabel(text: "Apply to older messages too"),
        markOlderMessagesSwitch
    ])

    private lazy var goButton: RoundedButton = {
        let button = RoundedButton(title: "GO", action: #selector(goAction), target: self, tag: 1)
        button.constraintWidth(width: view.bounds.width / 4)
        return button
    }()

    private lazy var resultsTextView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.isEditable = false
        textView.tag = 1
        return textView
    }()

    private lazy var bottomStack = UIStackView(views: [actionButton, goButton], tag: 1)

    private lazy var stack = UIStackView(views: [
        channelInfoStack,
        contentTypeTextField,
        messagePayloadTextField,
        unreadOnlyStack,
        messageIdLabel,
        messageIdTextField,
        messageReadStatusStack,
        markOlderMessagesStack,
        resultsTextView,
        bottomStack
    ], axis: .vertical)

    private func setupUI() {
        title = "Messaging API"
        edgesForExtendedLayout = []
        view.addSubview(stack)
        stack.pin(to: view, insets: .init(top: 10, left: 10.0, bottom: 40, right: 10.0))
        setupMessagingUI()
        setupActionButton()
        interactor?.getChannelInfo(viewAction: .init())
    }

    private func setupMessagingUI() {
        resultsTextView.text = ""
        setupActionButton()
        stack.arrangedSubviews
            .filter { $0.tag != 1}
            .forEach { $0.isHidden = true }
        switch messagesAction {
        case .getMaxMessageSequence:
            resultsTextView.isHidden = false
        case .writeMessage:
            resultsTextView.isHidden = false
            contentTypeTextField.isHidden = false
            messagePayloadTextField.isHidden = false
        case .getMessages:
            resultsTextView.isHidden = false
            unreadOnlyStack.isHidden = false
        case .markMessageAsReadOrUnread:
            resultsTextView.isHidden = false
            messageIdLabel.isHidden = false
            messageIdTextField.isHidden = false
            messageReadStatusStack.isHidden = false
            markOlderMessagesStack.isHidden = false
        case .deleteMessage:
            resultsTextView.isHidden = false
            messageIdLabel.isHidden = false
            messageIdTextField.isHidden = false
        }
    }

    // MARK: - ViewController lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    // MARK: - Action selection
    var messagesAction = MessagesAPI.getMessages {
        didSet {
            setupMessagingUI()
        }
    }

    private func setupActionButton() {
        actionButton.setTitle(messagesAction.actionTitle, for: .normal)
    }

    private func presentActionSelection() {
        let sheet = UIAlertController()
        MessagesAPI.allCases.forEach { action in
            sheet.addAction(.init(title: action.actionTitle, style: .default) { [weak self] _ in
                self?.messagesAction = action
            })
        }
        sheet.addAction(.init(title: "Cancel", style: .cancel) { _ in
            sheet.dismiss(animated: true, completion: nil)
        })
        present(sheet, animated: true, completion: nil)
    }

    @objc func selectAction(_ sender: UIButton) {
        presentActionSelection()
    }

    // MARK: - ViewActions
    @objc func goAction(_ sender: UIButton) {
        let contentType = contentTypeTextField.text ?? ""
        let messageId = messageIdTextField.text ?? ""
        let payload = messagePayloadTextField.text ?? ""
        let unreadOnly = unreadOnlyUISwitch.isOn
        let markReadUnread = messageReadStatusSwitch.isOn
        let markOlderMessages = markOlderMessagesSwitch.isOn
        let viewAction = Models.PerformApiAction.ViewAction(action: messagesAction.actionTitle,
                                                            contentType: contentType,
                                                            messageId: messageId,
                                                            payload: payload,
                                                            unreadOnly: unreadOnly,
                                                            markReadUnread: markReadUnread,
                                                            markOlderMessages: markOlderMessages)
        interactor?.performAction(viewAction: viewAction)
    }

    // MARK: - DisplayResponses
    func displayChannelInfo(responseDisplay: Models.GetChannelInfo.ResponseDisplay) {
        channelIdLabel.text = "Channel: " + responseDisplay.channelId
        tokenIdLabel.text = "Token: " + responseDisplay.tokenId
    }

    func displayActionResults(responseDisplay: Models.PerformApiAction.ResponseDisplay) {
        resultsTextView.text = responseDisplay.result
    }

}
