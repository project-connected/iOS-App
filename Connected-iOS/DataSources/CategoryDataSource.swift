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

    private let categoryCellViewModelFactory: CategoryCellViewModelFactory

    // MARK: - Lifecycle

    init(
        categoryCellViewModelFactory: @escaping CategoryCellViewModelFactory
    ) {
        self.categoryCellViewModelFactory = categoryCellViewModelFactory
    }

    // MARK: - Functions

    override func configureCell(collectionCell cell: UICollectionViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as CategoryCell, item as String):
            if cell.viewModel == nil {
                cell.viewModel = categoryCellViewModelFactory()
            }
            cell.configureWith(with: item)
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }
}
