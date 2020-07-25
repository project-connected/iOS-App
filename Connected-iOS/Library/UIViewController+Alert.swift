//
//  UIViewController+Alert.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

protocol Alertable {
    func showAlert(title: String, msg: String, style: UIAlertController.Style)
    func dismissAlert()
}

extension UIViewController: Alertable {

    @objc
    func showAlert(title: String, msg: String, style: UIAlertController.Style) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: style)
        present(alert, animated: true) { [weak self] in
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(self?.dismissAlert))
            alert.view.superview?.addGestureRecognizer(recognizer)
            alert.view.superview?.isUserInteractionEnabled = true
        }
    }

    @objc
    func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }
}
