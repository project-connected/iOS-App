//
//  ChatRoomCell.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChatRoomCell: UITableViewCell, BaseCell {

    // MARK: - UI Properties

    private let roomNameLabel: UILabel = UILabel()

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: ChatRoomCellViewModelType? {
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

    deinit {
        viewModel?.inputs.deinited()
    }

    // MARK: - Functions

    private func setUpLayout() {
        [roomNameLabel]
            .addSubviews(parent: contentView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            roomNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            roomNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            roomNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            roomNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }

    private func bindStyles() {
        contentView.backgroundColor = .white

        roomNameLabel.textColor = .black
        roomNameLabel.textAlignment = .center
    }

    private func bindViewModel() {
        viewModel?.outputs.roomName()
            .drive(roomNameLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func configureWith(with item: ChatRoom) {
        viewModel?.inputs.configure(with: item)
    }
}
