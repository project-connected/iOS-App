//
//  ProjectDetailViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/23.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class ProjectDetailViewController: UIViewController {

    // MARK: - UI Properties

    // MARK: - Properties

    private let viewModel: ProjectDetailViewModelType
    private let disposeBag = DisposeBag()

    // MARK: - Lifecycle

    init(
        viewModel: ProjectDetailViewModelType,
        project: Project
    ) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

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
        view.backgroundColor = .white
    }

    private func setUpLayout() {

    }
}
