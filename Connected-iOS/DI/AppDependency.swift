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

        let networkService: NetworkServiceType = MockNetworkService()
//        let analyticsService: AnalyticsServiceType.Type = FirebaseApp.self
        let analyticsService: AnalyticsServiceType.Type = MockAnalyticsService.self
        let imageLoader: ImageLoaderType = KingfisherImageLoader()

        let homeContainerViewControllerFactory = resolveHomeContainerDependencies(
            networkService: networkService,
            imageLoader: imageLoader
        )

        let myProjectContainerViewControllerFactory = resolveMyProjectContainerDependencies(
            networkService: networkService,
            imageLoader: imageLoader
        )

        let chatLobbyViewControllerFactory = resolveChatDependencies(
            networkService: networkService,
            imageLoader: imageLoader
        )

        let loginViewControllerFactory = resolveLogInDependencies(
            networkService: networkService
        )

        let rootTabBarControllerFactory: RootTabBarController.Factory = .init(
            dependency: .init(
                viewModelFactory: .init(
                    dependency: .init()
                ),
                homeContainerViewControllerFactory: homeContainerViewControllerFactory,
                myProjectContainerViewControllerFactory: myProjectContainerViewControllerFactory,
                chatLobbyViewControllerFactory: chatLobbyViewControllerFactory,
                loginViewControllerFactory: loginViewControllerFactory
            )
        )

        return AppDependency(
            viewModelFactory: .init(
                dependency: .init()
            ),
            analyticsService: analyticsService,
            networkService: networkService,
            rootViewController: rootTabBarControllerFactory.create()
        )
    }

}

// MARK: - AppDependency

struct AppDependency {
    let viewModelFactory: AppDelegateViewModel.Factory
    let analyticsService: AnalyticsServiceType.Type
    let networkService: NetworkServiceType
    let rootViewController: UIViewController
}

// MARK: - AppDelegateViewModel

extension AppDelegateViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {

    }
}

extension Factory where Module == AppDelegateViewModel {
    func create() -> AppDelegateViewModelType {
        let module = Module()
        return module
    }
}

// MARK: - RootViewModel

extension RootViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {

    }
}

extension Factory where Module == RootViewModel {
    func create() -> RootViewModelType {
        let module = Module()
        return module
    }
}

// MARK: - RootTabBarController

extension RootTabBarController: FactoryModule {
    struct Dependency {
        let viewModelFactory: RootViewModel.Factory
        let homeContainerViewControllerFactory: HomeContainerViewController.Factory
        let myProjectContainerViewControllerFactory: MyProjectContainerViewController.Factory
        let chatLobbyViewControllerFactory: ChatLobbyViewController.Factory
        let loginViewControllerFactory: LogInViewController.Factory
    }
}

extension Factory where Module == RootTabBarController {
    func create() -> UIViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            homeContainerViewControllerFactory: dependency.homeContainerViewControllerFactory,
            myProjectContainerViewControllerFactory: dependency.myProjectContainerViewControllerFactory,
            chatLobbyViewControllerFactory: dependency.chatLobbyViewControllerFactory,
            logInViewControllerFactory: dependency.loginViewControllerFactory
        )
        return module
    }
}
