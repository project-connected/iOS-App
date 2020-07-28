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
    private let pageViewController: UIPageViewController = UIPageViewController(
        transitionStyle: .scroll,
        navigationOrientation: .horizontal,
        options: nil
    )
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

        viewModel.inputs.viewDidLoad()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func bindViewModel() {

        viewModel.outputs.projectStates()
            .drive(onNext: { states in
                self.topTabBarViewController.setProjectStates(projectStates: states)
                self.dataSource.setProjectStates(projectStates: states)
            })
            .disposed(by: disposeBag)

        viewModel.outputs.pageToIndex()
            .emit(onNext: { (index, direction) in
                guard let viewController = self.dataSource.getViewController(at: index) else { return }
                self.pageViewController.setViewControllers(
                    [viewController],
                    direction: direction ? .forward : .reverse,
                    animated: true,
                    completion: nil
                )
            })
            .disposed(by: disposeBag)

        viewModel.outputs.selectTopTabBarItem()
            .emit(onNext: topTabBarViewController.selectItem(index:))
            .disposed(by: disposeBag)
    }

    private func bindStyles() {
        view.backgroundColor = .white
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
    }
}

extension MyProjectContainerViewController: TopTabBarDelegate {
    func topTabBarItemClicked(index: Int, item: ProjectState) {
        viewModel.inputs.topTabBarItemClicked(index: index, item: item)
    }
}

extension MyProjectContainerViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewController = pageViewController.viewControllers?.first else { return }
        guard let index = dataSource.indexAt(viewController) else { return }
        viewModel.inputs.pageTransition(to: index)
    }

}
