//
//  RootTabBarControllerTests.swift
//  Connected-iOSTests
//
//  Created by Jaedoo Ko on 2020/07/21.
//  Copyright © 2020 connected. All rights reserved.
//

import XCTest
import Nimble
@testable import Connected_iOS
import RxTest
import RxCocoa

class MockViewModel: RootViewModelType, RootViewModelInputs, RootViewModelOutputs {
    func shouldSelect(index: Int) {

    }

    func initialized() {

    }

    func setViewControllers() -> Driver<[RootViewControllerData]> {
        return Driver.just([])
    }

    func tabBarItems() -> Driver<[TabBarItem]> {
        return Driver.just([])
    }

    var inputs: RootViewModelInputs { self }
    var outputs: RootViewModelOutputs { self }

}

class RootTabBarControllerTests: XCTestCase {

    func testViewControllers() {
        _ = RootTabBarController(
            viewModel: MockViewModel(),
            logInViewControllerFactory: LogInViewController.Factory.stub()
        )

    }

}
