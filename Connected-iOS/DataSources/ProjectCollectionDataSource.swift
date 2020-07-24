//
//  ProjectCollectionDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/24.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class ProjectCollectionDataSource: BaseDataSource {

    // MARK: - Properties

    private let cellViewModelFactory: ProjectCollectionCellViewModel.Factory
    private let cellConfigurator: ProjectCollectionCell.Configurator
    private weak var cellDelegate: ProjectCollectionCellDelegate?

    // MARK: - Lifecycle

    init(
        cellViewModelFactory: ProjectCollectionCellViewModel.Factory,
        cellConfigurator: ProjectCollectionCell.Configurator,
        cellDelegate: ProjectCollectionCellDelegate?
    ) {
        self.cellViewModelFactory = cellViewModelFactory
        self.cellConfigurator = cellConfigurator
        self.cellDelegate = cellDelegate

        super.init()
    }

    required init(dependency: Dependency, payload: Payload) {
        fatalError("Fatal Error ProjectCollectionDataSource initializer")
    }

    // MARK: - Functions

    override func configureCell(tableCell cell: UITableViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as ProjectCollectionCell, item as HomeProjectSubject):
            cell.delegate = cellDelegate
            cellConfigurator.configure(cell, payload: .init(projectSubject: item))
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }

}
