//
//  MyProjectDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import Pure

extension AppDependency {
    static func resolveMyProjectContainerDependencies(
        networkService: NetworkServiceType,
        imageLoader: ImageLoaderType
    ) -> MyProjectContainerViewController.Factory {
        return .init(
            dependency: .init(
                viewModelFactory: .init(),
                topTabBarViewControllerFactory: .init(
                    dependency: .init(
                        viewModelFactory: .init(),
                        topTabBarDataSourceFactory: .init(
                            dependency: .init(
                                cellConfigurator: .init(
                                    dependency: .init(
                                        viewModelFactory: .init()
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

// MARK: - TopTabBarCellViewModel

extension TopTabBarCellViewModel: FactoryModule {
    convenience init(dependency: (), payload: ()) {
        self.init()
    }
}

extension Factory where Module == TopTabBarCellViewModel {
    func create() -> TopTabBarCellViewModelType {
        let module = Module()
        return module
    }
}

// MARK: - TopTabBarCell

extension TopTabBarCell: ConfiguratorModule {
    struct Dependency {
        let viewModelFactory: TopTabBarCellViewModel.Factory
    }

    struct Payload {
        let index: Int
        let topTabBarItem: TopTabBarItem
    }

    func configure(dependency: Dependency, payload: Payload) {
        if self.viewModel == nil {
            self.viewModel = dependency.viewModelFactory.create()
            self.bindViewModel()
        }
        configureWith(with: (payload.index, payload.topTabBarItem))
    }
}

// MARK: - TopTabBarDataSource

extension TopTabBarDataSource: FactoryModule {
    struct Dependency {
        let cellConfigurator: TopTabBarCell.Configurator
    }
}

extension Factory where Module == TopTabBarDataSource {
    func create() -> TopTabBarDataSource {
        let module = Module(
            cellConfigurator: dependency.cellConfigurator
        )
        return module
    }
}

// MARK: - TopTabBarViewController

extension TopTabBarViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: TopTabBarViewModel.Factory
        let topTabBarDataSourceFactory: TopTabBarDataSource.Factory
    }
}

extension Factory where Module == TopTabBarViewController {
    func create() -> TopTabBarViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            dataSource: dependency.topTabBarDataSourceFactory.create()
        )
        return module
    }
}

// MARK: - TopTabBarViewModel

extension TopTabBarViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init()
    }
}

extension Factory where Module == TopTabBarViewModel {
    func create() -> TopTabBarViewModel {
        let module = Module()
        return module
    }
}

// MARK: - MyProjectContainerViewModel

extension MyProjectContainerViewModel: FactoryModule {
    convenience init(dependency: (), payload: ()) {
        self.init()
    }
}

extension Factory where Module == MyProjectContainerViewModel {
    func create() -> MyProjectContainerViewModel {
        let module = Module()
        return module
    }
}

// MARK: - MyProjectContainerViewController

extension MyProjectContainerViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: MyProjectContainerViewModel.Factory
        let topTabBarViewControllerFactory: TopTabBarViewController.Factory
    }
}

extension Factory where Module == MyProjectContainerViewController {
    func create() -> MyProjectContainerViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            topTabBarViewController: dependency.topTabBarViewControllerFactory.create()
        )
        return module
    }
}
