//
//  ProfileCoordinator.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/04.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import Pure

extension LogInCoordinator: FactoryModule {
    struct Dependency {
        let loginViewControllerFactory: LogInViewController.Factory
    }

    struct Payload {
        let navigationController: UINavigationController
    }
}

protocol LogInCoordinatorType: Coordinator {

}

class LogInCoordinator: LogInCoordinatorType {

    // MARK: - Properties

    let navigationController: UINavigationController
    private let logInViewControllerFactory: LogInViewController.Factory

    // MARK: - Lifecycle

    required init(dependency: Dependency, payload: Payload) {
        self.navigationController = payload.navigationController
        self.logInViewControllerFactory = dependency.loginViewControllerFactory
    }

    // MARK: - Functions

    func start() {
        let viewController = logInViewControllerFactory.create()
        navigationController.pushViewController(viewController, animated: true)
    }
}
