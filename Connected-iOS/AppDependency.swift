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

    static func resolve() -> AppDependency {

        let networkService: NetworkServiceType = TempNetworkService()
        let analyticsService: AnalyticsServiceType.Type = FirebaseApp.self

        let loginViewControllerFactory: LogInViewController.Factory = .init(
            dependency: .init(
                viewModelFactory: LogInViewModel.Factory(
                    dependency: .init()
                ),
                signUpViewControllerFactory: SignUpViewController.Factory(
                    dependency: .init(
                        viewModelFactory: SignUpViewModel.Factory(
                            dependency: .init(
                                networkService: networkService
                            )
                        )
                    )
                )
            )
        )

        let rootTabBarControllerFactory: RootTabBarController.Factory = .init(
            dependency: .init(
                viewModelFactory: RootViewModel.Factory(
                    dependency: .init()
                ),
                loginViewControllerFactory: loginViewControllerFactory
            )
        )

        return AppDependency(
            viewModel: AppDelegateViewModel.Factory(
                dependency: .init()
            ),
            analyticsService: analyticsService,
            networkService: networkService,
            rootTabBarControllerFactory: rootTabBarControllerFactory
        )
    }

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
    func create() -> Module {
        let module = Module()
        return module
    }
}

// MARK: - AppDependency

struct AppDependency {
    let viewModel: AppDelegateViewModel.Factory
    let analyticsService: AnalyticsServiceType.Type
    let networkService: NetworkServiceType
    let rootTabBarControllerFactory: RootTabBarController.Factory
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
    func create() -> Module {
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
    func create() -> Module {
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
    func create() -> Module {
        let module = Module()
        return module
    }
}

// MARK: - LogInViewController

extension LogInViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: LogInViewModel.Factory
        let signUpViewControllerFactory: SignUpViewController.Factory
    }
}

extension Factory where Module == LogInViewController {
    func create() -> Module {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            signUpViewControllerFactory: dependency.signUpViewControllerFactory
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
    func create() -> Module {
        let module = Module()
        return module
    }
}

// MARK: - RootTabBarController

extension RootTabBarController: FactoryModule {
    struct Dependency {
        let viewModelFactory: RootViewModel.Factory
        let loginViewControllerFactory: LogInViewController.Factory
    }
}

extension Factory where Module == RootTabBarController {
    func create() -> Module {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            logInViewControllerFactory: dependency.loginViewControllerFactory
        )
        return module
    }
}
