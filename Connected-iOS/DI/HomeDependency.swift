//
//  HomeDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import Pure

extension AppDependency {
    static func resolveHomeDependencies(
        networkService: NetworkServiceType,
        imageLoader: ImageLoaderType
    ) -> HomeCoordinator.Factory {
        return .init(
            dependency: .init(
                homeContainerViewControllerFactory: .init(
                    dependency: .init(
                        viewModelFactory: .init(
                            dependency: .init()
                        ),
                        homeViewControllerFactory: .init(
                            dependency: .init(
                                viewModelFactory: .init(
                                    dependency: .init(
                                        networkService: networkService
                                    )
                                ),
                                homeDataSourceFactory: .init(
                                    dependency: .init(
                                        errorCellConfigurator: .init(
                                            dependency: .init(
                                                viewModelFactory: .init()
                                            )
                                        ),
                                        projectCollectionCellConfigurator: .init(
                                            dependency: .init(
                                                viewModelFactory: .init(),
                                                projectThumbnailCellDataSource: .init(
                                                    dependency: .init(
                                                        cellViewModelFactory: .init(),
                                                        cellConfigurator: .init(
                                                            dependency: .init(
                                                                viewModelFactory: .init(),
                                                                imageLoader: imageLoader,
                                                                categoryDataSourceFactory: .init(
                                                                    dependency: .init(
                                                                        categoryCellConfigurator: .init(
                                                                            dependency: .init(
                                                                                viewModelFactory: .init(
                                                                                    dependency: .init()
                                                                                )
                                                                            )
                                                                        )
                                                                    )
                                                                )
                                                            )
                                                        )
                                                    )
                                                )
                                            )
                                        )
                                    )
                                ),
                                projectDetailViewControllerFactory: .init(
                                    dependency: .init(
                                        viewModelFactory: .init(
                                            dependency: .init()
                                        )
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    }
}

// MARK: - CategoryDataSource

extension CategoryDataSource: FactoryModule {
    struct Dependency {
        let categoryCellConfigurator: CategoryCell.Configurator
    }
}

extension Factory where Module == CategoryDataSource {
    func create() -> CategoryDataSource {
        let module = Module(
            categoryCellConfigurator: dependency.categoryCellConfigurator
        )
        return module
    }
}

// MARK: - CategoryCellViewModel

extension CategoryCellViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency { }
}

extension Factory where Module == CategoryCellViewModel {
    func create() -> CategoryCellViewModel {
        let module = Module()
        return module
    }
}

// MARK: - CategoryCell

extension CategoryCell: ConfiguratorModule {
    struct Dependency {
        let viewModelFactory: CategoryCellViewModel.Factory
    }

    struct Payload {
        let category: String
    }

    func configure(dependency: Dependency, payload: Payload) {
        if self.viewModel == nil {
            self.viewModel = dependency.viewModelFactory.create()
        }
        self.configureWith(with: payload.category)
    }
}

// MARK: - ErrorCellViewModel

extension ErrorCellViewModel: FactoryModule {
    convenience init(dependency: (), payload: ()) {
        self.init()
    }
}

extension Factory where Module == ErrorCellViewModel {
    func create() -> ErrorCellViewModelType {
        let module = Module()
        return module
    }
}

// MARK: - ErrorCell

extension ErrorCell: ConfiguratorModule {
    struct Dependency {
        let viewModelFactory: ErrorCellViewModel.Factory
    }

    struct Payload {
        let error: Error
    }

    func configure(dependency: Dependency, payload: Payload) {
        if self.viewModel == nil {
            self.viewModel = dependency.viewModelFactory.create()
        }
        configureWith(with: payload.error)
    }
}

// MARK: - HomeDataSource

extension HomeDataSource: FactoryModule {
    struct Dependency {
        let errorCellConfigurator: ErrorCell.Configurator
        let projectCollectionCellConfigurator: ProjectCollectionCell.Configurator
    }
}

extension Factory where Module == HomeDataSource {
    func create() -> HomeDataSource {
        let module = Module(
            errorCellConfigurator: dependency.errorCellConfigurator,
            projectCollectionCellConfigurator: dependency.projectCollectionCellConfigurator
        )
        return module
    }
}

// MARK: - ProjectCollectionCellViewModel

extension ProjectCollectionCellViewModel: FactoryModule {
    convenience init(dependency: (), payload: ()) {
        self.init()
    }
}

extension Factory where Module == ProjectCollectionCellViewModel {
    func create() -> ProjectCollectionCellViewModelType {
        let module = Module()
        return module
    }
}

// MARK: - ProjectCollectionCell

extension ProjectCollectionCell: ConfiguratorModule {
    struct Dependency {
        let viewModelFactory: ProjectCollectionCellViewModel.Factory
        let projectThumbnailCellDataSource: ProjectThumbnailDataSource.Factory
    }

    struct Payload {
        let themedProjects: ThemedProjects
    }

    func configure(dependency: Dependency, payload: Payload) {
        if self.viewModel == nil {
            self.viewModel = dependency.viewModelFactory.create()
            self.dataSource = dependency.projectThumbnailCellDataSource.create()
        }
        self.configureWith(with: payload.themedProjects)
    }
}

// MARK: - HomeContainerViewController

extension HomeContainerViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: HomeContainerViewModel.Factory
        let homeViewControllerFactory: HomeViewController.Factory
    }
}

extension Factory where Module == HomeContainerViewController {
    func create() -> HomeContainerViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            homeViewController: dependency.homeViewControllerFactory.create()
        )
        return module
    }
}

// MARK: - HomeContainerViewModel

extension HomeContainerViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency { }
}

extension Factory where Module == HomeContainerViewModel {
    func create() -> HomeContainerViewModelType {
        let module = Module()
        return module
    }
}

// MARK: - ProjectDetailViewModel

extension ProjectDetailViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency { }
}

extension Factory where Module == ProjectDetailViewModel {
    func create() -> ProjectDetailViewModelType {
        let module = Module()
        return module
    }
}

// MARK: - ProjectDetailViewController

extension ProjectDetailViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: ProjectDetailViewModel.Factory
    }

    struct Payload {
        let project: Project
    }
}

