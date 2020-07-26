//
//  MyProjectDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import Pure

extension AppDependency {
    static func resolveMyProjectContainerDependencies(
        networkService: NetworkServiceType,
        imageLoader: ImageLoaderType
    ) -> MyProjectContainerViewController.Factory {
        return .init(
            dependency: .init(
                viewModelFactory: .init()
            )
        )
    }
}

// MARK: - MyProjectContainerViewModel

extension MyProjectContainerViewModel: FactoryModule {
    convenience init(dependency: (), payload: ()) {
        self.init()
    }
}

extension Factory where Module == MyProjectContainerViewModel {
    func create() -> MyProjectContainerViewModel {
        let module = Module()
        return module
    }
}

// MARK: - MyProjectContainerViewController

extension MyProjectContainerViewController: FactoryModule {
    struct Dependency {
        let viewModelFactory: MyProjectContainerViewModel.Factory
    }
}

extension Factory where Module == MyProjectContainerViewController {
    func create() -> MyProjectContainerViewController {
        let module = Module(
            viewModel: dependency.viewModelFactory.create()
        )
        return module
    }
}
