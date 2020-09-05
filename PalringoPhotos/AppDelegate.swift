//
//  AppDelegate.swift
//  PalringoPhotos
//
//  Created by Olivier Conan on 05/09/2020.
//  Copyright © 2020 Palringo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var coordinator: Coordinator?
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        let navController = UINavigationController()
        navController.navigationBar.barStyle = .blackTranslucent
        coordinator = Coordinator(navigationController: navController)
        coordinator?.start()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = .white
        window?.rootViewController = navController
        window?.makeKeyAndVisible()

        return true
    }

}
