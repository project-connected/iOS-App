//
//  AppDelegateTests.swift
//  Connected-iOSTests
//
//  Created by Jaedoo Ko on 2020/07/18.
//  Copyright © 2020 connected. All rights reserved.
//

import XCTest
@testable import Connected_iOS
import Nimble

class TestAppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow? = UIWindow()
}

class MockAnalyticsService: AnalyticsServiceType {
    static var count: Int = 0
    static func configure() {
        count += 1
    }
}

class StubAppCoordinator: AppCoordinatorType {
    func clearChildren() { }
    func navigateToHome(navigationController: UINavigationController) { }
    func navigateToMyProject(navigationController: UINavigationController) { }
    func navigateToChat(navigationController: UINavigationController) { }
    func navigateToLogIn(navigationController: UINavigationController) { }
    func navigateToProfile(navigationController: UINavigationController) { }
    func start() { }
}

class AppDelegateTests: XCTestCase {

    func testInjectRootViewControllerDependencies() {
        let appDelegate = AppDelegate(
            viewModel: AppDelegateViewModel(),
            analyticsService: MockAnalyticsService.self,
            appCoordinatorFactory: { window in StubAppCoordinator() }
        )

        _ = appDelegate.application(.shared, didFinishLaunchingWithOptions: nil)

        expect(MockAnalyticsService.count).to(equal(1))
    }

    func testUseTestAppDelegate() {
        expect(UIApplication.shared.delegate).to(beAKindOf(TestAppDelegate.self))
    }

}
