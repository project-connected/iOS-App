//
//  MyProjectCoordinator.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/04.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

protocol MyProjectCoordinatorType: Coordinator {

}

class MyProjectCoordinator: Coordinator {

    // MARK: - Properties

    private let navigationController: UINavigationController
    private let myProjectContainerViewControllerFactory: MyProjectContainerViewControllerFactory

    // MARK: - Lifecycle

    init(
        navigationController: UINavigationController,
        myProjectContainerViewControllerFactory: @escaping MyProjectContainerViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.myProjectContainerViewControllerFactory = myProjectContainerViewControllerFactory
    }

    // MARK: - Functions

    func start() {
        let viewController = myProjectContainerViewControllerFactory()
        navigationController.pushViewController(viewController, animated: true)
    }

}

extension MyProjectCoordinator: MyProjectCoordinatorType {

}
