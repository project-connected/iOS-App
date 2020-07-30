//
//  UITextField+.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/29.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

extension UITextField {
    func setLeftPadding(_ amount: CGFloat) {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = padding
        self.leftViewMode = .always
    }

    func setRightPadding(_ amount: CGFloat) {
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.rightView = padding
        self.rightViewMode = .always
    }

    func setHorizontalPadding(_ amount: CGFloat) {
        self.setLeftPadding(amount)
        self.setRightPadding(amount)
    }
}
