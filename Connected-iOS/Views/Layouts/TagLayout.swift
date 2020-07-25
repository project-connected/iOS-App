//
//  TagLayout.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/25.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

class TagLayout: UICollectionViewFlowLayout {

    // MARK: - Lifecycle

    init(
        minimumLineSpacing: CGFloat = 0,
        minimumInteritemSpacing: CGFloat = 0,
        sectionInset: UIEdgeInsets = .zero
    ) {
        super.init()

        self.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        self.minimumLineSpacing = minimumLineSpacing
        self.minimumInteritemSpacing = minimumInteritemSpacing
        self.sectionInset = sectionInset
        self.sectionInsetReference = .fromSafeArea
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Functions

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let baseAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        guard scrollDirection == .vertical else {
            return baseAttributes
        }

        let cellAttributes = baseAttributes.filter { $0.representedElementCategory == .cell }

        let dictionary = Dictionary(grouping: cellAttributes, by: { $0.center.y })

        for (_, attributes) in dictionary {
            var leftInset = sectionInset.left

            for attribute in attributes {
                attribute.frame.origin.x = leftInset
                leftInset = attribute.frame.maxX + minimumInteritemSpacing
            }
        }

        return baseAttributes
    }
}
