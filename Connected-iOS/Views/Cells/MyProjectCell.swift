//
//  MyProjectCell.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyProjectCell: UITableViewCell, BaseCell {

    // MARK: - UI Properties

    // MARK: - Properties

    var viewModel: ViewModelType? {
        didSet { bindViewModel() }
    }

    // MARK: - Lifecycle

    deinit {
//        viewModel?.inputs.deinited()
    }

    // MARK: - Functions

    private func bindViewModel() {

    }

    func configureWith(with item: Int) {

    }

    typealias Item = Int
    typealias ViewModelType = Int

}
