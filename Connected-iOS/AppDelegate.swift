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

    var window: UIWindow? = UIWindow()

    private let viewModel: AppDelegateViewModelType
    private let analyticsService: AnalyticsServiceType.Type
    private let appCoordinator: AppCoordinatorType

    // MARK: - Lifecycle

    private override init() {
        let dependency = AppDependency.resolve()
        self.viewModel = dependency.viewModelFactory()
        self.analyticsService = dependency.analyticsService

        guard let window = window else {
            fatalError("UIWindow is nil")
        }
        self.appCoordinator = dependency.appCoordinatorFactory(window)

        super.init()
    }

    init(
        viewModel: AppDelegateViewModelType,
        analyticsService: AnalyticsServiceType.Type,
        appCoordinatorFactory: @escaping AppCoordinatorFactory
    ) {
        self.viewModel = viewModel
        self.analyticsService = analyticsService

        guard let window = window else {
            fatalError("UIWindow is nil")
        }
        self.appCoordinator = appCoordinatorFactory(window)

        super.init()
    }

    // MARK: - Functions

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        bindViewModel()

        analyticsService.configure()

        window?.makeKeyAndVisible()
        appCoordinator.start()

        return true
    }

    private func bindViewModel() {

    }
}
