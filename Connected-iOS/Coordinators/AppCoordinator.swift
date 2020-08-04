//
//  AppCoordinator.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/03.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

protocol AppCoordinatorType: Coordinator {
    func clearChildren()
    func navigateToHome(navigationController: UINavigationController)
    func navigateToMyProject(navigationController: UINavigationController)
    func navigateToChat(navigationController: UINavigationController)
    func navigateToLogIn(navigationController: UINavigationController)
    func navigateToProfile(navigationController: UINavigationController)
}

class AppCoordinator: AppCoordinatorType {

    // MARK: - Properties

    private var children = [Coordinator]()
    private let window: UIWindow
    private let rootTabBarControllerFactory: RootTabBarControllerFactory
    private let homeCoordinatorFactory: HomeCoordinator.Factory
    private let myProjectCoordinatorFactory: MyProjectCoordinator.Factory
    private let chatCoordinatorFactory: ChatCoordinatorFactory
    private let logInCoordinatorFactory: LogInCoordinatorFactory

    // MARK: - Lifecycle

    init(
        window: UIWindow,
        rootTabBarControllerFactory: @escaping RootTabBarControllerFactory,
        homeCoordinatorFactory: HomeCoordinator.Factory,
        myProjectCoordinatorFactory: MyProjectCoordinator.Factory,
        chatCoordinatorFactory: @escaping ChatCoordinatorFactory,
        logInCoordinatorFactory: @escaping LogInCoordinatorFactory
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

    func clearChildren() {
        children = []
    }

    func navigateToHome(navigationController: UINavigationController) {
        let coordinator = homeCoordinatorFactory.create(
            payload: .init(navigationController: navigationController)
        )
        children.append(coordinator)
        coordinator.start()
    }

    func navigateToMyProject(navigationController: UINavigationController) {
        let coordinator = myProjectCoordinatorFactory.create(
            payload: .init(navigationController: navigationController)
        )
        children.append(coordinator)
        coordinator.start()
    }

    func navigateToChat(navigationController: UINavigationController) {
        let coordinator = chatCoordinatorFactory(navigationController)
        children.append(coordinator)
        coordinator.start()
    }

    func navigateToLogIn(navigationController: UINavigationController) {
        let coordinator = logInCoordinatorFactory(navigationController)
        children.append(coordinator)
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
