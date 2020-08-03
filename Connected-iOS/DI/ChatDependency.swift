//
//  ChatDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import Pure

extension AppDependency {
    static func resolveChatDependencies(
        networkService: NetworkServiceType,
        imageLoader: ImageLoaderType
    ) -> ChatCoordinator.Factory {
        return .init(
            dependency: .init(
                chatLobbyViewControllerFactory: .init(
                    dependency: .init(
                        viewModelFactory: .init(
                            dependency: .init(
                                networkService: networkService
                            )
                        ),
                        chatRoomDataSourceFactory: .init(
                            dependency: .init(
                                cellConfigurator: .init(
                                    dependency: .init(
                                        viewModelFactory: .init(
                                            dependency: .init()
                                        )
                                    )
                                ),
                                errorCellConfigurator: .init(
                                    dependency: .init(
                                        viewModelFactory: .init()
                                    )
                                )
                            )
                        ),
                        chatRoomViewControllerFactory: .init(
                            dependency: .init(
                                viewModelFactory: .init(
                                    dependency: .init(
                                        networkService: networkService
                                    )
                                )
                            )
                        )
                    )
                )
            )
        )
    }
}

// MARK: - ChatLobbyViewModel

extension ChatLobbyViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {
        let networkService: NetworkServiceType
    }
}

extension Factory where Module == ChatLobbyViewModel {
    func create() -> ChatLobbyViewModel {
        let module = Module(
            networkService: dependency.networkService
        )
        return module
    }
}

// MARK: - ChatLobbyViewController

extension ChatLobbyViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: ChatLobbyViewModel.Factory
        let chatRoomDataSourceFactory: ChatRoomDataSource.Factory
        let chatRoomViewControllerFactory: ChatRoomViewController.Factory
    }
}

extension Factory where Module == ChatLobbyViewController {
    func create() -> ChatLobbyViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            dataSource: dependency.chatRoomDataSourceFactory.create(),
            chatRoomViewControllerFactory: dependency.chatRoomViewControllerFactory
        )
        return module
    }
}

// MARK: - ChatRoomDataSource

extension ChatRoomDataSource: FactoryModule {
    struct Dependency {
        let cellConfigurator: ChatRoomCell.Configurator
        let errorCellConfigurator: ErrorCell.Configurator
    }
}

extension Factory where Module == ChatRoomDataSource {
    func create() -> ChatRoomDataSource {
        let module = Module(
            cellConfigurator: dependency.cellConfigurator,
            errorCellConfigurator: dependency.errorCellConfigurator
        )
        return module
    }
}

// MARK: - ChatRoomCell

extension ChatRoomCell: ConfiguratorModule {
    struct Dependency {
        let viewModelFactory: ChatRoomCellViewModel.Factory
    }

    struct Payload {
        let chatRoom: ChatRoom
    }

    func configure(dependency: Dependency, payload: Payload) {
        if self.viewModel == nil {
            self.viewModel = dependency.viewModelFactory.create()
        }
        self.configureWith(with: payload.chatRoom)
    }
}

// MARK: - ChatRoomCellViewModel

extension ChatRoomCellViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {

    }
}

extension Factory where Module == ChatRoomCellViewModel {
    func create() -> ChatRoomCellViewModel {
        let module = Module()
        return module
    }
}

// MARK: - ChatRoomViewModel

extension ChatRoomViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {
        let networkService: NetworkServiceType
    }
}

extension Factory where Module == ChatRoomViewModel {
    func create() -> ChatRoomViewModel {
        let module = Module(
            networkService: dependency.networkService
        )
        return module
    }
}

// MARK: - ChatRoomViewController

extension ChatRoomViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: ChatRoomViewModel.Factory
    }

    struct Payload {
        let chatRoom: ChatRoom
    }
}

extension Factory where Module == ChatRoomViewController {
    func create(payload: Module.Payload) -> ChatRoomViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            chatRoom: payload.chatRoom
        )
        return module
    }
}
