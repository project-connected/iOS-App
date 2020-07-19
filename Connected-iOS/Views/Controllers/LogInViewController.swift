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
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        viewModel: LogInViewModelType,
        signUpViewControllerFactory: SignUpViewController.Factory
    ) {
        self.viewModel = viewModel
        self.signUpViewControllerFactory = signUpViewControllerFactory

        super.init(nibName: nil, bundle: nil)

        self.setUpLayout()
        self.bindStyle()
        self.bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func bindViewModel() {

        self.signUpBtn.rx.tap.asDriver()
            .drive(onNext: self.viewModel.inputs.signUpClicked)
            .disposed(by: self.disposeBag)

        self.logInBtn.rx.tap.asDriver()
            .drive(onNext: self.viewModel.inputs.logInClicked)
            .disposed(by: self.disposeBag)

        self.viewModel.outputs.displayViewController()
            .map(self.viewController(from:))
            .emit(onNext: { self.navigationController?.pushViewController($0, animated: true) })
            .disposed(by: self.disposeBag)
    }

    private func bindStyle() {
        self.view.backgroundColor = .white

        logo.text = "Connected"

        logInBtn.setTitle("LogIn", for: .normal)
        logInBtn.setTitleColor(.black, for: .normal)
        logInBtn.layer.borderColor = UIColor.black.cgColor
        logInBtn.layer.borderWidth = 1

        signUpBtn.setTitle("SignUp", for: .normal)
        signUpBtn.setTitleColor(.black, for: .normal)
        signUpBtn.layer.borderColor = UIColor.black.cgColor
        signUpBtn.layer.borderWidth = 1
    }

    private func setUpLayout() {
        [logo, signUpBtn, logInBtn]
            .addSubviews(parent: self.view)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            logo.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            logo.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100),

            logInBtn.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            logInBtn.topAnchor.constraint(equalTo: self.logo.bottomAnchor, constant: 30),

            signUpBtn.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor),
            signUpBtn.topAnchor.constraint(equalTo: self.logInBtn.bottomAnchor, constant: 30)
        ])
    }

    private func viewController(from data: LogInViewControllerData) -> UIViewController {
        switch data {
        case .signUp:
            return self.signUpViewControllerFactory.create()
        case .logIn:
            return ViewController()
        }
    }
}
