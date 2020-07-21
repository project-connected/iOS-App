//
//  BorderStyles.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/20.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

func baseBorderStyle(view: UIView) -> UIView {
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.black.cgColor
    return view
}
