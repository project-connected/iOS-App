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

enum TopTabBarItem {
    case recruiting
    case progress
    case complete
}

extension TopTabBarItem {
    var title: String {
        switch self {
        case .recruiting:
            return "모집 중"
        case .progress:
            return "진행 중"
        case .complete:
            return "완료"
        }
    }
}

protocol TopTabBarViewModelInputs {
    func viewDidLoad()
    func itemClicked(index: Int)
}

protocol TopTabBarViewModelOutputs {
    func tabBarItems() -> Driver<[(Int, TopTabBarItem)]>
    func notifyClickedItem() -> Signal<(Int, TopTabBarItem)>
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

    private let viewDidLoadProperty: PublishRelay<Void> = PublishRelay()
    func viewDidLoad() {
        self.viewDidLoadProperty.accept(Void())
    }

    private let itemClickedProperty: PublishRelay<Int> = PublishRelay()
    func itemClicked(index: Int) {
        itemClickedProperty.accept(index)
    }

    // MARK: - Outputs

    private let tabBarItemsProperty: BehaviorRelay<[(Int, TopTabBarItem)]> = BehaviorRelay(value: [])
    func tabBarItems() -> Driver<[(Int, TopTabBarItem)]> {
        return tabBarItemsProperty.asDriver()
    }

    private let notifyClickedItemProperty: PublishRelay<(Int, TopTabBarItem)> = PublishRelay()
    func notifyClickedItem() -> Signal<(Int, TopTabBarItem)> {
        return notifyClickedItemProperty.asSignal()
    }

    private let selectedItemProperty: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    func selectedItem() -> Driver<Int> {
        return selectedItemProperty.asDriver()
    }

    // MARK: - Lifecycle

    init() {

        viewDidLoadProperty
            .map { [TopTabBarItem.recruiting, .progress, .complete] }
            .map { Array($0.enumerated()) }
            .bind(to: tabBarItemsProperty)
            .disposed(by: disposeBag)

        itemClickedProperty
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
