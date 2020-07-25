//
//  UICollectionView+.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

extension UICollectionView {
    func registerCell<CellClass: UICollectionViewCell>(
        _ cellClass: CellClass.Type
    ) {
        let identifier = classNameWithoutModule(cellClass)
        self.register(cellClass, forCellWithReuseIdentifier: identifier)
    }

    func dequeueReusableCell(
        with cellClass: UICollectionViewCell.Type,
        for indexPath: IndexPath
    ) -> UICollectionViewCell {
        let identifier = classNameWithoutModule(cellClass)
        return self.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
}
