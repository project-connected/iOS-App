//
//  SignInViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignInViewController: UIViewController {

    // MARK: - UI Properties

    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let formStackView: UIStackView = UIStackView()
    private let emailTextField: UITextField = UITextField()
    private let passwordTextField: UITextField = UITextField()
    private let signInButton: UIButton = UIButton(type: .system)

    // MARK: - Properties

    private let viewModel: SignInViewModelType
    private var disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(viewModel: SignInViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        self.setUpLayout()
        self.bindStyles()
        self.bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        viewModel.inputs.deinited()
    }

    // MARK: - Functions

    private func bindViewModel() {
        emailTextField.rx.text
            .orEmpty
            .asDriver()
            .debounce(.milliseconds(500))
            .distinctUntilChanged()
            .drive(onNext: viewModel.inputs.emailText(email:))
            .disposed(by: disposeBag)

        passwordTextField.rx.text
            .orEmpty
            .asDriver()
            .debounce(.milliseconds(500))
            .distinctUntilChanged()
            .drive(onNext: viewModel.inputs.passwordText(password:))
            .disposed(by: disposeBag)

        signInButton.rx.tap
            .asDriver()
            .throttle(.microseconds(500))
            .drive(onNext: { self.viewModel.inputs.signInButtonClicked() })
            .disposed(by: disposeBag)

        viewModel.outputs.isSignInButtonEnabled()
            .drive(signInButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.outputs.showSignInErrorMsg()
            .emit(onNext: { self.showAlert(title: "로그인 실패", msg: $0, style: .alert) })
            .disposed(by: disposeBag)

        // TODO: 로그인 시키기
        viewModel.outputs.signIn()
            .emit(onNext: { user in
                self.signInButton.setTitle("sign in - \(user)", for: .normal)
            })
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        view.backgroundColor = .white

        emailTextField.backgroundColor = .white
        emailTextField.placeholder = "E-Mail"
        emailTextField.font = UIFont.systemFont(ofSize: 20)
        emailTextField.setHorizontalPadding(10)
        emailTextField.keyboardType = .emailAddress
        emailTextField.returnKeyType = .next
        _ = baseBorderStyle(view: emailTextField)

        passwordTextField.isSecureTextEntry = true
        passwordTextField.backgroundColor = .white
        passwordTextField.placeholder = "Password"
        passwordTextField.font = UIFont.systemFont(ofSize: 20)
        passwordTextField.setHorizontalPadding(10)
        passwordTextField.returnKeyType = .done
        _ = baseBorderStyle(view: passwordTextField)

        signInButton.setTitle("SIGN IN", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.setBackgroundColorWithState(.systemBlue, for: .normal)
        signInButton.setBackgroundColorWithState(.systemGray, for: .disabled)
        signInButton.layer.cornerRadius = 12
        signInButton.clipsToBounds = true

        formStackView.axis = .vertical
        formStackView.distribution = .fillEqually
        formStackView.alignment = .center
        formStackView.spacing = -1
    }

    private func setUpLayout() {
        [emailTextField, passwordTextField]
            .addArrangedSubviews(parent: formStackView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        [formStackView, signInButton, contentView, scrollView]
            .setTranslatesAutoresizingMaskIntoConstraints()

        contentView.addSubview(formStackView)
        contentView.addSubview(signInButton)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([

            emailTextField.leadingAnchor.constraint(equalTo: formStackView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: formStackView.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),

            passwordTextField.leadingAnchor.constraint(equalTo: formStackView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: formStackView.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),

            formStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            formStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            formStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),

            signInButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            signInButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            signInButton.topAnchor.constraint(equalTo: formStackView.bottomAnchor, constant: 10),
            signInButton.heightAnchor.constraint(equalToConstant: 60),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor),

            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
    }
}
