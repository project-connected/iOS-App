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

    private let disposeBag = DisposeBag()
    private let viewModel: RootViewModelType
    private let homeContainerViewControllerFactory: HomeContainerViewController.Factory
    private let myProjectContainerViewControllerFactory: MyProjectContainerViewController.Factory
    private let logInViewControllerFactory: LogInViewController.Factory

    // MARK: - Lifecycle

    init(
        viewModel: RootViewModelType,
        homeContainerViewControllerFactory: HomeContainerViewController.Factory,
        myProjectContainerViewControllerFactory: MyProjectContainerViewController.Factory,
        logInViewControllerFactory: LogInViewController.Factory
    ) {
        self.viewModel = viewModel
        self.homeContainerViewControllerFactory = homeContainerViewControllerFactory
        self.myProjectContainerViewControllerFactory = myProjectContainerViewControllerFactory
        self.logInViewControllerFactory = logInViewControllerFactory

        super.init(nibName: nil, bundle: nil)

        self.delegate = self
        setUpLayout()
        bindStyles()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.inputs.viewDidLoad()
    }

    // MARK: - Functions

    private func setUpLayout() {

    }

    private func bindViewModel() {

        viewModel.outputs.setViewControllers()
            .map { $0.map(self.viewController(from:)) }
            .map { $0.map(UINavigationController.init(rootViewController:)) }
            .drive(onNext: { self.setViewControllers($0, animated: false) })
            .disposed(by: disposeBag)

        viewModel.outputs.tabBarItems()
            .drive(onNext: setTabBarItemStyles(items:))
            .disposed(by: disposeBag)
    }

    private func bindStyles() {

    }

    private func viewController(from data: RootViewControllerData) -> UIViewController {
        switch data {
        case .home:
            return homeContainerViewControllerFactory.create()
        case .myProject:
            return myProjectContainerViewControllerFactory.create()
        case .profile(let isLoggedIn):
            return isLoggedIn ? ViewController2() : logInViewControllerFactory.create()
        }
    }

    private func setTabBarItemStyles(items: [TabBarItem]) {
        items.forEach { item in
            switch item {
            case .home(let index):
                tabBarItem(at: index)?.image = #imageLiteral(resourceName: "outline_home_black_36pt").withRenderingMode(.alwaysTemplate)
            case .myProject(let index):
                tabBarItem(at: index)?.image = #imageLiteral(resourceName: "round_menu_book_black_36pt").withRenderingMode(.alwaysTemplate)
            case .profile(let index):
                tabBarItem(at: index)?.image = #imageLiteral(resourceName: "baseline_person_black_36pt").withRenderingMode(.alwaysTemplate)
            }
        }
    }

    private func tabBarItem(at index: Int) -> UITabBarItem? {
        guard index < (tabBar.items?.count ?? 0) else {
                return nil
        }
        return tabBar.items?[index]
    }
}

// MARK: - UITabBarControllerDelegate

extension RootTabBarController: UITabBarControllerDelegate {
    func tabBarController(
        _ tabBarController: UITabBarController,
        shouldSelect viewController: UIViewController
    ) -> Bool {
        let index = tabBarController.viewControllers?.firstIndex(of: viewController) ?? 0
        viewModel.inputs.shouldSelect(index: index)
        return true
    }
}
