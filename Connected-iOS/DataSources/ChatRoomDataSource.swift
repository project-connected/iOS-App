//
//  ChatRoomDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class ChatRoomDataSource: BaseDataSource {

    // MARK: - Properties

    private let chatRoomCellViewModelFactory: ChatRoomCellViewModelFactory
    private let errorCellViewModelFactory: ErrorCellViewModelFactory

    // MARK: - Lifecycle

    init(
        chatRoomCellViewModelFactory: @escaping ChatRoomCellViewModelFactory,
        errorCellViewModelFactory: @escaping ErrorCellViewModelFactory
    ) {
        self.chatRoomCellViewModelFactory = chatRoomCellViewModelFactory
        self.errorCellViewModelFactory = errorCellViewModelFactory
    }

    // MARK: - Functions

    override func configureCell(tableCell cell: UITableViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as ChatRoomCell, item as ChatRoom):
            cell.configureWith(with: item, viewModelFactory: chatRoomCellViewModelFactory)
        case let (cell as ErrorCell, item as Error):
            cell.configureWith(with: item, viewModelFactory: errorCellViewModelFactory)
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }
}
