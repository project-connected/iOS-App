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
    private let nicknameTextField: UITextField = UITextField()
    private let signInButton: UIButton = UIButton(type: .system)

    // MARK: - Properties

    private let viewModel: SignInViewModelType
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(viewModel: SignInViewModelType) {
        self.viewModel = viewModel

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

    private func bindStyle() {
        view.backgroundColor = .white

        emailTextField.backgroundColor = .white
        passwordTextField.backgroundColor = .white
        nicknameTextField.backgroundColor = .white
        _ = baseBorderStyle(view: emailTextField)
        _ = baseBorderStyle(view: passwordTextField)
        _ = baseBorderStyle(view: nicknameTextField)

        signInButton.setTitle("Sign In", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.setBackgroundColorWithState(.systemBlue, for: .normal)
        signInButton.setBackgroundColorWithState(.systemGray, for: .disabled)

        formStackView.axis = .vertical
        formStackView.distribution = .fillEqually
        formStackView.alignment = .center
        formStackView.spacing = 10
    }

    private func setUpLayout() {
        [emailTextField, passwordTextField, signInButton]
            .addArrangedSubviews(parent: formStackView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        [formStackView, contentView, scrollView]
            .setTranslatesAutoresizingMaskIntoConstraints()

        contentView.addSubview(formStackView)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: formStackView.leadingAnchor, constant: 10),
            emailTextField.trailingAnchor.constraint(equalTo: formStackView.trailingAnchor, constant: -10),
            emailTextField.heightAnchor.constraint(equalToConstant: 100),

            passwordTextField.leadingAnchor.constraint(equalTo: formStackView.leadingAnchor, constant: 10),
            passwordTextField.trailingAnchor.constraint(equalTo: formStackView.trailingAnchor, constant: -10),
            passwordTextField.heightAnchor.constraint(equalToConstant: 100),

            signInButton.leadingAnchor.constraint(equalTo: formStackView.leadingAnchor, constant: 10),
            signInButton.trailingAnchor.constraint(equalTo: formStackView.trailingAnchor, constant: -10),
            signInButton.heightAnchor.constraint(equalToConstant: 100),

            formStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            formStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            formStackView.widthAnchor.constraint(equalTo: contentView.widthAnchor),

            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, constant: 500),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor),

            scrollView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            scrollView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            scrollView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor)
        ])
    }
}
