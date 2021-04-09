//
//  SceneCoordinator.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import UIKit

typealias NavigatableVC = Coordinatable & CleanVIP & UIViewController

/// List of coordinated scenes is added in extensions
class Scenes {}

/// Concrete coordinator class to facilitate scene coordination and transitions
class SceneCoordinator: Coordinator {

    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        open(Scenes.Home) { _ in true }
    }

    func open<T: NavigatableVC>(_ viewController: T.Type,
                                animated: Bool = true,
                                passData: (_ viewController: T) -> Bool) {
        if let viewController: T = findExistingViewController(),
           passData(viewController) {
            navigationController.popToViewController(viewController, animated: animated)
        } else if let viewController: T = makeViewController(),
                  passData(viewController) {
            navigationController.pushViewController(viewController, animated: animated)
        }
    }

    private func findExistingViewController<T: NavigatableVC>() -> T? {
        navigationController.viewControllers
            .last { $0 is T } as? T
    }

    private func makeViewController<T: NavigatableVC>() -> T? {
        let viewController = T.init()
        viewController.setupVIP()
        viewController.coordinator = self
        return viewController
    }
}
