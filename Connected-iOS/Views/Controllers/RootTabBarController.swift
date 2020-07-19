//
//  RootTabBarController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/18.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class RootTabBarController: UITabBarController {

    // MARK: - Properties

    private let viewModel: RootViewModelType
    private let logInViewControllerFactory: LogInViewController.Factory
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        viewModel: RootViewModelType,
        logInViewControllerFactory: LogInViewController.Factory
    ) {
        self.viewModel = viewModel
        self.logInViewControllerFactory = logInViewControllerFactory

        super.init(nibName: nil, bundle: nil)

        self.delegate = self
        self.setUpLayout()
        self.bindStyle()
        self.bindViewModel()

        self.viewModel.inputs.initialized()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func setUpLayout() {

    }

    private func bindViewModel() {

        self.viewModel.outputs.setViewControllers()
            .map { $0.map(self.viewController(from:)) }
            .map { $0.map(UINavigationController.init(rootViewController:)) }
            .drive(onNext: { self.setViewControllers($0, animated: false) })
            .disposed(by: self.disposeBag)

        self.viewModel.outputs.tabBarItems()
            .drive(onNext: self.setTabBarItemStyles(items:))
            .disposed(by: self.disposeBag)
    }

    private func bindStyle() {

    }

    private func viewController(from data: RootViewControllerData) -> UIViewController {
        switch data {
        case .home:
            return ViewController()
        case .profile(let isLoggedIn):
            return isLoggedIn ? ViewController2() : self.logInViewControllerFactory.create()
        }
    }

    private func setTabBarItemStyles(items: [TabBarItem]) {
        items.forEach { item in
            switch item {
            case .home(let index):
                self.tabBarItem(at: index)?.image = #imageLiteral(resourceName: "outline_home_black_36pt").withRenderingMode(.alwaysTemplate)
            case .profile(let index):
                self.tabBarItem(at: index)?.image = #imageLiteral(resourceName: "baseline_person_black_36pt").withRenderingMode(.alwaysTemplate)
            }
        }
    }

    private func tabBarItem(at index: Int) -> UITabBarItem? {
        guard index < (self.tabBar.items?.count ?? 0) else {
                return nil
        }
        return self.tabBar.items?[index]
    }
}

// MARK: - UITabBarControllerDelegate

extension RootTabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        let index = tabBarController.viewControllers?.firstIndex(of: viewController) ?? 0
        self.viewModel.inputs.shouldSelect(index: index)
        return true
    }
}
