//
//  Array+UIView.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/19.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

extension Array where Element: UIView {

    @discardableResult
    func addSubviews(parent: UIView) -> Array {
        self.forEach { parent.addSubview($0) }
        return self
    }

    @discardableResult
    func addArrangedSubviews(parent: UIStackView) -> Array {
        self.forEach { parent.addArrangedSubview($0) }
        return self
    }

    @discardableResult
    func setTranslatesAutoresizingMaskIntoConstraints(value: Bool = false) -> Array {
        self.forEach { $0.translatesAutoresizingMaskIntoConstraints = value }
        return self
    }

}
