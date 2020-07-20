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
}

protocol SignUpViewModelOutputs {
    func isSignUpButtonEnabled() -> Driver<Bool>
}

protocol SignUpViewModelType {
    var inputs: SignUpViewModelInputs { get }
    var outputs: SignUpViewModelOutputs { get }
}

final class SignUpViewModel: SignUpViewModelType, SignUpViewModelInputs, SignUpViewModelOutputs {

    // MARK: - Properties

    var inputs: SignUpViewModelInputs { return self }
    var outputs: SignUpViewModelOutputs { return self }
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceType

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

    // MARK: - Outputs

    private let isSignUpButtonEnabledProperty: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    func isSignUpButtonEnabled() -> Driver<Bool> {
        isSignUpButtonEnabledProperty.asDriver()
    }

    // MARK: - Lifecycle

    init(networkService: NetworkServiceType) {
        self.networkService = networkService

        let isEmailValid = emailTextProperty
            .map(validateEmail(email:))

        let isPasswordValid = passwordTextProperty
            .map(validatePassword(password:))

        let isNicknameValid = nicknameTextProperty
            .map(validateNickname(nickname:))

        Observable.combineLatest(isEmailValid, isPasswordValid, isNicknameValid)
            .map { $0.0 && $0.1 && $0.2 }
            .bind(to: isSignUpButtonEnabledProperty)
            .disposed(by: disposeBag)
    }

    // MARK: - Functions

    private func validateEmail(email: String) -> Bool {
        return false
    }

    private func validatePassword(password: String) -> Bool {
        return false
    }

    private func validateNickname(nickname: String) -> Bool {
        return false
    }
}
