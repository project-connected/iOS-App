//
//  ChatMyMessage.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/05.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChatMyMessageCell: UITableViewCell, BaseCell {

    // MARK: - UI Properties

    private let userNameLabel: UILabel = UILabel()
    private let messageLabel: UILabel = UILabel()

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: ChatMyMessageCellViewModelType? {
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
        [userNameLabel, messageLabel]
            .addSubviews(parent: contentView)
            .setTranslatesAutoresizingMaskIntoConstraints()

        NSLayoutConstraint.activate([
            userNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            userNameLabel.bottomAnchor.constraint(equalTo: messageLabel.topAnchor),
            userNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            userNameLabel.widthAnchor.constraint(greaterThanOrEqualTo: messageLabel.widthAnchor),
            userNameLabel.heightAnchor.constraint(equalToConstant: 60),

            messageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor),
            messageLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15),
            messageLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            messageLabel.widthAnchor.constraint(greaterThanOrEqualTo: userNameLabel.widthAnchor),
            messageLabel.heightAnchor.constraint(equalToConstant: 60)
        ])
    }

    private func bindStyles() {
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear

        userNameLabel.textColor = .black
        userNameLabel.textAlignment = .right
        userNameLabel.backgroundColor = .yellow

        messageLabel.textColor = .black
        messageLabel.textAlignment = .right
        messageLabel.backgroundColor = .yellow
    }

    private func bindViewModel() {

        self.rx.deallocated
            .bind(onNext: { [weak self] in
                self?.viewModel?.inputs.deinited()
            })
            .disposed(by: disposeBag)

        viewModel?.outputs.userName()
            .drive(userNameLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel?.outputs.message()
            .drive(messageLabel.rx.text)
            .disposed(by: disposeBag)
    }

    func configureWith(with item: Chat.Message) {
        viewModel?.inputs.configure(with: item)
    }
}
