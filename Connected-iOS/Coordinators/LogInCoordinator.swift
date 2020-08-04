//
//  LogInCoordinator.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/04.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

protocol LogInCoordinatorType: class {
    func pushToSignUp()
    func pushToSignIn()
}

protocol TermsAndPoliciesCoordinatorType: class {
    func presentTermsAndPolicies()
}

class LogInCoordinator: Coordinator {

    // MARK: - Properties

    private let navigationController: UINavigationController
    private let logInViewControllerFactory: LogInViewControllerFactory
    private let signUpViewControllerFactory: SignUpViewControllerFactory
    private let signInViewControllerFactory: SignInViewControllerFactory
    private let webViewControllerFactory: WebViewControllerFactory

    // MARK: - Lifecycle

    init(
        navigationController: UINavigationController,
        logInViewControllerFactory: @escaping LogInViewControllerFactory,
        signUpViewControllerFactory: @escaping SignUpViewControllerFactory,
        signInViewControllerFactory: @escaping SignInViewControllerFactory,
        webViewControllerFactory: @escaping WebViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.logInViewControllerFactory = logInViewControllerFactory
        self.signUpViewControllerFactory = signUpViewControllerFactory
        self.signInViewControllerFactory = signInViewControllerFactory
        self.webViewControllerFactory = webViewControllerFactory
    }

    // MARK: - Functions

    func start() {
        let viewController = logInViewControllerFactory(self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension LogInCoordinator: LogInCoordinatorType {
    func pushToSignUp() {
        let viewController = signUpViewControllerFactory(self)
        navigationController.pushViewController(viewController, animated: true)
    }

    func pushToSignIn() {
        let viewController = signInViewControllerFactory()
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension LogInCoordinator: TermsAndPoliciesCoordinatorType {
    func presentTermsAndPolicies() {
        let viewController = webViewControllerFactory()
        navigationController.topViewController?.present(viewController, animated: true, completion: nil)
    }
}
