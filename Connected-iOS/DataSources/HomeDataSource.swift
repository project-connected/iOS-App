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

    private let errorCellConfigurator: ErrorCell.Configurator
    private let projectCollectionCellConfigurator: ProjectCollectionCell.Configurator
    weak var cellDelegate: ProjectCollectionCellDelegate?

    // MARK: - Lifecycle

    init(
        errorCellConfigurator: ErrorCell.Configurator,
        projectCollectionCellConfigurator: ProjectCollectionCell.Configurator
    ) {
        self.errorCellConfigurator = errorCellConfigurator
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
            errorCellConfigurator.configure(cell, payload: .init(error: item))
        case let (cell as ProjectCollectionCell, item as ThemedProjects):
            cell.delegate = cellDelegate
            projectCollectionCellConfigurator.configure(cell, payload: .init(themedProjects: item))
        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }

}
