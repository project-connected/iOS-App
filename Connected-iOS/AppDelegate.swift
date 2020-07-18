//
//  AppDelegate.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/14.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: - Properties

    var window: UIWindow?

    private let dependency: AppDependency

    // MARK: - Lifecycle

    private override init() {
        self.dependency = .resolve()
        super.init()
    }

    init(dependency: AppDependency) {
        self.dependency = dependency
        super.init()
    }

    // MARK: - Functions

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        dependency.analyticsService.configure()

        window = UIWindow()
        window?.makeKeyAndVisible()
        let factory = dependency.viewControllerFactory
        window?.rootViewController = factory.create()

        return true
    }
}
