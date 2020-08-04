//
//  MyProjectDataSource.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class MyProjectDataSource: BaseDataSource {

    // MARK: - Properties

    // MARK: - Lifecycle

    override init(

    ) {

    }

    // MARK: - Functions

    override func configureCell(tableCell cell: UITableViewCell, with item: Any) {
        switch (cell, item) {
//        case let (cell as ErrorCell, item as Error):
//            errorCellConfigurator.configure(cell, payload: .init(error: item))

//        case let (cell as ErrorCell, item as Error):
//            errorCellConfigurator.configure(cell, payload: .init(error: item))

        default:
            fatalError("Unrecognized set : \(cell), \(item)")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(with: MyProjectCell.self, for: indexPath)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

}
