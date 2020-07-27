//
//  TopTabBarCellViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/27.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol TopTabBarCellViewModelInputs {
    func configure(with item: (Int, TopTabBarItem))
    func itemSelected(index: Int)
}

protocol TopTabBarCellViewModelOutputs {
    func menuTitle() -> Driver<String>
    func indicatorIsHidden() -> Driver<Bool>
}

protocol TopTabBarCellViewModelType {
    var inputs: TopTabBarCellViewModelInputs { get }
    var outputs: TopTabBarCellViewModelOutputs { get }
}

final class TopTabBarCellViewModel: TopTabBarCellViewModelType,
TopTabBarCellViewModelInputs, TopTabBarCellViewModelOutputs {

    // MARK: - Properties

    var inputs: TopTabBarCellViewModelInputs { return self }
    var outputs: TopTabBarCellViewModelOutputs { return self }
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    private let configureProperty: PublishRelay<(Int, TopTabBarItem)> = PublishRelay()
    func configure(with item: (Int, TopTabBarItem)) {
        configureProperty.accept(item)
    }

    private let itemSelectedProperty: PublishRelay<Int> = PublishRelay()
    func itemSelected(index: Int) {
        itemSelectedProperty.accept(index)
    }

    // MARK: - Outputs

    private let menuTitleProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func menuTitle() -> Driver<String> {
        return menuTitleProperty.asDriver()
    }

    private let indicatorIsHiddenProperty: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    func indicatorIsHidden() -> Driver<Bool> {
        indicatorIsHiddenProperty.asDriver()
    }

    // MARK: - Lifecycle

    init() {
        configureProperty
            .map { $0.1.title }
            .bind(to: menuTitleProperty)
            .disposed(by: disposeBag)

        let itemIndex = configureProperty.map { $0.0 }

        Observable.combineLatest(itemIndex, itemSelectedProperty)
            .map { $0.0 == $0.1 }
            .map { !$0 }
            .bind(to: indicatorIsHiddenProperty)
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
