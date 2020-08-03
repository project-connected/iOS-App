//
//  MyProjectCoordinator.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/04.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import Pure

extension MyProjectCoordinator: FactoryModule {
    struct Dependency {
        let myProjectContainerViewControllerFactory: MyProjectContainerViewController.Factory
    }

    struct Payload {
        let navigationController: UINavigationController
    }
}

protocol MyProjectCoordinatorType: Coordinator {

}

class MyProjectCoordinator: MyProjectCoordinatorType {

    // MARK: - Properties

    private let navigationController: UINavigationController
    private let myProjectContainerViewControllerFactory: MyProjectContainerViewController.Factory

    // MARK: - Lifecycle

    required init(dependency: Dependency, payload: Payload) {
        self.navigationController = payload.navigationController
        self.myProjectContainerViewControllerFactory = dependency.myProjectContainerViewControllerFactory
    }

    // MARK: - Functions

    func start() {
        let viewController = myProjectContainerViewControllerFactory.create()
        navigationController.pushViewController(viewController, animated: true)
    }

}
