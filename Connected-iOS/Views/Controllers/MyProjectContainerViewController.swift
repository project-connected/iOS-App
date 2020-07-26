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

    // MARK: - Lifecycle

    init(viewModel: MyProjectContainerViewModelType) {
        self.viewModel = viewModel

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

    }

    private func setUpChildViewController() {

    }
}
