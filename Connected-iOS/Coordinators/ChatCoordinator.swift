//
//  ChatCoordinator.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/08/04.
//  Copyright © 2020 connected. All rights reserved.
//

import UIKit
import Pure

extension ChatCoordinator: FactoryModule {
    struct Dependency {
        let chatLobbyViewControllerFactory: ChatLobbyViewController.Factory
    }

    struct Payload {
        let navigationController: UINavigationController
    }
}

protocol ChatCoordinatorType: Coordinator {

}

class ChatCoordinator: ChatCoordinatorType {

    // MARK: - Properties

    private let navigationController: UINavigationController
    private let chatLobbyViewControllerFactory: ChatLobbyViewController.Factory

    // MARK: - Lifecycle

    required init(dependency: Dependency, payload: Payload) {
        self.navigationController = payload.navigationController
        self.chatLobbyViewControllerFactory = dependency.chatLobbyViewControllerFactory
    }

    // MARK: - Functions

    func start() {
        let viewController = chatLobbyViewControllerFactory.create()
        navigationController.pushViewController(viewController, animated: true)
    }
}
