//
//  TopTabBarDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/27.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class TopTabBarDataSource: BaseDataSource {

    // MARK: - Properties

    private let cellConfigurator: TopTabBarCell.Configurator

    // MARK: - Lifecycle

    init(
        cellConfigurator: TopTabBarCell.Configurator
    ) {
        self.cellConfigurator = cellConfigurator
    }

    required init(dependency: Dependency, payload: ()) {
        fatalError("Fatal Error CategoryDataSource initializer")
    }

    // MARK: - Functions

    override func configureCell(collectionCell cell: UICollectionViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as TopTabBarCell, item as (Int, TopTabBarItem)):
            cellConfigurator.configure(cell, payload: .init(index: item.0, topTabBarItem: item.1))
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }
}
