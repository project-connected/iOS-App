//
//  SignUpViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/19.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol SignUpViewModelInputs {
    func emailText(email: String)
    func passwordText(password: String)
    func nicknameText(nickname: String)
    func termsAndPoliciesAgree(_ agree: Bool)
    func signUpButtonClicked()
    func termsAndPoliciesClicked()
    func deinited()
}

protocol SignUpViewModelOutputs {
    func isSignUpButtonEnabled() -> Driver<Bool>
    func showSignUpErrorMsg() -> Signal<String>
    func signIn() -> Signal<User>
    func presentTermsAndPolicies() -> Signal<Void>
}

protocol SignUpViewModelType {
    var inputs: SignUpViewModelInputs { get }
    var outputs: SignUpViewModelOutputs { get }
}

final class SignUpViewModel: SignUpViewModelType, SignUpViewModelInputs, SignUpViewModelOutputs {

    // MARK: - Properties

    var inputs: SignUpViewModelInputs { return self }
    var outputs: SignUpViewModelOutputs { return self }
    private var disposeBag = DisposeBag()
    private let networkService: NetworkServiceType
    private let validator: UserInfoValidatorType

    // MARK: - Inputs

    private let emailTextProperty: PublishRelay<String> = PublishRelay()
    func emailText(email: String) {
        emailTextProperty.accept(email)
    }

    private let passwordTextProperty: PublishRelay<String> = PublishRelay()
    func passwordText(password: String) {
        passwordTextProperty.accept(password)
    }

    private let nicknameTextProperty: PublishRelay<String> = PublishRelay()
    func nicknameText(nickname: String) {
        nicknameTextProperty.accept(nickname)
    }

    private let signUpButtonClickedProperty: PublishRelay<Void> = PublishRelay()
    func signUpButtonClicked() {
        signUpButtonClickedProperty.accept(Void())
    }

    private let termsAndPoliciesAgreeProperty: PublishRelay<Bool> = PublishRelay()
    func termsAndPoliciesAgree(_ agree: Bool) {
        termsAndPoliciesAgreeProperty.accept(agree)
    }

    private let termsAndPoliciesClickedProperty: PublishRelay<Void> = PublishRelay()
    func termsAndPoliciesClicked() {
        termsAndPoliciesClickedProperty.accept(Void())
    }

    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }

    // MARK: - Outputs

    private let isSignUpButtonEnabledProperty: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    func isSignUpButtonEnabled() -> Driver<Bool> {
        isSignUpButtonEnabledProperty.asDriver()
    }

    private let showSignUpErrorMsgProperty: PublishRelay<String> = PublishRelay()
    func showSignUpErrorMsg() -> Signal<String> {
        showSignUpErrorMsgProperty.asSignal()
    }

    private let signInProperty: PublishRelay<User> = PublishRelay()
    func signIn() -> Signal<User> {
        signInProperty.asSignal()
    }

    private let presentTermsAndPoliciesProperty: PublishRelay<Void> = PublishRelay()
    func presentTermsAndPolicies() -> Signal<Void> {
        return presentTermsAndPoliciesProperty.asSignal()
    }

    // MARK: - Lifecycle

    init(
        networkService: NetworkServiceType,
        userInfoValidator: UserInfoValidatorType
    ) {
        self.networkService = networkService
        self.validator = userInfoValidator

        let isEmailValid = emailTextProperty
            .map(validator.validateEmail(email:))

        let isPasswordValid = passwordTextProperty
            .map(validator.validatePassword(password:))

        let isNicknameValid = nicknameTextProperty
            .map(validator.validateNickname(nickname:))

        let validatedInputs = Observable.combineLatest(
            isEmailValid,
            isPasswordValid,
            isNicknameValid,
            termsAndPoliciesAgreeProperty
        )

        validatedInputs
            .map { $0.0 && $0.1 && $0.2 && $0.3 }
            .bind(to: isSignUpButtonEnabledProperty)
            .disposed(by: disposeBag)

        let signUpData = Observable.combineLatest(
            emailTextProperty,
            passwordTextProperty,
            nicknameTextProperty
        )

        signUpButtonClickedProperty
            .withLatestFrom(signUpData)
            .flatMap({ (email, password, nickname) in
                self.networkService.signUp(email: email, password: password, nickname: nickname)
            })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .bind(onNext: { result in
                switch result {
                case .success(let user):
                    self.signInProperty.accept(user)
                case .failure(let error):
                    self.showSignUpErrorMsgProperty.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)

        termsAndPoliciesClickedProperty
            .bind(to: presentTermsAndPoliciesProperty)
            .disposed(by: disposeBag)

        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)
    }

    // MARK: - Functions

}
