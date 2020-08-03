//
//  AppCoordinator.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/03.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

protocol AppCoordinatorType: Coordinator {
    func navigateToHome(navigationController: UINavigationController)
    func navigateToMyProject(navigationController: UINavigationController)
    func navigateToChat(navigationController: UINavigationController)
    func navigateToLogIn(navigationController: UINavigationController)
    func navigateToProfile(navigationController: UINavigationController)
}

class AppCoordinator: AppCoordinatorType {

    // MARK: - Properties

    private let window: UIWindow
    private let rootTabBarControllerFactory: RootTabBarControllerFactory
    private let homeCoordinatorFactory: HomeCoordinator.Factory
    private let myProjectCoordinatorFactory: MyProjectCoordinator.Factory
    private let chatCoordinatorFactory: ChatCoordinator.Factory
    private let logInCoordinatorFactory: LogInCoordinator.Factory

    // MARK: - Lifecycle

    init(
        window: UIWindow,
        rootTabBarControllerFactory: @escaping RootTabBarControllerFactory,
        homeCoordinatorFactory: HomeCoordinator.Factory,
        myProjectCoordinatorFactory: MyProjectCoordinator.Factory,
        chatCoordinatorFactory: ChatCoordinator.Factory,
        logInCoordinatorFactory: LogInCoordinator.Factory
    ) {
        self.window = window
        self.rootTabBarControllerFactory = rootTabBarControllerFactory
        self.homeCoordinatorFactory = homeCoordinatorFactory
        self.myProjectCoordinatorFactory = myProjectCoordinatorFactory
        self.chatCoordinatorFactory = chatCoordinatorFactory
        self.logInCoordinatorFactory = logInCoordinatorFactory
    }

    // MARK: - Functions

    func start() {
        let rootViewController = rootTabBarControllerFactory(self)
        window.rootViewController = rootViewController
    }

    func navigateToHome(navigationController: UINavigationController) {
        let coordinator = homeCoordinatorFactory.create(
            payload: .init(navigationController: navigationController)
        )
        coordinator.start()
    }

    func navigateToMyProject(navigationController: UINavigationController) {
        let coordinator = myProjectCoordinatorFactory.create(
            payload: .init(navigationController: navigationController)
        )
        coordinator.start()
    }

    func navigateToChat(navigationController: UINavigationController) {
        let coordinator = chatCoordinatorFactory.create(
            payload: .init(navigationController: navigationController)
        )
        coordinator.start()
    }

    func navigateToLogIn(navigationController: UINavigationController) {
        let coordinator = logInCoordinatorFactory.create(
            payload: .init(navigationController: navigationController)
        )
        coordinator.start()
    }

    func navigateToProfile(navigationController: UINavigationController) {
//        let coordinator = profileCoordinatorFactory.create(
//            payload: .init(navigationController: navigationController)
//        )
//        coordinator.start()
        navigationController.pushViewController(ViewController2(), animated: true)
    }
}
