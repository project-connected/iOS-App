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
            viewControllerFactory: .init(
                dependency: ViewController.Dependency()
            )
        )
    }
}

struct AppDependency {
    let analyticsService: AnalyticsService.Type
    let viewControllerFactory: ViewController.Factory
}

// MARK: - ViewController

extension ViewController: FactoryModule {

    struct Dependency {
    }
}

extension Factory where Module == ViewController {
    func create() -> ViewController {
        let module = ViewController()
        return module
    }
}