extension Factory where Module == ProjectDetailViewController {
    func create(payload: Module.Payload) -> UIViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            project: payload.project
        )
        return module
    }
}

// MARK: - ProjectThumbnailCell

extension ProjectThumbnailCardCell: ConfiguratorModule {
    struct Dependency {
        let viewModelFactory: ProjectThumbnailCellViewModel.Factory
        let imageLoader: ImageLoaderType
        let categoryDataSourceFactory: CategoryDataSource.Factory
    }

    struct Payload {
        let project: Project
    }

    func configure(dependency: Dependency, payload: Payload) {
        if self.viewModel == nil {
            self.viewModel = dependency.viewModelFactory.create()
            self.imageLoader = dependency.imageLoader
            self.dataSource = dependency.categoryDataSourceFactory.create()
        }
        self.configureWith(with: payload.project)
    }
}

// MARK: - ProjectThumbnailCellViewModel

extension ProjectThumbnailCellViewModel: FactoryModule {
    convenience init(dependency: (), payload: ()) {
        self.init()
    }
}

extension Factory where Module == ProjectThumbnailCellViewModel {
    func create() -> ProjectThumbnailCellViewModelType {
        let module = Module()
        return module
    }
}

// MARK: - ProjectThumbnailDataSource

extension ProjectThumbnailDataSource: FactoryModule {

    struct Dependency {
        let cellViewModelFactory: ProjectThumbnailCellViewModel.Factory
        let cellConfigurator: ProjectThumbnailCardCell.Configurator
    }
}

extension Factory where Module == ProjectThumbnailDataSource {
    func create() -> BaseDataSource {
        let module = Module(
            cellViewModelFactory: dependency.cellViewModelFactory,
            cellConfigurator: dependency.cellConfigurator
        )
        return module
    }
}

// MARK: - HomeViewController

extension HomeViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: HomeViewModel.Factory
        let homeDataSourceFactory: HomeDataSource.Factory
        let projectDetailViewControllerFactory: ProjectDetailViewController.Factory
    }
}

extension Factory where Module == HomeViewController {
    func create() -> UIViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            homeDataSource: dependency.homeDataSourceFactory.create(),
            projectDetailViewControllerFactory: dependency.projectDetailViewControllerFactory
        )
        return module
    }
}

// MARK: - HomeViewModel

extension HomeViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {
        let networkService: NetworkServiceType
    }
}

extension Factory where Module == HomeViewModel {
    func create() -> HomeViewModelType {
        let module = Module(
            networkService: dependency.networkService
        )
        return module
    }
}
