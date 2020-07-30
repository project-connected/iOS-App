//
//  ProfileDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import Pure

extension AppDependency {

    static func resolveLogInDependencies(
        networkService: NetworkServiceType
    ) -> LogInViewController.Factory {

        let userInfoValidator = UserInfoValidator()

        return LogInViewController.Factory(
            dependency: .init(
                viewModelFactory: .init(
                    dependency: .init()
                ),
                signUpViewControllerFactory: .init(
                    dependency: .init(
                        viewModelFactory: .init(
                            dependency: .init(
                                networkService: networkService,
                                userInfoValidator: userInfoValidator
                            )
                        ),
                        webViewControllerFactory: .init(
                            dependency: .init(
                                viewModelFactory: .init(
                                    dependency: .init()
                                )
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

// MARK: - SignUpViewModel

extension SignUpViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {
        let networkService: NetworkServiceType
        let userInfoValidator: UserInfoValidatorType
    }
}

extension Factory where Module == SignUpViewModel {
    func create() -> SignUpViewModelType {
        let module = Module(
            networkService: dependency.networkService,
            userInfoValidator: dependency.userInfoValidator
        )
        return module
    }
}

// MARK: - SignUpViewController

extension SignUpViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: SignUpViewModel.Factory
        let webViewControllerFactory: WebViewController.Factory
    }
}

extension Factory where Module == SignUpViewController {
    func create() -> UIViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            webViewControllerFactory: dependency.webViewControllerFactory
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

// MARK: - WebViewModel

extension WebViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {

    }
}

extension Factory where Module == WebViewModel {
    func create() -> WebViewModel {
        let module = Module()
        return module
    }
}

// MARK: - WebViewController

extension WebViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: WebViewModel.Factory
    }
}

extension Factory where Module == WebViewController {
    func create() -> WebViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create()
        )
        return module
    }
}
