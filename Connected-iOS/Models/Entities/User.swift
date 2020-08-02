//
//  User.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/20.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

struct User {
    let id: Id
    let authToken: AuthToken?
}

extension User {
    typealias AuthToken = String
    typealias Id = Int
}

extension User: Equatable {
    static func == (left: User, right: User) -> Bool {
        return left.id == right.id
    }
}

struct SignUpInfo {
    let email: String
    let password: String
    let nickname: String
}
