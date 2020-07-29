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

    private let cellConfigurator: ChatRoomCell.Configurator
    private let errorCellConfigurator: ErrorCell.Configurator

    // MARK: - Lifecycle

    init(
        cellConfigurator: ChatRoomCell.Configurator,
        errorCellConfigurator: ErrorCell.Configurator
    ) {
        self.cellConfigurator = cellConfigurator
        self.errorCellConfigurator = errorCellConfigurator
    }

    required init(dependency: Dependency, payload: ()) {
        fatalError("Fatal Error \(classNameWithoutModule(Self.self)) initializer")
    }

    // MARK: - Functions

    override func configureCell(tableCell cell: UITableViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as ChatRoomCell, item as ChatRoom):
            cellConfigurator.configure(cell, payload: .init(chatRoom: item))
        case let (cell as ErrorCell, item as Error):
            errorCellConfigurator.configure(cell, payload: .init(error: item))
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }
}
