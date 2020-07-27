//
//  MyProjectPageDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class MyProjectPageDataSource: NSObject, UIPageViewControllerDataSource {

    // MARK: - UI Properties

    // MARK: - Properties

    private let configurator: Int

    // MARK: - Lifecycle

    override init() {
        configurator = 1
    }

    required init(dependency: Dependency, payload: ()) {
        fatalError("Fatal Error CategoryDataSource initializer")
    }

    // MARK: - Functions

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        return ViewController()
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        return ViewController2()
    }

}
