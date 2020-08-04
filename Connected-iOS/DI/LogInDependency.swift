//
//  LogInDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

extension AppDependency {

    static func resolveLogInDependencies(
        networkService: NetworkServiceType
    ) -> LogInCoordinatorFactory {

        let userInfoValidator = UserInfoValidator()

        return { navigationController in
            LogInCoordinator(
                navigationController: navigationController,
                logInViewControllerFactory: { coordinator in
                    LogInViewController(
                        viewModel: LogInViewModel(),
                        coordinator: coordinator
                    )
                },
                signUpViewControllerFactory: { coordinator in
                    SignUpViewController(
                        viewModel: SignUpViewModel(
                            networkService: networkService,
                            userInfoValidator: userInfoValidator
                        ),
                        coordinator: coordinator
                    )
                },
                signInViewControllerFactory: {
                    SignInViewController(
                        viewModel: SignInViewModel(
                            networkService: networkService
                        )
                    )
                },
                webViewControllerFactory: {
                    WebViewController(
                        viewModel: WebViewModel()
                    )
                }
            )
        }
    }
}

typealias LogInCoordinatorFactory = (UINavigationController) -> Coordinator

typealias LogInViewControllerFactory = (LogInCoordinatorType) -> LogInViewController
typealias SignInViewControllerFactory = () -> SignInViewController
typealias SignUpViewControllerFactory = (TermsAndPoliciesCoordinatorType) -> SignUpViewController

typealias WebViewControllerFactory = () -> WebViewController
