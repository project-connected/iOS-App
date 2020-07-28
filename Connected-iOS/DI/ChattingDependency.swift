//
//  ChattingDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import Pure

extension AppDependency {
    static func resolveChattingDependencies(
        networkService: NetworkServiceType,
        imageLoader: ImageLoaderType
    ) -> ChattingLobbyViewController.Factory {
        return .init(
            dependency: .init(
                viewModelFactory: .init(
                    dependency: .init(
                        networkService: networkService
                    )
                ),
                chattingRoomDataSourceFactory: .init(
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
                )
            )
        )
    }
}

// MARK: - ChattingLobbyViewModel

extension ChattingLobbyViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {
        let networkService: NetworkServiceType
    }
}

extension Factory where Module == ChattingLobbyViewModel {
    func create() -> ChattingLobbyViewModel {
        let module = Module(
            networkService: dependency.networkService
        )
        return module
    }
}

// MARK: - ChattingLobbyViewController

extension ChattingLobbyViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: ChattingLobbyViewModel.Factory
        let chattingRoomDataSourceFactory: ChattingRoomDataSource.Factory
    }
}

extension Factory where Module == ChattingLobbyViewController {
    func create() -> ChattingLobbyViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create(),
            dataSource: dependency.chattingRoomDataSourceFactory.create()
        )
        return module
    }
}

// MARK: - ChattingRoomDataSource

extension ChattingRoomDataSource: FactoryModule {
    struct Dependency {
        let cellConfigurator: ChattingRoomCell.Configurator
        let errorCellConfigurator: ErrorCell.Configurator
    }
}

extension Factory where Module == ChattingRoomDataSource {
    func create() -> ChattingRoomDataSource {
        let module = Module(
            cellConfigurator: dependency.cellConfigurator,
            errorCellConfigurator: dependency.errorCellConfigurator
        )
        return module
    }
}

// MARK: - ChattingRoomCell

extension ChattingRoomCell: ConfiguratorModule {
    struct Dependency {
        let viewModelFactory: ChattingRoomCellViewModel.Factory
    }

    struct Payload {
        let chattingRoom: ChattingRoom
    }

    func configure(dependency: Dependency, payload: Payload) {
        if self.viewModel == nil {
            self.viewModel = dependency.viewModelFactory.create()
            self.bindViewModel()
        }
        self.configureWith(with: payload.chattingRoom)
    }
}

// MARK: - ChattingRoomCellViewModel

extension ChattingRoomCellViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {

    }
}

extension Factory where Module == ChattingRoomCellViewModel {
    func create() -> ChattingRoomCellViewModel {
        let module = Module()
        return module
    }
}
