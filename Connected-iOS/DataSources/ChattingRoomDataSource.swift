//
//  ChattingRoomDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class ChattingRoomDataSource: BaseDataSource {

    // MARK: - Properties

    // MARK: - Lifecycle

    override init(

    ) {

    }

    required init(dependency: Dependency, payload: ()) {
        fatalError("Fatal Error \(classNameWithoutModule(Self.self)) initializer")
    }

    // MARK: - Functions

    override func configureCell(tableCell cell: UITableViewCell, with item: Any) {
        switch (cell, item) {
//        case let (cell as Cell, item as ):
//            cellConfigurator.configure(cell, payload: .init())

        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }
}
