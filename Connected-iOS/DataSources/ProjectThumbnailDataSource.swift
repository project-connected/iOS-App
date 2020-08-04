//
//  ProjectThumbnailDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class ProjectThumbnailDataSource: BaseDataSource {

    // MARK: - Properties

    private let cellViewModelFactory: ProjectThumbnailCellViewModelFactory
    private let categoryDataSourceFactory: CategoryDataSourceFactory
    private let imageLoader: ImageLoaderType

    // MARK: - Lifecycle

    init(
        cellViewModelFactory: @escaping ProjectThumbnailCellViewModelFactory,
        categoryDataSourceFactory: @escaping CategoryDataSourceFactory,
        imageLoader: ImageLoaderType
    ) {
        self.cellViewModelFactory = cellViewModelFactory
        self.categoryDataSourceFactory = categoryDataSourceFactory
        self.imageLoader = imageLoader

        super.init()
    }

    // MARK: - Functions

    override func configureCell(collectionCell cell: UICollectionViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as ProjectThumbnailCardCell, item as Project):
            if cell.viewModel == nil {
                cell.viewModel = cellViewModelFactory()
                cell.dataSource = categoryDataSourceFactory()
                cell.imageLoader = imageLoader
            }
            cell.configureWith(with: item)
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }

}
