//
//  SignUpViewController.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/19.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

final class SignUpViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: SignUpViewModelType

    // MARK: - Lifecycle

    init(viewModel: SignUpViewModelType) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)

        self.view.backgroundColor = .cyan
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
