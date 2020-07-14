//
//  AppDelegate.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/14.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        window = UIWindow()
        window?.makeKeyAndVisible()
        window?.rootViewController = ViewController()

        return true
    }
}
