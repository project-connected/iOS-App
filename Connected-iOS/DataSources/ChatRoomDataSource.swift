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

    private let chatRoomCellViewModelFactory: ChatRoomCellViewModel.Factory
    private let errorCellViewModelFactory: ErrorCellViewModelFactory

    // MARK: - Lifecycle

    init(
        chatRoomCellViewModelFactory: @escaping ChatRoomCellViewModel.Factory,
        errorCellViewModelFactory: @escaping ErrorCellViewModelFactory
    ) {
        self.chatRoomCellViewModelFactory = chatRoomCellViewModelFactory
        self.errorCellViewModelFactory = errorCellViewModelFactory
    }

    // MARK: - Functions

    override func configureCell(tableCell cell: UITableViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as ChatRoomCell, item as Chat.Room):
            if cell.viewModel == nil {
                cell.viewModel = chatRoomCellViewModelFactory()
            }
            cell.configureWith(with: item)
        case let (cell as ErrorCell, item as Error):
            if cell.viewModel == nil {
                cell.viewModel = errorCellViewModelFactory()
            }
            cell.configureWith(with: item)
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }
}
