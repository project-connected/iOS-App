//
//  HomeCoordinator.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/04.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import Pure

extension HomeCoordinator: FactoryModule {
    struct Dependency {
        let homeContainerViewControllerFactory: HomeContainerViewController.Factory
    }

    struct Payload {
        let navigationController: UINavigationController
    }
}

protocol HomeCoordinatorType: Coordinator {

}

class HomeCoordinator: HomeCoordinatorType {

    // MARK: - Properties

    private let navigationController: UINavigationController
    private let homeContainerViewControllerFactory: HomeContainerViewController.Factory

    // MARK: - Lifecycle

    required init(dependency: Dependency, payload: Payload) {
        self.navigationController = payload.navigationController
        self.homeContainerViewControllerFactory = dependency.homeContainerViewControllerFactory
    }

    // MARK: - Functions

    func start() {
        let viewController = homeContainerViewControllerFactory.create()
        navigationController.pushViewController(viewController, animated: true)
    }

}
