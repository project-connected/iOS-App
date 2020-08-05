//
//  User.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/20.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

public struct User {
    let id: Id
    let authToken: AuthToken?

}

public extension User {
    struct SignUpInfo {
        let email: String
        let password: String
        let nickname: String
    }
}

public extension User {
    typealias AuthToken = String
    typealias Id = Int
}

extension User: Equatable {
    public static func == (left: User, right: User) -> Bool {
        return left.id == right.id
    }
}
