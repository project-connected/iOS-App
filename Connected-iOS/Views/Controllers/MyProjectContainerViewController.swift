//
//  MyProjectContainerViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class MyProjectContainerViewController: UIViewController {

    // MARK: - UI Properties

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    private let viewModel: MyProjectContainerViewModelType
    private let topTabBarViewController: TopTabBarViewController
    private let pageViewController: UIPageViewController = UIPageViewController()
    private let dataSource: MyProjectPageDataSource

    // MARK: - Lifecycle

    init(
        viewModel: MyProjectContainerViewModelType,
        topTabBarViewController: TopTabBarViewController,
        pageDataSource: MyProjectPageDataSource
    ) {
        self.viewModel = viewModel
        self.topTabBarViewController = topTabBarViewController
        self.dataSource = pageDataSource

        super.init(nibName: nil, bundle: nil)

        setUpChildViewController()
        setUpLayout()
        bindStyles()
        bindViewModel()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func bindViewModel() {

    }

    private func bindStyles() {
        view.backgroundColor = .green
    }

    private func setUpLayout() {
        [topTabBarViewController.view, pageViewController.view]
            .compactMap { $0 }
            .addSubviews(parent: self.view)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            topTabBarViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topTabBarViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topTabBarViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topTabBarViewController.view.heightAnchor.constraint(equalToConstant: 60),

            pageViewController.view.topAnchor.constraint(equalTo: topTabBarViewController.view.bottomAnchor),
            pageViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            pageViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func setUpChildViewController() {
        topTabBarViewController.delegate = self
        addChild(topTabBarViewController)
        topTabBarViewController.didMove(toParent: self)

        pageViewController.delegate = self
        pageViewController.dataSource = dataSource
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)

        // FIXME: - 테스트용 페이지 뷰컨 설정
        pageViewController.setViewControllers([ViewController2()], direction: .forward, animated: true, completion: nil)
    }
}

extension MyProjectContainerViewController: TopTabBarDelegate {
    func topTabBarItemClicked(index: Int, item: TopTabBarItem) {
        viewModel.inputs.topTabBarItemClicked(item: item)
    }
}

extension MyProjectContainerViewController: UIPageViewControllerDelegate {

}
