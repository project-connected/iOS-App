//
//  UIViewController+RxTests.swift
//  Connected-iOSTests
//
//  Created by Jaedoo Ko on 2020/08/03.
//  Copyright © 2020 connected. All rights reserved.
//

import XCTest
import RxTest
import RxSwift
import Nimble
@testable import Connected_iOS

fileprivate enum State {
    case viewWillAppear
    case viewDidAppear
    case viewWillDisappear
    case viewDidDisappear
}

class UIViewController_RxTests: XCTestCase {

    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()

        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    func test_viewDidLoad() {
        let viewController = UIViewController()

        scheduler
            .createHotObservable([
                .next(100, State.viewWillAppear),
                .next(200, State.viewDidAppear),
                .next(300, State.viewWillDisappear),
                .next(400, State.viewDidDisappear)
            ])
            .bind(onNext: {
                switch $0 {
                case .viewWillAppear:
                    viewController.viewWillAppear(true)
                case .viewDidAppear:
                    viewController.viewDidAppear(true)
                case .viewWillDisappear:
                    viewController.viewWillDisappear(true)
                case .viewDidDisappear:
                    viewController.viewDidDisappear(true)
                }
            })
            .disposed(by: disposeBag)

        let observer = scheduler.createObserver(State.self)

        viewController.rx.viewWillAppear
            .map { State.viewWillAppear }
            .bind(to: observer)
            .disposed(by: disposeBag)

        viewController.rx.viewDidAppear
            .map { State.viewDidAppear }
            .bind(to: observer)
            .disposed(by: disposeBag)

        viewController.rx.viewWillDisappear
            .map { State.viewWillDisappear }
            .bind(to: observer)
            .disposed(by: disposeBag)

        viewController.rx.viewDidDisappear
            .map { State.viewDidDisappear }
            .bind(to: observer)
            .disposed(by: disposeBag)

        scheduler.start()

        expect(observer.events).to(equal([
            .next(100, .viewWillAppear),
            .next(200, .viewDidAppear),
            .next(300, .viewWillDisappear),
            .next(400, .viewDidDisappear)
        ]))
    }

}
