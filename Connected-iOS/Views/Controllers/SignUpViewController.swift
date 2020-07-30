//
//  SignUpViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/19.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class SignUpViewController: UIViewController {

    // MARK: - UI Properties
    private let scrollView: UIScrollView = UIScrollView()
    private let contentView: UIView = UIView()
    private let formStackView: UIStackView = UIStackView()
    private let emailTextField: UITextField = UITextField()
    private let passwordTextField: UITextField = UITextField()
    private let nicknameTextField: UITextField = UITextField()
    private let termsAndPoliciesButton: UIButton = UIButton()
    private let agreeSwitch: UISwitch = UISwitch()
    private let signUpButton: UIButton = UIButton(type: .system)

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: SignUpViewModelType
    private let webViewControllerFactory: WebViewController.Factory

    // MARK: - Lifecycle

    init(
        viewModel: SignUpViewModelType,
        webViewControllerFactory: WebViewController.Factory
    ) {
        self.viewModel = viewModel
        self.webViewControllerFactory = webViewControllerFactory

        super.init(nibName: nil, bundle: nil)

        setUpLayout()
        bindStyles()
        bindViewModel()
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

        nicknameTextField.rx.text
            .orEmpty
            .asDriver()
            .debounce(.milliseconds(500))
            .distinctUntilChanged()
            .drive(onNext: viewModel.inputs.nicknameText(nickname:))
            .disposed(by: disposeBag)

        signUpButton.rx.tap
            .asDriver()
            .throttle(.microseconds(500))
            .drive(onNext: { self.viewModel.inputs.signUpButtonClicked() })
            .disposed(by: disposeBag)

        agreeSwitch.rx.isOn
            .asDriver()
            .drive(onNext: self.viewModel.inputs.termsAndPoliciesAgree(_:))
            .disposed(by: disposeBag)

        termsAndPoliciesButton.rx.tap
            .asDriver()
            .drive(onNext: { self.viewModel.inputs.termsAndPoliciesClicked() })
            .disposed(by: disposeBag)

        viewModel.outputs.isSignUpButtonEnabled()
            .drive(signUpButton.rx.isEnabled)
            .disposed(by: disposeBag)

        viewModel.outputs.showSignUpErrorMsg()
            .emit(onNext: { self.showAlert(title: "회원가입 실패", msg: $0, style: .alert) })
            .disposed(by: disposeBag)

        // TODO: 회원가입 성공 시 로그인 시키기
        viewModel.outputs.signIn()
            .emit(onNext: { user in
                self.signUpButton.setTitle("sign in - \(user)", for: .normal)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.presentTermsAndPolicies()
            .emit(onNext: {
                let viewController = self.webViewControllerFactory.create()
                self.present(viewController, animated: true, completion: nil)
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
        passwordTextField.returnKeyType = .next
        _ = baseBorderStyle(view: passwordTextField)

        nicknameTextField.backgroundColor = .white
        nicknameTextField.placeholder = "Nickname"
        nicknameTextField.font = UIFont.systemFont(ofSize: 20)
        nicknameTextField.setHorizontalPadding(10)
        nicknameTextField.returnKeyType = .next
        _ = baseBorderStyle(view: nicknameTextField)

        signUpButton.setTitle("SIGN UP", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.setBackgroundColorWithState(.systemBlue, for: .normal)
        signUpButton.setBackgroundColorWithState(.systemGray, for: .disabled)
        signUpButton.layer.cornerRadius = 12
        signUpButton.clipsToBounds = true

        let text = "I agree to terms and policies"
        let termsAndPoliciesText = NSMutableAttributedString(string: text)
        termsAndPoliciesText.addAttribute(
            NSAttributedString.Key.foregroundColor,
            value: UIColor.systemBlue,
            range: (text as NSString).range(of: "terms and policies")
        )

        termsAndPoliciesButton.setAttributedTitle(termsAndPoliciesText, for: .normal)
        termsAndPoliciesButton.contentHorizontalAlignment = .trailing

        formStackView.axis = .vertical
        formStackView.distribution = .fill
        formStackView.alignment = .trailing
        formStackView.spacing = -1
    }

    private func setUpLayout() {
        [emailTextField, passwordTextField, nicknameTextField, termsAndPoliciesButton, agreeSwitch]
            .addArrangedSubviews(parent: formStackView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        [formStackView, signUpButton, contentView, scrollView]
            .setTranslatesAutoresizingMaskIntoConstraints()

        contentView.addSubview(formStackView)
        contentView.addSubview(signUpButton)
        scrollView.addSubview(contentView)
        view.addSubview(scrollView)

        NSLayoutConstraint.activate([
            emailTextField.leadingAnchor.constraint(equalTo: formStackView.leadingAnchor),
            emailTextField.trailingAnchor.constraint(equalTo: formStackView.trailingAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 60),

            passwordTextField.leadingAnchor.constraint(equalTo: formStackView.leadingAnchor),
            passwordTextField.trailingAnchor.constraint(equalTo: formStackView.trailingAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 60),

            nicknameTextField.leadingAnchor.constraint(equalTo: formStackView.leadingAnchor),
            nicknameTextField.trailingAnchor.constraint(equalTo: formStackView.trailingAnchor),
            nicknameTextField.heightAnchor.constraint(equalToConstant: 60),

            termsAndPoliciesButton.leadingAnchor.constraint(equalTo: formStackView.leadingAnchor),
            termsAndPoliciesButton.trailingAnchor.constraint(equalTo: formStackView.trailingAnchor),
            termsAndPoliciesButton.heightAnchor.constraint(equalToConstant: 60),

            formStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            formStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            formStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30),

            signUpButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 50),
            signUpButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -50),
            signUpButton.topAnchor.constraint(equalTo: formStackView.bottomAnchor, constant: 30),
            signUpButton.heightAnchor.constraint(equalToConstant: 60),

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
