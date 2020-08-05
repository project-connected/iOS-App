//
//  ChatCounterpartMessageCell.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/05.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ChatCounterpartMessageCell: UITableViewCell, BaseCell {

    // MARK: - UI Properties

    // MARK: - Properties

    private let disposeBag = DisposeBag()
    var viewModel: ChatCounterpartMessageCellViewModelType? {
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

    }

    private func bindStyles() {

    }

    private func bindViewModel() {

    }

    func configureWith(with item: Chat.Message) {
        viewModel?.inputs.configure(with: item)
    }
}
