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

    private var disposeBag = DisposeBag()
    private let viewModel: RootViewModelType
    private weak var coordinator: AppCoordinatorType?

    // MARK: - Lifecycle

    init(
        viewModel: RootViewModelType,
        coordinator: AppCoordinatorType
    ) {
        self.viewModel = viewModel
        self.coordinator = coordinator

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpLayout()
        bindStyles()
        bindViewModel()

        viewModel.inputs.viewDidLoad()
    }

    // MARK: - Functions

    private func setUpLayout() {

    }

    private func bindViewModel() {

        self.rx.deallocated
            .bind(onNext: { [weak self] in
                self?.viewModel.inputs.deinited()
            })
            .disposed(by: disposeBag)

        self.rx.didSelect
            .map { [weak self] _ in self?.selectedIndex }
            .compactMap { $0 }
            .bind(onNext: viewModel.inputs.didSelect(index:))
            .disposed(by: disposeBag)

        viewModel.outputs.setViewControllers()
            .map({ dataList in
                return dataList.map { ($0, UINavigationController()) }
            })
            .map(viewControllers(list:))
            .drive(onNext: { [weak self] in
                self?.setViewControllers($0, animated: false)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.tabBarItems()
            .drive(onNext: setTabBarItemStyles(items:))
            .disposed(by: disposeBag)
    }

    private func bindStyles() {

    }

    private func viewControllers(list: [(RootViewControllerData, UINavigationController)]) -> [UIViewController] {
        return list.map { data, controller in
            switch data {
            case .home:
                coordinator?.navigateToHome(navigationController: controller)
            case .myProject:
                coordinator?.navigateToMyProject(navigationController: controller)
            case .chat:
                coordinator?.navigateToChat(navigationController: controller)
            case .profile(let isLoggedIn):
                isLoggedIn
                    ? coordinator?.navigateToProfile(navigationController: controller)
                    : coordinator?.navigateToLogIn(navigationController: controller)
            }
            return controller
        }
    }

    private func setTabBarItemStyles(items: [TabBarItem]) {
        items.forEach { item in
            switch item {
            case .home(let index):
                tabBarItem(at: index)?.image = #imageLiteral(resourceName: "outline_home_black_36pt").withRenderingMode(.alwaysTemplate)
            case .myProject(let index):
                tabBarItem(at: index)?.image = #imageLiteral(resourceName: "round_menu_book_black_36pt").withRenderingMode(.alwaysTemplate)
            case .chat(let index):
                tabBarItem(at: index)?.image = #imageLiteral(resourceName: "baseline_forum_black_36pt").withRenderingMode(.alwaysTemplate)
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
