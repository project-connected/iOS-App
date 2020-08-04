//
//  MyProjectDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

extension AppDependency {
    static func resolveMyProjectDependencies(
        networkService: NetworkServiceType,
        imageLoader: ImageLoaderType
    ) -> MyProjectCoordinatorFactory {
        return { navigationController in
            MyProjectCoordinator(
                navigationController: navigationController,
                myProjectContainerViewControllerFactory: {
                    MyProjectContainerViewController(
                        viewModel: MyProjectContainerViewModel(),
                        topTabBarViewController: TopTabBarViewController(
                            viewModel: TopTabBarViewModel()
                        ),
                        pageDataSource: MyProjectPageDataSource(
                            myProjectPageViewControllerFactory: {
                                MyProjectPageViewController(
                                    viewModel: MyProjectPageViewModel(
                                        networkService: networkService
                                    ),
                                    dataSource: MyProjectDataSource()
                                )
                            }
                        )
                    )
                }
            )
        }
    }
}

typealias MyProjectCoordinatorFactory = (UINavigationController) -> Coordinator

typealias MyProjectContainerViewControllerFactory = () -> MyProjectContainerViewController
typealias MyProjectPageViewControllerFactory = () -> MyProjectPageViewController
