//
//  TopTabBarViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TopTabBarViewModelInputs {
    func projectStates(states: [ProjectState])
    func itemClicked(index: Int)
    func selectItem(index: Int)
}

protocol TopTabBarViewModelOutputs {
    func tabBarItems() -> Driver<[(Int, ProjectState)]>
    func notifyClickedItem() -> Signal<(Int, ProjectState)>
    func selectedItem() -> Driver<Int>
}

protocol TopTabBarViewModelType {
    var inputs: TopTabBarViewModelInputs { get }
    var outputs: TopTabBarViewModelOutputs { get }
}

final class TopTabBarViewModel: TopTabBarViewModelType,
TopTabBarViewModelInputs, TopTabBarViewModelOutputs {

    // MARK: - Properties

    var inputs: TopTabBarViewModelInputs { return self }
    var outputs: TopTabBarViewModelOutputs { return self }
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    private let projectStatesProperty: PublishRelay<[ProjectState]> = PublishRelay()
    func projectStates(states: [ProjectState]) {
        self.projectStatesProperty.accept(states)
    }

    private let itemClickedProperty: PublishRelay<Int> = PublishRelay()
    func itemClicked(index: Int) {
        itemClickedProperty.accept(index)
    }

    private let selectItemProperty: PublishRelay<Int> = PublishRelay()
    func selectItem(index: Int) {
        selectItemProperty.accept(index)
    }

    // MARK: - Outputs

    private let tabBarItemsProperty: BehaviorRelay<[(Int, ProjectState)]> = BehaviorRelay(value: [])
    func tabBarItems() -> Driver<[(Int, ProjectState)]> {
        return tabBarItemsProperty.asDriver()
    }

    private let notifyClickedItemProperty: PublishRelay<(Int, ProjectState)> = PublishRelay()
    func notifyClickedItem() -> Signal<(Int, ProjectState)> {
        return notifyClickedItemProperty.asSignal()
    }

    private let selectedItemProperty: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    func selectedItem() -> Driver<Int> {
        return selectedItemProperty.asDriver()
    }

    // MARK: - Lifecycle

    init() {

        projectStatesProperty
            .map { Array($0.enumerated()) }
            .bind(to: tabBarItemsProperty)
            .disposed(by: disposeBag)

        Observable.of(itemClickedProperty, selectItemProperty)
            .merge()
            .bind(to: selectedItemProperty)
            .disposed(by: disposeBag)

        Observable
            .combineLatest(
                itemClickedProperty.asObservable(),
                tabBarItemsProperty.asObservable()
            )
            .map { clicked, items in items[clicked] }
            .bind(to: notifyClickedItemProperty)
            .disposed(by: disposeBag)
    }

    // MARK: - Functions

}
