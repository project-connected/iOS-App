//
//  BaseCell.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

public protocol BaseCell: class {

    associatedtype Item
    associatedtype ViewModelType

    static var reusableId: String { get }

    var viewModel: ViewModelType? { get set }

    func configureWith(with item: Item)
}

extension BaseCell {
    static var reusableId: String {
        return classNameWithoutModule(Self.self)
    }
}
