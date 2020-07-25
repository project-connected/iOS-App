//
//  ImageLoaderType.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import Foundation
import Kingfisher

protocol ImageLoaderType {
    func setImage(imageView: UIImageView, with url: URL?, placeholder: UIImage?)
    func setImage(imageView: UIImageView, with url: String, placeholder: UIImage?)
    func setImage(button: UIButton, with url: URL?, for state: UIControl.State)
    func setImage(button: UIButton, with url: String, for state: UIControl.State)
}

class KingfisherImageLoader: ImageLoaderType {
    func setImage(imageView: UIImageView, with url: URL?, placeholder: UIImage? = nil) {
        imageView.kf.setImage(with: url, placeholder: placeholder)
    }

    func setImage(imageView: UIImageView, with url: String, placeholder: UIImage? = nil) {
        let url = URL(string: url)
        setImage(imageView: imageView, with: url, placeholder: placeholder)
    }

    func setImage(button: UIButton, with url: URL?, for state: UIControl.State) {
        button.kf.setImage(with: url, for: state)
    }

    func setImage(button: UIButton, with url: String, for state: UIControl.State) {
        let url = URL(string: url)
        setImage(button: button, with: url, for: state)
    }
}
