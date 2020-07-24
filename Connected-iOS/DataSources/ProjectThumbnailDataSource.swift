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

    private let cellViewModelFactory: ProjectThumbnailCellViewModel.Factory
    private let cellConfigurator: ProjectThumbnailCardCell.Configurator

    // MARK: - Lifecycle

    init(
        cellViewModelFactory: ProjectThumbnailCellViewModel.Factory,
        cellConfigurator: ProjectThumbnailCardCell.Configurator
    ) {
        self.cellViewModelFactory = cellViewModelFactory
        self.cellConfigurator = cellConfigurator

        super.init()
    }

    required init(dependency: Dependency, payload: ()) {
        fatalError("Fatal Error ProjectThumbnailDataSource initializer")
    }

    // MARK: - Functions

    override func configureCell(collectionCell cell: UICollectionViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as ProjectThumbnailCardCell, item as Project):
            cellConfigurator.configure(cell, payload: .init(project: item))
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }

}
