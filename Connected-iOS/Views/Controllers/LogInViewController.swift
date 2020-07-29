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

    private let logoImageView: UIImageView = UIImageView()
    private let signUpBtn: UIButton = UIButton()
    private let signInBtn: UIButton = UIButton()

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

        signInBtn.rx.tap.asDriver()
            .drive(onNext: viewModel.inputs.logInClicked)
            .disposed(by: disposeBag)

        viewModel.outputs.displayViewController()
            .map(viewController(from:))
            .emit(onNext: { self.navigationController?.pushViewController($0, animated: true) })
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        self.view.backgroundColor = .white

        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = #imageLiteral(resourceName: "Swift_logo_440px")

        signUpBtn.backgroundColor = .systemBlue
        signUpBtn.setTitle("SIGN UP", for: .normal)
        signUpBtn.setTitleColor(.white, for: .normal)
        signUpBtn.layer.cornerRadius = 12

        signInBtn.setTitle("SIGN IN", for: .normal)
        signInBtn.setTitleColor(.black, for: .normal)
        signInBtn.layer.borderColor = UIColor.black.cgColor
        signInBtn.layer.borderWidth = 1
        signInBtn.layer.cornerRadius = 12
    }

    private func setUpLayout() {
        [logoImageView, signUpBtn, signInBtn]
            .addSubviews(parent: self.view)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            logoImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            logoImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 90),

            signUpBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            signUpBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            signUpBtn.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 90),
            signUpBtn.heightAnchor.constraint(equalToConstant: 80),

            signInBtn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            signInBtn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            signInBtn.topAnchor.constraint(equalTo: signUpBtn.bottomAnchor, constant: 30),
            signInBtn.heightAnchor.constraint(equalToConstant: 80)

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
