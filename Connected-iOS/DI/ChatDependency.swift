//
//  ChatDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit

extension AppDependency {
    static func resolveChatDependencies(
        networkService: NetworkServiceType,
        imageLoader: ImageLoaderType,
        errorCellViewModelFactory: @escaping ErrorCellViewModelFactory
    ) -> ChatCoordinatorFactory {
        return { navigationController in
            ChatCoordinator(
                navigationController: navigationController,
                chatLobbyViewControllerFactory: { coordinator in
                    ChatLobbyViewController(
                        viewModel: ChatLobbyViewModel(networkService: networkService),
                        dataSource: ChatRoomDataSource(
                            chatRoomCellViewModelFactory: { ChatRoomCellViewModel() },
                            errorCellViewModelFactory: errorCellViewModelFactory
                        ),
                        coordinator: coordinator
                    )
                },
                chatRoomViewControllerFactory: { chatRoom in
                    ChatRoomViewController(
                        viewModel: ChatRoomViewModel(networkService: networkService),
                        chatRoom: chatRoom
                    )
                }
            )
        }
    }
}

typealias ChatCoordinatorFactory = (UINavigationController) -> Coordinator

typealias ChatLobbyViewControllerFactory = (ChatCoordinatorType) -> ChatLobbyViewController

typealias ChatRoomCellViewModelFactory = () -> ChatRoomCellViewModelType

typealias ChatRoomViewControllerFactory = (ChatRoom) -> ChatRoomViewController
