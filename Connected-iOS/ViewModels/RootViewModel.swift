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
    case myProject
    case chat
    case profile(isLoggedIn: Bool)
}

enum TabBarItem {
    case home(index: Int)
    case myProject(index: Int)
    case chat(index: Int)
    case profile(index: Int)
}

protocol RootViewModelInputs {
    func didSelect(index: Int)
    func viewDidLoad()
     func deinited()
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
    private var disposeBag = DisposeBag()

    // MARK: - Inputs

    private let didSelectProperty: PublishRelay<Int> = PublishRelay()
    func didSelect(index: Int) {
        didSelectProperty.accept(index)
    }

    private let viewDidLoadProperty: PublishRelay<Void> = PublishRelay()
    func viewDidLoad() {
        viewDidLoadProperty.accept(Void())
    }

    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }

    // MARK: - Outputs

    private let setViewControllersProperty: BehaviorRelay<[RootViewControllerData]>
        = BehaviorRelay(value: [])
    func setViewControllers() -> Driver<[RootViewControllerData]> {
        return setViewControllersProperty.asDriver()
    }

    private let tabBarItemsProperty: BehaviorRelay<[TabBarItem]>
        = BehaviorRelay(value: [])
    func tabBarItems() -> Driver<[TabBarItem]> {
        return tabBarItemsProperty.asDriver()
    }

    // MARK: - Lifecycle

    init() {

        let currentUser = Observable.merge(
            viewDidLoadProperty.map { false },
            Observable.just(nil)
        )

        let standardViewControllers = viewDidLoadProperty
            .map(generateStandardViewControllers)

        let personalizedViewControllers = currentUser.filter { $0 != nil }
            .distinctUntilChanged(==)
            .map { self.generatePersonalizedViewControllers(isLoggedIn: $0!) }

        Observable.combineLatest(standardViewControllers, personalizedViewControllers)
            .map(+)
            .bind(to: setViewControllersProperty)
            .disposed(by: disposeBag)

        viewDidLoadProperty
            .map(tabData)
            .bind(to: tabBarItemsProperty)
            .disposed(by: disposeBag)

               deinitedProperty
                   .bind(onNext: { self.disposeBag = DisposeBag() })
                   .disposed(by: disposeBag)

    }

    // MARK: - Functions

    private func generateStandardViewControllers() -> [RootViewControllerData] {
        return [.home]
    }

    private func generatePersonalizedViewControllers(isLoggedIn: Bool) -> [RootViewControllerData] {
        return [.myProject, .chat, .profile(isLoggedIn: isLoggedIn)]
    }

    private func tabData() -> [TabBarItem] {
        return [.home(index: 0), .myProject(index: 1), .chat(index: 2), .profile(index: 3)]
    }
}
