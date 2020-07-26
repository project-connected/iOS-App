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

    // MARK: - Lifecycle

    init(
        viewModel: MyProjectContainerViewModelType,
        topTabBarViewController: TopTabBarViewController
    ) {
        self.viewModel = viewModel
        self.topTabBarViewController = topTabBarViewController

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
        [topTabBarViewController.view]
            .compactMap { $0 }
            .addSubviews(parent: self.view)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            topTabBarViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            topTabBarViewController.view.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            topTabBarViewController.view.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            topTabBarViewController.view.heightAnchor.constraint(equalToConstant: 100)
        ])
    }

    private func setUpChildViewController() {
        topTabBarViewController.delegate = self
        addChild(topTabBarViewController)
        topTabBarViewController.didMove(toParent: self)
    }
}

extension MyProjectContainerViewController: TopTabBarDelegate {
    func topTabBarItemClicked(item: TopTabBarItem) {
        viewModel.inputs.topTabBarItemClicked(item: item)
    }
}
