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

    private let viewModel: AppDelegateViewModelType
    private let analyticsService: AnalyticsServiceType.Type
    private let networkService: NetworkServiceType
    private let rootViewController: UIViewController

    // MARK: - Lifecycle

    private override init() {
        let dependency = AppDependency.resolve()
        self.viewModel = dependency.viewModelFactory.create()
        self.analyticsService = dependency.analyticsService
        self.networkService = dependency.networkService
        self.rootViewController = dependency.rootViewController
        super.init()
    }

    init(
        viewModel: AppDelegateViewModelType,
        analyticsService: AnalyticsServiceType.Type,
        networkService: NetworkServiceType,
        rootViewController: UIViewController
    ) {
        self.viewModel = viewModel
        self.analyticsService = analyticsService
        self.networkService = networkService
        self.rootViewController = rootViewController

        super.init()
    }

    // MARK: - Functions

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

        analyticsService.configure()

        window = UIWindow()
        window?.rootViewController = rootViewController
        window?.makeKeyAndVisible()

        bindViewModel()

        return true
    }

    private func bindViewModel() {

    }
}
