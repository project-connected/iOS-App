//
//  AppDelegateTests.swift
//  Connected-iOSTests
//
//  Created by Jaedoo Ko on 2020/07/18.
//  Copyright © 2020 connected. All rights reserved.
//

import XCTest
@testable import Connected_iOS
import Pure
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

class AppDelegateTests: XCTestCase {

    func testInjectRootViewControllerDependencies() {
        let appDelegate = AppDelegate(
            viewModel: AppDelegateViewModel(),
            analyticsService: MockAnalyticsService.self,
            networkService: StubNetworkService(),
            rootViewController: ViewController()
        )

        _ = appDelegate.application(.shared, didFinishLaunchingWithOptions: nil)

        expect(MockAnalyticsService.count).to(equal(1))
    }

    func testUseTestAppDelegate() {
        expect(UIApplication.shared.delegate).to(beAKindOf(TestAppDelegate.self))
    }

}
