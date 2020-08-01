//
//  SignInViewModelTests.swift
//  Connected-iOSTests
//
//  Created by Jaedoo Ko on 2020/08/01.
//  Copyright © 2020 connected. All rights reserved.
//

import XCTest
import RxTest
import Nimble
import RxSwift
@testable import Connected_iOS

class SignInViewModelTests: XCTestCase {

    var viewModel: SignInViewModelType!
    var disposeBag: DisposeBag!
    var scheduler: TestScheduler!

    override func setUp() {
        super.setUp()

        disposeBag = DisposeBag()
        scheduler = TestScheduler(initialClock: 0)
    }

    func test_isSignInButtonEnabled() {
        viewModel = SignInViewModel(
            networkService: MockNetworkService()
        )

        scheduler
            .createHotObservable([
                .next(2, ""),
                .next(100, "a"),
                .next(200, "aa"),
                .next(300, "")
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.emailText(email: $0)
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(1, ""),
                .next(150, "a"),
                .next(250, "aa"),
                .next(350, ""),
                .next(450, "a")
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.passwordText(password: $0)
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(Bool.self)

        viewModel.outputs.isSignInButtonEnabled()
            .drive(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(0, false),
            .next(2, false),
            .next(100, false),
            .next(150, true),
            .next(200, true),
            .next(250, true),
            .next(300, false),
            .next(350, false),
            .next(450, false)
        ]))
    }

    func test_showSignInErrorMsg() {
        viewModel = SignInViewModel(
            networkService: MockNetworkService(
                signInResult: Result.failure(NetworkError.just)
            )
        )

        scheduler
            .createHotObservable([
                .next(50, "a"),
                .next(200, "aa"),
                .next(600, "")
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.emailText(email: $0)
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(150, "a"),
                .next(250, "aa"),
                .next(350, ""),
                .next(450, "a")
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.passwordText(password: $0)
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(0, Void()),
                .next(100, Void()),
                .next(200, Void()),
                .next(500, Void()),
                .next(700, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.signInButtonClicked()
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(String.self)

        viewModel.outputs.showSignInErrorMsg()
            .emit(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(200, NetworkError.just.localizedDescription),
            .next(500, NetworkError.just.localizedDescription),
            .next(700, NetworkError.just.localizedDescription)
        ]))
    }

    func test_signIn() {
        let user = User(id: 0, authToken: "authToken")
        viewModel = SignInViewModel(
            networkService: MockNetworkService(
                signInResult: Result.success(user)
            )
        )

        scheduler
            .createHotObservable([
                .next(50, "a"),
                .next(200, "aa"),
                .next(600, "")
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.emailText(email: $0)
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(150, "a"),
                .next(250, "aa"),
                .next(350, ""),
                .next(450, "a")
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.passwordText(password: $0)
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(0, Void()),
                .next(100, Void()),
                .next(200, Void()),
                .next(500, Void()),
                .next(700, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.signInButtonClicked()
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(User.self)

        viewModel.outputs.signIn()
            .emit(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(200, user),
            .next(500, user),
            .next(700, user)
        ]))
    }

    func test_deinited() {
        viewModel = SignInViewModel(
            networkService: MockNetworkService()
        )

        scheduler
            .createHotObservable([
                .next(255, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.deinited()
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(2, ""),
                .next(100, "a"),
                .next(200, "aa"),
                .next(300, "")
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.emailText(email: $0)
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(1, ""),
                .next(150, "a"),
                .next(250, "aa"),
                .next(350, ""),
                .next(450, "a")
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.passwordText(password: $0)
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(Bool.self)

        viewModel.outputs.isSignInButtonEnabled()
            .drive(observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(0, false),
            .next(2, false),
            .next(100, false),
            .next(150, true),
            .next(200, true),
            .next(250, true)
        ]))
    }
}
