//
//  RootViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/18.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum RootViewControllerData {
    case home
    case profile(isLoggedIn: Bool)
}

enum TabBarItem {
    case home(index: Int)
    case profile(index: Int)
}

protocol RootViewModelInputs {
    func shouldSelect(index: Int)
    func initialized()
}

protocol RootViewModelOutputs {
    func setViewControllers() -> Driver<[RootViewControllerData]>
    func tabBarItems() -> Driver<[TabBarItem]>
}

protocol RootViewModelType {
    var inputs: RootViewModelInputs { get }
    var outputs: RootViewModelOutputs { get }
}

final class RootViewModel: RootViewModelType, RootViewModelInputs, RootViewModelOutputs {

    var inputs: RootViewModelInputs { return self }
    var outputs: RootViewModelOutputs { return self }
    let disposeBag = DisposeBag()

    // MARK: - Inputs

    private let shouldSelectProperty: PublishRelay<Int> = PublishRelay()
    func shouldSelect(index: Int) {
        self.shouldSelectProperty.accept(index)
    }

    private let initializedProperty: PublishRelay<Void> = PublishRelay()
    func initialized() {
        self.initializedProperty.accept(Void())
    }

    // MARK: - Outputs

    private let setViewControllersProperty: BehaviorRelay<[RootViewControllerData]>
        = BehaviorRelay(value: [])
    func setViewControllers() -> Driver<[RootViewControllerData]> {
        return self.setViewControllersProperty.asDriver()
    }

    private let tabBarItemsProperty: BehaviorRelay<[TabBarItem]>
        = BehaviorRelay(value: [])
    func tabBarItems() -> Driver<[TabBarItem]> {
        return self.tabBarItemsProperty.asDriver()
    }

    // MARK: - Lifecycle

    init() {

        let currentUser = Observable.merge(
            self.initializedProperty.map { false },
            Observable.just(nil)
        )

        let standardViewControllers = self.initializedProperty
            .map(self.generateStandardViewControllers)

        let personalizedViewControllers = currentUser.filter { $0 != nil }
            .distinctUntilChanged(==)
            .map { self.generatePersonalizedViewControllers(isLoggedIn: $0!) }

        Observable.combineLatest(standardViewControllers, personalizedViewControllers)
            .map(+)
            .bind(to: self.setViewControllersProperty)
            .disposed(by: self.disposeBag)

        self.initializedProperty
            .map(self.tabData)
            .bind(to: self.tabBarItemsProperty)
            .disposed(by: self.disposeBag)

    }

    // MARK: - Functions

    private func generateStandardViewControllers() -> [RootViewControllerData] {
        return [.home]
    }

    private func generatePersonalizedViewControllers(isLoggedIn: Bool) -> [RootViewControllerData] {
        return [.profile(isLoggedIn: isLoggedIn)]
    }

    private func tabData() -> [TabBarItem] {
        return [.home(index: 0), .profile(index: 1)]
    }
}