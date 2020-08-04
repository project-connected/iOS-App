//
//  AppDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/16.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import Firebase

extension AppDependency {

    static func resolve() -> AppDependency {

        let networkService: NetworkServiceType = TestNetworkService()
//        let analyticsService: AnalyticsServiceType.Type = FirebaseApp.self
        let analyticsService: AnalyticsServiceType.Type = MockAnalyticsService.self
        let imageLoader: ImageLoaderType = KingfisherImageLoader()

        let errorCellViewModelFactory: ErrorCellViewModelFactory = { ErrorCellViewModel() }

        let homeCoordinatorFactory = resolveHomeDependencies(
            networkService: networkService,
            imageLoader: imageLoader,
            errorCellViewModelFactory: errorCellViewModelFactory
        )

        let myProjectCoordinatorFactory = resolveMyProjectDependencies(
            networkService: networkService,
            imageLoader: imageLoader
        )

        let chatCoordinatorFactory = resolveChatDependencies(
            networkService: networkService,
            imageLoader: imageLoader,
            errorCellViewModelFactory: errorCellViewModelFactory
        )

        let loginCoordinatorFactory = resolveLogInDependencies(
            networkService: networkService
        )

        let rootTabBarControllerFactory: RootTabBarControllerFactory = { coordinator in
            RootTabBarController(
                viewModel: RootViewModel(),
                coordinator: coordinator
            )
        }

        let appCoordinatorFactory: AppCoordinatorFactory = { window in
            AppCoordinator(
                window: window,
                rootTabBarControllerFactory: rootTabBarControllerFactory,
                homeCoordinatorFactory: homeCoordinatorFactory,
                myProjectCoordinatorFactory: myProjectCoordinatorFactory,
                chatCoordinatorFactory: chatCoordinatorFactory,
                logInCoordinatorFactory: loginCoordinatorFactory
            )
        }

        return AppDependency(
            viewModel: AppDelegateViewModel(),
            analyticsService: analyticsService,
            appCoordinatorFactory: appCoordinatorFactory
        )
    }

}

// MARK: - AppDependency

struct AppDependency {
    let viewModel: AppDelegateViewModelType
    let analyticsService: AnalyticsServiceType.Type
    let appCoordinatorFactory: AppCoordinatorFactory
}

typealias AppCoordinatorFactory = (UIWindow) -> AppCoordinatorType

typealias RootTabBarControllerFactory = (AppCoordinatorType) -> RootTabBarController

typealias ErrorCellViewModelFactory = () -> ErrorCellViewModelType
