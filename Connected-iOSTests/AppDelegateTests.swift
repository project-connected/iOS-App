//
//  AppDelegateTests.swift
//  Connected-iOSTests
//
//  Created by Jaedoo Ko on 2020/07/18.
//  Copyright © 2020 connected. All rights reserved.
//

import XCTest
@testable import Connected_iOS
@testable import Pure

class TestAppDelegate: NSObject, UIApplicationDelegate {
    var window: UIWindow?
}

class MockAnalyticsService: AnalyticsServiceType {
    static var count: Int = 0
    static func configure() {
        count += 1
    }
}

class AppDelegateTests: XCTestCase {

    func testInjectRootViewControllerDependencies() {

        let dependency = AppDependency(
            analyticsService: MockAnalyticsService.self,
            viewControllerFactory: ViewController.Factory(dependency: .init())
        )
        let appDelegate = AppDelegate(dependency: dependency)
        appDelegate.window = UIWindow()
        appDelegate.window?.rootViewController = ViewController()

        _ = appDelegate.application(.shared, didFinishLaunchingWithOptions: nil)

        XCTAssertEqual(MockAnalyticsService.count, 1)
    }

    func testUseTestAppDelegate() {
        XCTAssertTrue(UIApplication.shared.delegate is TestAppDelegate)
    }

}
