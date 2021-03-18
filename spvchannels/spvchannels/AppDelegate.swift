//
//  AppDelegate.swift
//  spvchannels
//  Created by Equaleyes Solutions
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
        window?.rootViewController = navController
        window?.makeKeyAndVisible()
        sceneCoordinator?.start()
    }
}
