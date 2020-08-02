//
//  LogInViewModelTests.swift
//  Connected-iOSTests
//
//  Created by Jaedoo Ko on 2020/08/01.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import XCTest
import Nimble
import RxSwift
import RxTest
import RxBlocking
@testable import Connected_iOS

class LogInViewModelTests: XCTestCase {

    var viewModel: LogInViewModelType!
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        viewModel = LogInViewModel()
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        super.tearDown()

        viewModel = nil
        scheduler = nil
        disposeBag = nil
    }

    func test_pushViewController() {
        scheduler
            .createHotObservable([
                .next(0, Void()),
                .next(7, Void()),
                .next(909, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.signInClicked()
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(0, Void()),
                .next(300, Void()),
                .next(700, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.signUpClicked()
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(LogInViewControllerData.self)

        viewModel.outputs.pushViewController()
            .emit(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(0, LogInViewControllerData.signIn),
            .next(0, LogInViewControllerData.signUp),
            .next(7, LogInViewControllerData.signIn),
            .next(300, LogInViewControllerData.signUp),
            .next(700, LogInViewControllerData.signUp),
            .next(909, LogInViewControllerData.signIn)
        ]))
    }

    func test_deinited() {
        scheduler
            .createHotObservable([
                .next(500, Void())
            ])
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.deinited()
            })
            .disposed(by: disposeBag)

        scheduler
            .createHotObservable([
                .next(0, LogInViewControllerData.signIn),
                .next(250, LogInViewControllerData.signIn),
                .next(499, LogInViewControllerData.signIn),
                .next(500, LogInViewControllerData.signIn),
                .next(501, LogInViewControllerData.signIn),
                .next(700, LogInViewControllerData.signIn),

                .next(0, LogInViewControllerData.signUp),
                .next(250, LogInViewControllerData.signUp),
                .next(499, LogInViewControllerData.signUp),
                .next(500, LogInViewControllerData.signUp),
                .next(501, LogInViewControllerData.signUp),
                .next(700, LogInViewControllerData.signUp)
            ])
            .bind(onNext: { [weak self] in
                if $0 == .signIn {
                    self?.viewModel.inputs.signInClicked()
                } else {
                    self?.viewModel.inputs.signUpClicked()
                }
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(LogInViewControllerData.self)
        viewModel.outputs.pushViewController()
            .emit(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(0, LogInViewControllerData.signIn),
            .next(0, LogInViewControllerData.signUp),
            .next(250, LogInViewControllerData.signIn),
            .next(250, LogInViewControllerData.signUp),
            .next(499, LogInViewControllerData.signIn),
            .next(499, LogInViewControllerData.signUp)
        ]))
    }
}
