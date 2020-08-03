//
//  ErrorCell.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/25.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ErrorCell: UITableViewCell, BaseCell {

    // MARK: - UI Properties

    private let errorTitleLabel: UILabel = UILabel()
    private let errorMsgLabel: UILabel = UILabel()

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: ErrorCellViewModelType? {
        didSet { bindViewModel() }
    }

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setUpLayout()
        bindStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func setUpLayout() {
        [errorTitleLabel, errorMsgLabel]
        .addSubviews(parent: contentView)
        .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            errorTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            errorTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            errorTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            errorTitleLabel.heightAnchor.constraint(equalToConstant: 100),

            errorMsgLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            errorMsgLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            errorMsgLabel.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor),
            errorMsgLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            errorMsgLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 500)
        ])
    }

    private func bindStyles() {
        errorTitleLabel.textAlignment = .center
        errorTitleLabel.textColor = .black
        errorTitleLabel.backgroundColor = .green

        errorMsgLabel.textAlignment = .center
        errorMsgLabel.textColor = .black
        errorMsgLabel.backgroundColor = .yellow
    }

    private func bindViewModel() {

        self.rx.deallocated
            .bind(onNext: { [weak self] in
                self?.viewModel?.inputs.deinited()
            })
            .disposed(by: disposeBag)

        viewModel?.outputs.errorTitle()
            .drive(errorTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel?.outputs.errorMsg()
            .drive(errorMsgLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func configureWith(with error: Error) {
        viewModel?.inputs.configure(with: error)
    }
}
