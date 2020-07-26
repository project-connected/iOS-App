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
    case progress
    case complete
}

extension TopTabBarItem {
    var title: String {
        switch self {
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
    func tabBarItems() -> Driver<[TopTabBarItem]>
    func notifyClickedItem() -> Signal<TopTabBarItem>
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

    private let tabBarItemsProperty: BehaviorRelay<[TopTabBarItem]> = BehaviorRelay(value: [])
    func tabBarItems() -> Driver<[TopTabBarItem]> {
        return tabBarItemsProperty.asDriver()
    }

    private let notifyClickedItemProperty: PublishRelay<TopTabBarItem> = PublishRelay()
    func notifyClickedItem() -> Signal<TopTabBarItem> {
        return notifyClickedItemProperty.asSignal()
    }

    // MARK: - Lifecycle

    init() {

        viewDidLoadProperty
            .map { [.progress, .complete, .progress, .complete, .progress, .complete] }
            .bind(to: tabBarItemsProperty)
            .disposed(by: disposeBag)

        itemClickedProperty
            .withLatestFrom(tabBarItemsProperty) { (index, items) in items[index] }
            .bind(to: notifyClickedItemProperty)
            .disposed(by: disposeBag)
    }

    // MARK: - Functions

}
