//
//  ChannelsViewController.swift
//  spvchannels
//  Created by Equaleyes Solutions
//

import UIKit

class ChannelsViewController: UIViewController, Instantiatable, Coordinatable, ChannelsResponseDisplays {

    static func instantiate() -> Self? {
        Self()
    }

    weak var coordinator: SceneCoordinator? {
        didSet {
            router?.coordinator = coordinator
        }
    }

    // MARK: - Setup VIP
    typealias Models = ChannelsModels

    var interactor: ChannelsViewActions?
    var router: ChannelsRouterType?

    internal func setupVIP() {
        let viewController = self
        let interactor = ChannelsInteractor()
        let presenter = ChannelsPresenter()
        let router = ChannelsRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: - UI elements
    private lazy var resultsTextView = { () -> UITextView in
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 8
        textView.layer.borderWidth = 2
        textView.layer.borderColor = UIColor.darkGray.cgColor
        textView.isEditable = false
        textView.tag = 1
        return textView
    }()

    private lazy var goButton: RoundedButton = {
        let button = RoundedButton(title: "GO", action: #selector(goAction), target: self, tag: 1)
        button.constraintWidth(width: view.bounds.width / 4)
        return button
    }()

    private lazy var actionButton = RoundedButton(action: #selector(selectAction), target: self, tag: 1)
    private lazy var channelIdTextField = RoundedTextField(placeholder: "Enter channel ID")
    private lazy var tokenTextField = RoundedTextField(placeholder: "Token")
    private lazy var tokenDescriptionTextField = RoundedTextField(placeholder: "Token description")
    private lazy var minAgeTextField = RoundedTextField()
    private lazy var minAgeStack = UIStackView(views: [UILabel(text: "Min age (days)"), minAgeTextField])
    private lazy var maxAgeTextField = RoundedTextField()
    private lazy var maxAgeStack = UIStackView(views: [UILabel(text: "Max age (days)"), maxAgeTextField])
    private lazy var publicReadSwitch = UISwitch(value: true)
    private lazy var publicReadSwitchStack = UIStackView(views: [UILabel(text: "Public read"),
                                                                 publicReadSwitch])
    private lazy var publicWriteSwitch = UISwitch(value: true)
    private lazy var publicWriteSwitchStack = UIStackView(views: [UILabel(text: "Public write"),
                                                                  publicWriteSwitch])
    private lazy var sequencedSwitch = UISwitch(value: true)
    private lazy var sequencedSwitchStack = UIStackView(views: [UILabel(text: "Sequenced"),
                                                                sequencedSwitch])
    private lazy var autoPruneSwitch = UISwitch(value: true)
    private lazy var autoPruneSwitchStack = UIStackView(views: [UILabel(text: "Auto prune"),
                                                                autoPruneSwitch])
    private lazy var lockedSwitch = UISwitch(value: true)
    private lazy var lockedSwitchStack = UIStackView(views: [UILabel(text: "Locked"),
                                                             lockedSwitch])
    private lazy var bottomStack = UIStackView(views: [actionButton, goButton], tag: 1)

    private lazy var stack = UIStackView(views: [channelIdTextField,
                                                 tokenTextField,
                                                 tokenDescriptionTextField,
                                                 publicReadSwitchStack,
                                                 publicWriteSwitchStack,
                                                 sequencedSwitchStack,
                                                 minAgeStack,
                                                 maxAgeStack,
                                                 lockedSwitchStack,
                                                 resultsTextView,
                                                 bottomStack],
                                         axis: .vertical)

    private func setupUI() {
        title = "Channels API"
        edgesForExtendedLayout = []
        view.addSubview(stack)
        stack.pin(to: view, insets: .init(top: 10, left: 10.0, bottom: 40, right: 10.0))
        setupChannelsUI()
        setupActionButton()
    }

    private func setupChannelsUI() {
        resultsTextView.text = ""
        setupActionButton()
        stack.arrangedSubviews
            .filter { $0.tag != 1}
            .forEach { $0.isHidden = true }
        switch channelsAction {
        case .getChannel, .deleteChannel, .getAllChannelTokens:
            channelIdTextField.isHidden = false
        case .getChannelToken, .revokeChannelToken:
            channelIdTextField.isHidden = false
            tokenTextField.isHidden = false
        case .createChannel:
            publicReadSwitchStack.isHidden = false
            publicWriteSwitchStack.isHidden = false
            sequencedSwitchStack.isHidden = false
            minAgeStack.isHidden = false
            maxAgeStack.isHidden = false
        case .amendChannel:
            channelIdTextField.isHidden = false
            publicReadSwitchStack.isHidden = false
            publicWriteSwitchStack.isHidden = false
            lockedSwitchStack.isHidden = false
        case .createChannelToken:
            channelIdTextField.isHidden = false
            tokenDescriptionTextField.isHidden = false
            publicReadSwitchStack.isHidden = false
            publicWriteSwitchStack.isHidden = false
        case .getAllChannels:
            break
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
    var channelsAction = ChannelsEndpoint.Actions.getAllChannels {
        didSet {
            setupChannelsUI()
        }
    }

    private func setupActionButton() {
        actionButton.setTitle(channelsAction.actionTitle, for: .normal)
    }

    @objc func selectAction(_ sender: UIButton) {
        presentActionSelection()
    }

    private func presentActionSelection() {
        let sheet = UIAlertController()
        ChannelsEndpoint.Actions.allCases.forEach { action in
            sheet.addAction(.init(title: action.actionTitle, style: .default) { [weak self] _ in
                self?.channelsAction = action
            })
        }
        sheet.addAction(.init(title: "Cancel", style: .cancel) { _ in
            sheet.dismiss(animated: false, completion: nil)
        })
        present(sheet, animated: true, completion: nil)
    }

    // MARK: - ViewActions
    @objc func goAction(_ sender: UIButton) {
        let publicRead = publicReadSwitch.isOn
        let publicWrite = publicWriteSwitch.isOn
        let locked = lockedSwitch.isOn
        let sequenced = sequencedSwitch.isOn
        let channelId = channelIdTextField.text ?? ""
        let tokenId = tokenTextField.text ?? ""
        let tokenDescription = tokenDescriptionTextField.text ?? ""
        let minAge = minAgeTextField.text ?? ""
        let maxAge = maxAgeTextField.text ?? ""
        let autoPrune = autoPruneSwitch.isOn
        let viewAction = Models.PerformApiAction.ViewAction(action: channelsAction,
                                                            publicRead: publicRead,
                                                            publicWrite: publicWrite,
                                                            locked: locked,
                                                            sequenced: sequenced,
                                                            channelId: channelId,
                                                            tokenId: tokenId,
                                                            tokenDescription: tokenDescription,
                                                            minAge: minAge,
                                                            maxAge: maxAge,
                                                            autoPrune: autoPrune)
        interactor?.performAction(viewAction: viewAction)
    }

    // MARK: - DisplayResponses
    func displayActionResults(responseDisplay: Models.PerformApiAction.ResponseDisplay) {
        resultsTextView.text = responseDisplay.result
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
