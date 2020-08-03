//
//  AppDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/16.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import Pure
import Firebase

extension AppDependency {

    static func resolve() -> AppDependency {

        let networkService: NetworkServiceType = TestNetworkService()
//        let analyticsService: AnalyticsServiceType.Type = FirebaseApp.self
        let analyticsService: AnalyticsServiceType.Type = MockAnalyticsService.self
        let imageLoader: ImageLoaderType = KingfisherImageLoader()

        let homeCoordinatorFactory = resolveHomeDependencies(
            networkService: networkService,
            imageLoader: imageLoader
        )

        let myProjectCoordinatorFactory = resolveMyProjectDependencies(
            networkService: networkService,
            imageLoader: imageLoader
        )

        let chatCoordinatorFactory = resolveChatDependencies(
            networkService: networkService,
            imageLoader: imageLoader
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
            viewModelFactory: { AppDelegateViewModel() },
            analyticsService: analyticsService,
            appCoordinatorFactory: appCoordinatorFactory
        )
    }

}

// MARK: - AppDependency

struct AppDependency {
    let viewModelFactory: AppDelegateViewModelFactory
    let analyticsService: AnalyticsServiceType.Type
    let appCoordinatorFactory: AppCoordinatorFactory
}

typealias AppDelegateViewModelFactory = () -> AppDelegateViewModelType

typealias AppCoordinatorFactory = (UIWindow) -> AppCoordinatorType

typealias RootViewModelFactory = () -> RootViewModelType
typealias RootTabBarControllerFactory = (AppCoordinatorType) -> RootTabBarController
