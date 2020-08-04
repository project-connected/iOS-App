//
//  HomeDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

extension AppDependency {
    static func resolveHomeDependencies(
        networkService: NetworkServiceType,
        imageLoader: ImageLoaderType,
        errorCellViewModelFactory: @escaping ErrorCellViewModelFactory
    ) -> HomeCoordinatorFactory {
        return { navigationController in
            HomeCoordinator(
                navigationController: navigationController,
                homeContainerViewControllerFactory: { coordinator in
                    HomeContainerViewController(
                        viewModel: HomeContainerViewModel(),
                        homeViewController: HomeViewController(
                            viewModel: HomeViewModel(networkService: networkService),
                            homeDataSource: HomeDataSource(
                                errorCellViewModelFactory: errorCellViewModelFactory,
                                projectCollectionCellFactory: { ProjectCollectionCellViewModel() },
                                projectThumbnailDataSourceFactory: {
                                    ProjectThumbnailDataSource(
                                        cellViewModelFactory: { ProjectThumbnailCellViewModel() },
                                        categoryDataSourceFactory: {
                                            CategoryDataSource(
                                                categoryCellViewModelFactory: { CategoryCellViewModel() }
                                            )
                                        },
                                        imageLoader: imageLoader
                                    )
                                },
                                coordinator: coordinator
                            )
                        )
                    )
                },
                projectDetailViewControllerFactory: { project in
                    ProjectDetailViewController(
                        viewModel: ProjectDetailViewModel(),
                        project: project
                    )
                }
            )
        }
    }
}

typealias HomeCoordinatorFactory = (UINavigationController) -> Coordinator

typealias HomeContainerViewControllerFactory = (ProjectDetailCoordinatorType) -> HomeContainerViewController
typealias HomeViewControllerFactory = () -> HomeViewController
typealias ProjectDetailViewControllerFactory = (Project) -> ProjectDetailViewController

typealias ProjectCollectionCellViewModelFactory = () -> ProjectCollectionCellViewModelType
typealias ProjectThumbnailCellViewModelFactory = () -> ProjectThumbnailCellViewModelType
typealias CategoryCellViewModelFactory = () -> CategoryCellViewModelType

typealias CategoryDataSourceFactory = () -> BaseDataSource
typealias ProjectThumbnailDataSourceFactory = () -> BaseDataSource
