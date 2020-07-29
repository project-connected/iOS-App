//
//  ChatMessage.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation

typealias ChatMessageContents = String

struct ChatMessage {
    let roomId: ChattingRoomId
    let sender: UserId
    let contents: ChatMessageContents
}
