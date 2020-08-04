//
//  MyProjectPageDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class MyProjectPageDataSource: NSObject, UIPageViewControllerDataSource {

    // MARK: - Properties

    private var pages: [(ProjectState, UIViewController)] = []
    private let pageViewControllerFactory: MyProjectPageViewControllerFactory

    // MARK: - Lifecycle

    init(
        myProjectPageViewControllerFactory: @escaping MyProjectPageViewControllerFactory
    ) {
        self.pageViewControllerFactory = myProjectPageViewControllerFactory
    }

    // MARK: - Functions

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let beforeIndex = self.indexAt(viewController) else {
            fatalError("Couldn't find \(viewController) in \(self.pages)")
        }

        guard beforeIndex > 0 else {
            return nil
        }

        return pages[beforeIndex - 1].1
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let afterIndex = self.indexAt(viewController) else {
            fatalError("Couldn't find \(viewController) in \(self.pages)")
        }

        guard afterIndex + 1 < pages.count else {
            return nil
        }

        return pages[afterIndex + 1].1
    }

    final func indexAt(_ viewController: UIViewController) -> Int? {
        guard let index = pages.firstIndex(where: { $0.1 == viewController }) else {
            return nil
        }
        return index
    }

    final func getViewController(at index: Int) -> UIViewController? {
        guard index < pages.count else {
            return nil
        }
        return pages[index].1
    }

    final func setProjectStates(projectStates: [ProjectState]) {
        let pages = projectStates.map { ($0, pageViewControllerFactory()) }
        self.pages = pages
    }
}
