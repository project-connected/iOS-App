//
//  AppDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/16.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import Pure
import Firebase

extension AppDependency {

    private static func resolveLogInDependencies(
        networkService: NetworkServiceType
    ) -> LogInViewController.Factory {
        return LogInViewController.Factory(
            dependency: .init(
                viewModelFactory: .init(
                    dependency: .init()
                ),
                signUpViewControllerFactory: .init(
                    dependency: .init(
                        viewModelFactory: .init(
                            dependency: .init(
                                networkService: networkService
                            )
                        )
                    )
                ),
                signInViewControllerFactory: .init(
                    dependency: .init(
                        viewModelFactory: .init(
                            dependency: .init(
                                networkService: networkService
                            )
                        )
                    )
                )
            )
        )
    }

    private static func resolveHomeContainerDependencies(
        networkService: NetworkServiceType,
        imageLoader: ImageLoaderType
    ) -> HomeContainerViewController.Factory {
        return .init(
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
                                                        imageLoader: imageLoader
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
    }

    static func resolve() -> AppDependency {

        let networkService: NetworkServiceType = MockNetworkService()
//        let analyticsService: AnalyticsServiceType.Type = FirebaseApp.self
        let analyticsService: AnalyticsServiceType.Type = MockAnalyticsService.self
        let imageLoader: ImageLoaderType = KingfisherImageLoader()

        let homeContainerViewControllerFactory = resolveHomeContainerDependencies(
            networkService: networkService,
            imageLoader: imageLoader
        )

        let loginViewControllerFactory = resolveLogInDependencies(networkService: networkService)

        let rootTabBarControllerFactory: RootTabBarController.Factory = .init(
            dependency: .init(
                viewModelFactory: .init(
                    dependency: .init()
                ),
                homeContainerViewControllerFactory: homeContainerViewControllerFactory,
                loginViewControllerFactory: loginViewControllerFactory
            )
        )

        return AppDependency(
            viewModelFactory: .init(
                dependency: .init()
            ),
            analyticsService: analyticsService,
            networkService: networkService,
            rootViewController: rootTabBarControllerFactory.create()
        )
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
            self.bindViewModel()
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
            self.bindViewModel()
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

    struct Dependency {

    }
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

    struct Dependency {

    }
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
    }

    struct Payload {
        let project: Project
    }

    func configure(dependency: Dependency, payload: Payload) {
        if self.viewModel == nil {
            self.viewModel = dependency.viewModelFactory.create()
            self.imageLoader = dependency.imageLoader
            self.bindViewModel()
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

// MARK: - SignInViewController

extension SignInViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: SignInViewModel.Factory
    }
}

extension Factory where Module == SignInViewController {
    func create() -> UIViewController {
        let module = Module(viewModel: dependency.viewModelFactory.create())
        return module
    }
}

// MARK: - SignInViewModel

extension SignInViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {
        let networkService: NetworkServiceType
    }
}

extension Factory where Module == SignInViewModel {
    func create() -> SignInViewModelType {
        let module = Module(networkService: dependency.networkService)
        return module
    }
}

// MARK: - AppDependency

struct AppDependency {
    let viewModelFactory: AppDelegateViewModel.Factory
    let analyticsService: AnalyticsServiceType.Type
    let networkService: NetworkServiceType
    let rootViewController: UIViewController
}

// MARK: - AppDelegateViewModel

extension AppDelegateViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {

    }
}

extension Factory where Module == AppDelegateViewModel {
    func create() -> AppDelegateViewModelType {
        let module = Module()
        return module
    }
}

// MARK: - SignUpViewModel

extension SignUpViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {
        let networkService: NetworkServiceType
    }
}

extension Factory where Module == SignUpViewModel {
    func create() -> SignUpViewModelType {
        let module = Module(
            networkService: dependency.networkService
        )
        return module
    }
}

// MARK: - SignUpViewController

extension SignUpViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: SignUpViewModel.Factory
    }
}

extension Factory where Module == SignUpViewController {
    func create() -> UIViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create()
        )
        return module
    }
}

// MARK: - LogInViewModel

extension LogInViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {

    }
}

extension Factory where Module == LogInViewModel {
    func create() -> LogInViewModelType {
        let module = Module()
        return module
    }
}

// MARK: - LogInViewController

extension LogInViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: LogInViewModel.Factory
        let signUpViewControllerFactory: SignUpViewController.Factory
        let signInViewControllerFactory: SignInViewController.Factory
    }
}

extension Factory where Module == LogInViewController {
    func create() -> UIViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            signUpViewControllerFactory: dependency.signUpViewControllerFactory,
            signInViewControllerFactory: dependency.signInViewControllerFactory
        )
        return module
    }
}

// MARK: - RootViewModel

extension RootViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {

    }
}

extension Factory where Module == RootViewModel {
    func create() -> RootViewModelType {
        let module = Module()
        return module
    }
}

// MARK: - RootTabBarController

extension RootTabBarController: FactoryModule {
    struct Dependency {
        let viewModelFactory: RootViewModel.Factory
        let homeContainerViewControllerFactory: HomeContainerViewController.Factory
        let loginViewControllerFactory: LogInViewController.Factory
    }
}

extension Factory where Module == RootTabBarController {
    func create() -> UIViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            homeContainerViewControllerFactory: dependency.homeContainerViewControllerFactory,
            logInViewControllerFactory: dependency.loginViewControllerFactory
        )
        return module
    }
}
