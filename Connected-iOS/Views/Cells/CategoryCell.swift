//
//  CategoryCell.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/25.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class CategoryCell: UICollectionViewCell, BaseCell {

    typealias Item = String

    // MARK: - UI Properties

    private let categoryLabel: UILabel = UILabel()

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: CategoryCellViewModelType? {
        didSet { bindViewModel() }
    }

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setUpLayout()
        bindStyles()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    private func setUpLayout() {
        [categoryLabel]
            .addSubviews(parent: contentView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            categoryLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            categoryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            categoryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            categoryLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 150)
        ])
    }

    private func bindStyles() {
        categoryLabel.textColor = .black
        categoryLabel.textAlignment = .center

        contentView.backgroundColor = .lightGray
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.borderWidth = 1

        contentView.layer.cornerRadius = 10
    }

    private func bindViewModel() {

        self.rx.deallocated
            .bind(onNext: { [weak self] in
                self?.viewModel?.inputs.deinited()
            })
            .disposed(by: disposeBag)

        viewModel?.outputs.category()
            .drive(categoryLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func configureWith(with item: String) {
        viewModel?.inputs.configure(with: item)
    }

}
