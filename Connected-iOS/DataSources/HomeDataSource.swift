//
//  HomeDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/24.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class HomeDataSource: BaseDataSource {

    // MARK: - Properties

    private let errorCellViewModelFactory: ErrorCellViewModelFactory
    private let projectCollectionCellFactory: ProjectCollectionCellViewModelFactory
    private let projectThumbnailDataSourceFactory: ProjectThumbnailDataSourceFactory
    private weak var coordinator: ProjectDetailCoordinatorType?

    // MARK: - Lifecycle

    init(
        errorCellViewModelFactory: @escaping ErrorCellViewModelFactory,
        projectCollectionCellFactory: @escaping ProjectCollectionCellViewModelFactory,
        projectThumbnailDataSourceFactory: @escaping ProjectThumbnailDataSourceFactory,
        coordinator: ProjectDetailCoordinatorType
    ) {
        self.errorCellViewModelFactory = errorCellViewModelFactory
        self.projectCollectionCellFactory = projectCollectionCellFactory
        self.projectThumbnailDataSourceFactory = projectThumbnailDataSourceFactory
        self.coordinator = coordinator

        super.init()
    }

    // MARK: - Functions

    override func configureCell(tableCell cell: UITableViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as ErrorCell, item as Error):
            if cell.viewModel == nil {
                cell.viewModel = errorCellViewModelFactory()
            }
            cell.configureWith(with: item)
        case let (cell as ProjectCollectionCell, item as ThemedProjects):
            if cell.viewModel == nil {
                cell.viewModel = projectCollectionCellFactory()
                cell.dataSource = projectThumbnailDataSourceFactory()
                cell.coordinator = coordinator
            }
            cell.configureWith(with: item)
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }

}
