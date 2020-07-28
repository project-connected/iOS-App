//
//  UIRefreshControlStyles.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

func baseRefreshControlStyle(refresh: UIRefreshControl?) -> UIRefreshControl? {
    guard let refresh = refresh else { return nil }
    refresh.attributedTitle = NSAttributedString(string: "새로고침")
    return refresh
}
