//
//  Project.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

struct Project {
    let id: Id
    let name: String
    let thumbnailImageUrl: String
    let categories: [Category]
}

extension Project {
    typealias Id = Int
    typealias Category = String
}

struct ThemedProjects {
    let theme: String
    let projects: [Project]
}
