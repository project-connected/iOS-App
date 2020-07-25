//
//  LogInViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/19.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift

final class LogInViewController: UIViewController {

    // MARK: - UI Properties

    private let logo: UILabel = UILabel()
    private let signUpBtn: UIButton = UIButton()
    private let logInBtn: UIButton = UIButton()

    // MARK: - Properties

    private let viewModel: LogInViewModelType
    private let signUpViewControllerFactory: SignUpViewController.Factory
    private let signInViewControllerFactory: SignInViewController.Factory
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        viewModel: LogInViewModelType,
        signUpViewControllerFactory: SignUpViewController.Factory,
        signInViewControllerFactory: SignInViewController.Factory
    ) {
        self.viewModel = viewModel
        self.signUpViewControllerFactory = signUpViewControllerFactory
        self.signInViewControllerFactory = signInViewControllerFactory

        super.init(nibName: nil, bundle: nil)

        setUpLayout()
        bindStyles()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Functions

    private func bindViewModel() {

        signUpBtn.rx.tap.asDriver()
            .drive(onNext: viewModel.inputs.signUpClicked)
            .disposed(by: disposeBag)

        logInBtn.rx.tap.asDriver()
            .drive(onNext: viewModel.inputs.logInClicked)
            .disposed(by: disposeBag)

        viewModel.outputs.displayViewController()
            .map(viewController(from:))
            .emit(onNext: { self.navigationController?.pushViewController($0, animated: true) })
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        self.view.backgroundColor = .white

        logo.text = "Connected"

        logInBtn.setTitle("Sign In", for: .normal)
        logInBtn.setTitleColor(.black, for: .normal)
        logInBtn.layer.borderColor = UIColor.black.cgColor
        logInBtn.layer.borderWidth = 1

        signUpBtn.setTitle("Sign Up", for: .normal)
        signUpBtn.setTitleColor(.black, for: .normal)
        signUpBtn.layer.borderColor = UIColor.black.cgColor
        signUpBtn.layer.borderWidth = 1
    }

    private func setUpLayout() {
        [logo, signUpBtn, logInBtn]
            .addSubviews(parent: self.view)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),

            logInBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            logInBtn.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 30),

            signUpBtn.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            signUpBtn.topAnchor.constraint(equalTo: logInBtn.bottomAnchor, constant: 30)
        ])
    }

    private func viewController(from data: LogInViewControllerData) -> UIViewController {
        switch data {
        case .signUp:
            return signUpViewControllerFactory.create()
        case .signIn:
            return signInViewControllerFactory.create()
        }
    }
}
