//
//  HomeCoordinator.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/04.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

protocol ProjectDetailCoordinatorType: Coordinator {
    func pushToProjectDetail(project: Project)
}

class HomeCoordinator: Coordinator {

    // MARK: - Properties

    private let navigationController: UINavigationController
    private let homeContainerViewControllerFactory: HomeContainerViewControllerFactory
    private let projectDetailViewControllerFactory: ProjectDetailViewControllerFactory

    // MARK: - Lifecycle

    init(
        navigationController: UINavigationController,
        homeContainerViewControllerFactory: @escaping HomeContainerViewControllerFactory,
        projectDetailViewControllerFactory: @escaping ProjectDetailViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.homeContainerViewControllerFactory = homeContainerViewControllerFactory
        self.projectDetailViewControllerFactory = projectDetailViewControllerFactory
    }

    // MARK: - Functions

    func start() {
        let viewController = homeContainerViewControllerFactory(self)
        navigationController.pushViewController(viewController, animated: true)
    }

}

extension HomeCoordinator: ProjectDetailCoordinatorType {
    func pushToProjectDetail(project: Project) {
        let viewController = projectDetailViewControllerFactory(project)
        navigationController.pushViewController(viewController, animated: true)
    }
}
