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
                        viewModelFactory: .init()
                    )
                ),
                pageDataSourceFactory: .init(
                    dependency: .init()
                )
            )
        )
    }
}

// MARK: - TopTabBarViewController

extension TopTabBarViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: TopTabBarViewModel.Factory
    }
}

extension Factory where Module == TopTabBarViewController {
    func create() -> TopTabBarViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create()
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
        let pageDataSourceFactory: MyProjectPageDataSource.Factory
    }
}

extension Factory where Module == MyProjectContainerViewController {
    func create() -> MyProjectContainerViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            topTabBarViewController: dependency.topTabBarViewControllerFactory.create(),
            pageDataSource: dependency.pageDataSourceFactory.create()
        )
        return module
    }
}

// MARK: - MyProjectPageDataSource

extension MyProjectPageDataSource: FactoryModule {
    struct Dependency {

    }
}

extension Factory where Module == MyProjectPageDataSource {
    func create() -> MyProjectPageDataSource {
        let module = Module()
        return module
    }
}
