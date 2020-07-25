//
//  UITableView+.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/24.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

extension UITableView {
    func registerCell<CellClass: UITableViewCell>(
        _ cellClass: CellClass.Type
    ) {
        let identifier = classNameWithoutModule(cellClass)
        self.register(cellClass, forCellReuseIdentifier: identifier)
    }

    func dequeueReusableCell(
        with cellClass: UITableViewCell.Type,
        for indexPath: IndexPath
    ) -> UITableViewCell {
        let identifier = classNameWithoutModule(cellClass)
        return self.dequeueReusableCell(withIdentifier: identifier, for: indexPath)
    }
}
