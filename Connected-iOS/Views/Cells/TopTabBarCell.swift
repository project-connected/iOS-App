//
//  TopTabBarCell.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/27.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class TopTabBarCell: UICollectionViewCell, BaseCell {

    // MARK: - UI Properties

    private let menuTitleLabel: UILabel = UILabel()
    private let indicatorView: UIView = UIView()

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: TopTabBarCellViewModelType?

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
        let minimumWidth = UIScreen.main.bounds.width / 2 - 5

        [menuTitleLabel, indicatorView]
            .addSubviews(parent: contentView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            menuTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            menuTitleLabel.bottomAnchor.constraint(equalTo: indicatorView.topAnchor),
            menuTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            menuTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            menuTitleLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: minimumWidth),
            menuTitleLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 50),

            indicatorView.heightAnchor.constraint(equalToConstant: 2),
            indicatorView.topAnchor.constraint(equalTo: menuTitleLabel.bottomAnchor),
            indicatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            indicatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            indicatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func bindStyles() {

        menuTitleLabel.backgroundColor = .white
        menuTitleLabel.textColor = .black
        menuTitleLabel.textAlignment = .center

        indicatorView.backgroundColor = .black
    }

    func bindViewModel() {
        viewModel?.outputs.menuTitle()
            .drive(menuTitleLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel?.outputs.indicatorIsHidden()
            .drive(indicatorView.rx.isHidden)
            .disposed(by: disposeBag)
    }

    func configureWith(with item: (Int, TopTabBarItem)) {
        viewModel?.inputs.configure(with: item)
    }

    func itemSelected(index: Int) {
        viewModel?.inputs.itemSelected(index: index)
    }
}
