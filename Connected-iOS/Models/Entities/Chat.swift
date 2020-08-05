//
//  Chat.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

public struct Chat { }

public extension Chat {
    struct Room {
        let id: Id
    }

    struct Message {
        let roomId: Chat.Room.Id
        let sender: (id: User.Id, nickname: User.Nickname)
        let contents: Contents
    }
}

public extension Chat.Room {
    typealias Id = Int
}

public extension Chat.Message {
    typealias Contents = String
}
