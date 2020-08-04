//
//  ChatCoordinator.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/04.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

protocol ChatCoordinatorType: Coordinator {
    func pushToChatRoom(chatRoom: ChatRoom)
}

class ChatCoordinator: Coordinator {

    // MARK: - Properties

    private let navigationController: UINavigationController
    private let chatLobbyViewControllerFactory: ChatLobbyViewControllerFactory
    private let chatRoomViewControllerFactory: ChatRoomViewControllerFactory

    // MARK: - Lifecycle

    init(
        navigationController: UINavigationController,
        chatLobbyViewControllerFactory: @escaping ChatLobbyViewControllerFactory,
        chatRoomViewControllerFactory: @escaping ChatRoomViewControllerFactory
    ) {
        self.navigationController = navigationController
        self.chatLobbyViewControllerFactory = chatLobbyViewControllerFactory
        self.chatRoomViewControllerFactory = chatRoomViewControllerFactory
    }

    // MARK: - Functions

    func start() {
        let viewController = chatLobbyViewControllerFactory(self)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension ChatCoordinator: ChatCoordinatorType {
    func pushToChatRoom(chatRoom: ChatRoom) {
        let viewController = chatRoomViewControllerFactory(chatRoom)
        navigationController.pushViewController(viewController, animated: true)
    }
}
