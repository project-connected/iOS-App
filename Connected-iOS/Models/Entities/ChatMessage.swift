//
//  ChatMessage.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

struct ChatMessage {
    let roomId: ChatRoom.Id
    let sender: User.Id
    let contents: Contents
}

extension ChatMessage {
    typealias Contents = String

}
