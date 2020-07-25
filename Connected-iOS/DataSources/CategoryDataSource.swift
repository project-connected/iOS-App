//
//  CategoryDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/25.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class CategoryDataSource: BaseDataSource {

    // MARK: - Properties

    private let categoryCellConfigurator: CategoryCell.Configurator

    // MARK: - Lifecycle

    init(
        categoryCellConfigurator: CategoryCell.Configurator
    ) {
        self.categoryCellConfigurator = categoryCellConfigurator
    }

    required init(dependency: Dependency, payload: ()) {
        fatalError("Fatal Error CategoryDataSource initializer")
    }

    // MARK: - Functions

    override func configureCell(collectionCell cell: UICollectionViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as CategoryCell, item as String):
            categoryCellConfigurator.configure(cell, payload: .init(category: item))
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }
}
