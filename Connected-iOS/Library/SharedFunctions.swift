//
//  SharedFunctions.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

func classNameWithoutModule(_ class: AnyClass) -> String {
    return `class`.description()
        .components(separatedBy: ".")
        .dropFirst()
        .joined(separator: ".")
}
