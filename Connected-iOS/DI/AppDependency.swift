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

    private static func resolveHomeDependencies(
        networkService: NetworkServiceType,
        imageLoader: ImageLoaderType
    ) -> HomeViewController.Factory {
        return HomeViewController.Factory(
            dependency: .init(
                viewModelFactory: .init(
                    dependency: .init(
                        networkService: networkService
                    )
                ),
                projectThumbnailDataSourceFactory: .init(
                    dependency: .init(
                        cellViewModelFactory: .init(),
                        cellConfigurator: .init(
                            dependency: .init(
                                viewModelFactory: .init(),
                                imageLoader: imageLoader
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
    }

    static func resolve() -> AppDependency {

        let networkService: NetworkServiceType = MockNetworkService()
        let analyticsService: AnalyticsServiceType.Type = FirebaseApp.self
        let imageLoader: ImageLoaderType = KingfisherImageLoader()

        let homeViewControllerFactory = resolveHomeDependencies(
            networkService: networkService,
            imageLoader: imageLoader
        )

        let loginViewControllerFactory = resolveLogInDependencies(networkService: networkService)

        let rootTabBarControllerFactory: RootTabBarController.Factory = .init(
            dependency: .init(
                viewModelFactory: .init(
                    dependency: .init()
                ),
                homeViewControllerFactory: homeViewControllerFactory,
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
    func create(_ payload: Module.Payload) -> ProjectDetailViewController {
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
        let projectThumbnailDataSourceFactory: ProjectThumbnailDataSource.Factory
        let projectDetailViewControllerFactory: ProjectDetailViewController.Factory
    }
}

extension Factory where Module == HomeViewController {
    func create() -> UIViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            projectThumbnailDataSource: dependency.projectThumbnailDataSourceFactory.create(),
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
        let homeViewControllerFactory: HomeViewController.Factory
        let loginViewControllerFactory: LogInViewController.Factory
    }
}

extension Factory where Module == RootTabBarController {
    func create() -> UIViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            homeViewControllerFactory: dependency.homeViewControllerFactory,
            logInViewControllerFactory: dependency.loginViewControllerFactory
        )
        return module
    }
}
