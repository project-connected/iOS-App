//
//  ChatMessageDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/05.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class ChatMessageDataSource: BaseDataSource {

    // MARK: - Properties

    private let myMsgCellViewModelFactory: ChatMyMessageCellViewModel.Factory
    private let counterpartMsgCellViewModelFactory: ChatCounterpartMessageCellViewModel.Factory

    // MARK: - Lifecycle

    init(
        myMsgCellViewModelFactory: @escaping ChatMyMessageCellViewModel.Factory,
        counterpartMsgCellViewModelFactory: @escaping ChatCounterpartMessageCellViewModel.Factory
    ) {
        self.myMsgCellViewModelFactory = myMsgCellViewModelFactory
        self.counterpartMsgCellViewModelFactory = counterpartMsgCellViewModelFactory
    }

    // MARK: - Functions

    override func configureCell(tableCell cell: UITableViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as ChatMyMessageCell, item as Chat.Message):
            configure(cell: cell, item: item, factory: myMsgCellViewModelFactory)
        case let (cell as ChatCounterpartMessageCell, item as Chat.Message):
            configure(cell: cell, item: item, factory: counterpartMsgCellViewModelFactory)
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }
}
