//
//  AutoLayout.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/20.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

func constraintViewToCenterInParent(parent: UIView, child: UIView) {
    NSLayoutConstraint.activate([
        child.centerXAnchor.constraint(equalTo: parent.centerXAnchor),
        child.centerYAnchor.constraint(equalTo: parent.centerYAnchor)
    ])
}

func constraintViewToCenterInViewController(parent: UIViewController, child: UIView) {
    NSLayoutConstraint.activate([
        child.centerXAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.centerXAnchor),
        child.centerYAnchor.constraint(equalTo: parent.view.safeAreaLayoutGuide.centerYAnchor)
    ])
}
