//
//  SignUpViewModelTests.swift
//  Connected-iOSTests
//
//  Created by Jaedoo Ko on 2020/08/02.
//  Copyright © 2020 connected. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import Nimble
@testable import Connected_iOS

class SignUpViewModelTests: XCTestCase {

    var viewModel: SignUpViewModelType!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!

    override func setUp() {
        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    override func tearDown() {
        viewModel = nil
        disposeBag = nil
        scheduler = nil
    }

    func test_deinited() {
        viewModel = SignUpViewModel(
            networkService: StubNetworkService(),
            userInfoValidator: StubUserInfoValidator()
        )

        scheduler
            .createHotObservable([
                .next(0, Void()),
                .next(200, Void()),
                .next(500, Void()),
                .next(700, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.termsAndPoliciesClicked()
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(250, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.deinited()
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(Bool.self)

        viewModel.outputs.presentTermsAndPolicies()
            .map { true }
            .emit(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(0, true),
            .next(200, true)
        ]))
    }

    func test_isSignUpButtonEnabled() {
        let validator = StubUserInfoValidator(
            validateEmailBody: { !$0.isEmpty },
            validatePasswordBody: { !$0.isEmpty },
            validateNicknameBody: { !$0.isEmpty }
        )

        viewModel = SignUpViewModel(
            networkService: StubNetworkService(),
            userInfoValidator: validator
        )

        scheduler
            .createHotObservable([
                .next(0, "a"),
                .next(200, "a"),
                .next(400, ""),
                .next(600, "a")
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.emailText(email: $0)
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(0, ""),
                .next(250, "a"),
                .next(550, "aa"),
                .next(750, "")
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.passwordText(password: $0)
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(0, ""),
                .next(210, "a"),
                .next(410, "aa"),
                .next(610, ""),
                .next(710, "a")
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.nicknameText(nickname: $0)
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(0, false),
                .next(220, true),
                .next(420, false),
                .next(620, true)
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.termsAndPoliciesAgree($0)
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(Bool.self)

        viewModel.outputs.isSignUpButtonEnabled()
            .drive(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(0, false),
            .next(0, false),
            .next(200, false),
            .next(210, false),
            .next(220, false),
            .next(250, true),
            .next(400, false),
            .next(410, false),
            .next(420, false),
            .next(550, false),
            .next(600, false),
            .next(610, false),
            .next(620, false),
            .next(710, true),
            .next(750, false)
        ]))
    }

    func test_signIn() {
        let user = User(id: 0, authToken: "authToken")
        viewModel = SignUpViewModel(
            networkService: StubNetworkService(signUpResult: .success(user)),
            userInfoValidator: StubUserInfoValidator(
                validateEmailBody: { _ in true },
                validatePasswordBody: { _ in true },
                validateNicknameBody: { _ in true }
            )
        )

        scheduler
            .createHotObservable([
                .next(0, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.emailText(email: "")
                self?.viewModel.inputs.passwordText(password: "")
                self?.viewModel.inputs.nicknameText(nickname: "")
                self?.viewModel.inputs.termsAndPoliciesAgree(true)
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(0, Void()),
                .next(200, Void()),
                .next(500, Void()),
                .next(700, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.emailText(email: "")
                self?.viewModel.inputs.passwordText(password: "")
                self?.viewModel.inputs.nicknameText(nickname: "")
                self?.viewModel.inputs.termsAndPoliciesAgree(true)
                self?.viewModel.inputs.signUpButtonClicked()
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(User.self)

        viewModel.outputs.signIn()
            .emit(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(0, user),
            .next(200, user),
            .next(500, user),
            .next(700, user)
        ]))
    }

    func test_showSignUpErrorMsg() {
        viewModel = SignUpViewModel(
            networkService: StubNetworkService(signUpResult: .failure(.just)),
            userInfoValidator: StubUserInfoValidator(
                validateEmailBody: { _ in true },
                validatePasswordBody: { _ in true },
                validateNicknameBody: { _ in true }
            )
        )

        scheduler
            .createHotObservable([
                .next(0, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.emailText(email: "")
                self?.viewModel.inputs.passwordText(password: "")
                self?.viewModel.inputs.nicknameText(nickname: "")
                self?.viewModel.inputs.termsAndPoliciesAgree(true)
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(0, Void()),
                .next(200, Void()),
                .next(500, Void()),
                .next(700, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.emailText(email: "")
                self?.viewModel.inputs.passwordText(password: "")
                self?.viewModel.inputs.nicknameText(nickname: "")
                self?.viewModel.inputs.termsAndPoliciesAgree(true)
                self?.viewModel.inputs.signUpButtonClicked()
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(String.self)

        viewModel.outputs.showSignUpErrorMsg()
            .emit(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(0, NetworkError.just.localizedDescription),
            .next(200, NetworkError.just.localizedDescription),
            .next(500, NetworkError.just.localizedDescription),
            .next(700, NetworkError.just.localizedDescription)
        ]))
    }

    func test_presentTermsAndPolicies() {
        viewModel = SignUpViewModel(
            networkService: StubNetworkService(),
            userInfoValidator: StubUserInfoValidator()
        )

        scheduler
            .createHotObservable([
                .next(0, Void()),
                .next(200, Void()),
                .next(500, Void()),
                .next(700, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.termsAndPoliciesClicked()
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(Bool.self)

        viewModel.outputs.presentTermsAndPolicies()
            .map { true }
            .emit(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(0, true),
            .next(200, true),
            .next(500, true),
            .next(700, true)
        ]))
    }

}
