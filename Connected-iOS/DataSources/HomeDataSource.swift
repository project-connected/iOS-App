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
    private let projectCollectionCellConfigurator: ProjectCollectionCell.Configurator
    weak var cellDelegate: ProjectCollectionCellDelegate?

    // MARK: - Lifecycle

    init(
        errorCellViewModelFactory: @escaping ErrorCellViewModelFactory,
        projectCollectionCellConfigurator: ProjectCollectionCell.Configurator
    ) {
        self.errorCellViewModelFactory = errorCellViewModelFactory
        self.projectCollectionCellConfigurator = projectCollectionCellConfigurator

        super.init()
    }

    required init(dependency: Dependency, payload: ()) {
        fatalError("Fatal Error HomeDataSource initializer")
    }

    // MARK: - Functions

    override func configureCell(tableCell cell: UITableViewCell, with item: Any) {
        switch (cell, item) {
        case let (cell as ErrorCell, item as Error):
            cell.configureWith(with: item, viewModelFactory: errorCellViewModelFactory)
        case let (cell as ProjectCollectionCell, item as ThemedProjects):
            cell.delegate = cellDelegate
            projectCollectionCellConfigurator.configure(cell, payload: .init(themedProjects: item))
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }

}
