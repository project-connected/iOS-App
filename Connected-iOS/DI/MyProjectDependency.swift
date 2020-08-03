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
    static func resolveMyProjectDependencies(
        networkService: NetworkServiceType,
        imageLoader: ImageLoaderType
    ) -> MyProjectCoordinator.Factory {
        return .init(
            dependency: .init(
                myProjectContainerViewControllerFactory: .init(
                    dependency: .init(
                        viewModelFactory: .init(),
                        topTabBarViewControllerFactory: .init(
                            dependency: .init(
                                viewModelFactory: .init()
                            )
                        ),
                        pageDataSourceFactory: .init(
                            dependency: .init(
                                pageViewControllerFactory: .init(
                                    dependency: .init(
                                        viewModelFactory: .init(
                                            dependency: .init(
                                                networkService: networkService
                                            )
                                        ),
                                        myProjectDataSourceFactory: .init(
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
        let pageViewControllerFactory: MyProjectPageViewController.Factory
    }
}

extension Factory where Module == MyProjectPageDataSource {
    func create() -> MyProjectPageDataSource {
        let module = Module(
            myProjectPageViewControllerFactory: dependency.pageViewControllerFactory
        )
        return module
    }
}

// MARK: - MyProjectPageViewModel

extension MyProjectPageViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {
        let networkService: NetworkServiceType
    }
}

extension Factory where Module == MyProjectPageViewModel {
    func create() -> MyProjectPageViewModel {
        let module = Module(
            networkService: dependency.networkService
        )
        return module
    }
}

// MARK: - MyProjectPageViewController

extension MyProjectPageViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: MyProjectPageViewModel.Factory
        let myProjectDataSourceFactory: MyProjectDataSource.Factory
    }
}

extension Factory where Module == MyProjectPageViewController {
    func create() -> MyProjectPageViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            dataSource: dependency.myProjectDataSourceFactory.create()
        )
        return module
    }
}

// MARK: - MyProjectDataSource

extension MyProjectDataSource: FactoryModule {
    struct Dependency {

    }
}

extension Factory where Module == MyProjectDataSource {
    func create() -> MyProjectDataSource {
        let module = Module()
        return module
    }
}
