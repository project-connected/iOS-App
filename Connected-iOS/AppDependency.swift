//
//  AppDependency.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/16.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import Pure
import Firebase

extension AppDependency {

    static func resolve() -> AppDependency {
        return AppDependency(
            analyticsService: FirebaseApp.self,
            networkService: TempNetworkService(),
            rootTabBarControllerFactory: .init(
                dependency: .init(
                    viewModelFactory: RootViewModel.Factory(
                        dependency: .init()
                    )
                )
            )
        )
    }

}

// MARK: - AppDependency

struct AppDependency {
    let analyticsService: AnalyticsService.Type
    let networkService: NetworkService
    let rootTabBarControllerFactory: RootTabBarController.Factory
}

// MARK: - RootViewModel

extension RootViewModel: FactoryModule {
    convenience init(dependency: Dependency, payload: ()) {
        self.init(dependency: dependency)
    }

    struct Dependency {

    }
}

extension Factory where Module == RootViewModel {
    func create() -> Module {
        let module = Module()
        return module
    }
}

// MARK: - RootTabBarController

extension RootTabBarController: FactoryModule {
    struct Dependency {
        let viewModelFactory: RootViewModel.Factory
    }
}

extension Factory where Module == RootTabBarController {
    func create() -> Module {
        let viewModel = dependency.viewModelFactory.create()
        let module = Module(viewModel: viewModel)
        return module
    }
}

// MARK: - ViewController

extension ViewController: FactoryModule {

    struct Dependency {
    }
}

extension Factory where Module == ViewController {
    func create() -> Module {
        let module = Module()
        return module
    }
}
