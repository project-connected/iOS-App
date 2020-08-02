//
//  SignInViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol SignInViewModelInputs {
    func emailText(email: String)
    func passwordText(password: String)
    func signInButtonClicked()
    func deinited()
}

protocol SignInViewModelOutputs {
    func isSignInButtonEnabled() -> Driver<Bool>
    func showSignInErrorMsg() -> Signal<String>
    func signIn() -> Signal<User>
}

protocol SignInViewModelType {
    var inputs: SignInViewModelInputs { get }
    var outputs: SignInViewModelOutputs { get }
}

final class SignInViewModel: SignInViewModelType, SignInViewModelInputs, SignInViewModelOutputs {

    // MARK: - Properties

    var inputs: SignInViewModelInputs { return self }
    var outputs: SignInViewModelOutputs { return self }
    private var disposeBag = DisposeBag()
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

    private let signInButtonClickedProperty: PublishRelay<Void> = PublishRelay()
    func signInButtonClicked() {
        signInButtonClickedProperty.accept(Void())
    }

    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }

    // MARK: - Outputs

    private let isSignInButtonEnabledProperty: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    func isSignInButtonEnabled() -> Driver<Bool> {
        isSignInButtonEnabledProperty.asDriver()
    }

    private let showSignInErrorMsgProperty: PublishRelay<String> = PublishRelay()
    func showSignInErrorMsg() -> Signal<String> {
        showSignInErrorMsgProperty.asSignal()
    }

    private let signInProperty: PublishRelay<User> = PublishRelay()
    func signIn() -> Signal<User> {
        signInProperty.asSignal()
    }

    // MARK: - Lifecycle

    init(networkService: NetworkServiceType) {
        self.networkService = networkService

        let isEmailFilled = emailTextProperty
            .map { !$0.isEmpty }

        let isPasswordFilled = passwordTextProperty
            .map { !$0.isEmpty }

        Observable.combineLatest(isEmailFilled, isPasswordFilled)
            .map { $0.0 && $0.1 }
            .bind(to: isSignInButtonEnabledProperty)
            .disposed(by: disposeBag)

        let signInData = Observable.combineLatest(
            emailTextProperty,
            passwordTextProperty
        )

        signInButtonClickedProperty
            .withLatestFrom(signInData)
            .flatMap({ (email, password) in
                return self.networkService.signIn(email: email, password: password)
            })
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .bind(onNext: { result in
                switch result {
                case .success(let user):
                    self.signInProperty.accept(user)
                case .failure(let error):
                    self.showSignInErrorMsgProperty.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)

        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
