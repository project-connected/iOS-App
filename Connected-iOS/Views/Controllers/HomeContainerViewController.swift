//
//  HomeContainerViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/24.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

final class HomeContainerViewController: UIViewController {

    // MARK: - UI Properties

    // MARK: - Properties

    private var disposeBag = DisposeBag()
    private let viewModel: HomeContainerViewModelType
    private let homeViewController: UIViewController

    // MARK: - Lifecycle

    init(
        viewModel: HomeContainerViewModelType,
        homeViewController: UIViewController
    ) {
        self.viewModel = viewModel
        self.homeViewController = homeViewController

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpChildViewController()
        setUpLayout()
        bindStyles()
        bindViewModel()
    }

    // MARK: - Functions

    private func bindViewModel() {

        self.rx.deallocated
            .bind(onNext: {[weak self] in
                self?.viewModel.inputs.deinited()
            })
            .disposed(by: disposeBag)

    }

    private func bindStyles() {
    }

    private func setUpLayout() {
        view.addSubview(homeViewController.view)

        homeViewController.view.translatesAutoresizingMaskIntoConstraints = false
        constraintViewToCenterInParent(parent: view, child: homeViewController.view)

        NSLayoutConstraint.activate([
            homeViewController.view.widthAnchor.constraint(equalTo: view.widthAnchor),
            homeViewController.view.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }

    private func setUpChildViewController() {
        addChild(homeViewController)
        homeViewController.didMove(toParent: self)
    }
}
