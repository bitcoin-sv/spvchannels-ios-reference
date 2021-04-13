//
//  AppDelegate.swift
//  spvchannels
//
//  Copyright (c) 2021 Bitcoin Association.
//  Distributed under the Open BSV software license, see the accompanying file LICENSE
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var sceneCoordinator: SceneCoordinator?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupSceneCoordinator()
        return true
    }

    private func setupSceneCoordinator() {
        let navController = UINavigationController()
        navController.setNavigationBarHidden(true, animated: false)
        sceneCoordinator = SceneCoordinator(navigationController: navController)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        sceneCoordinator?.start()
    }
}
