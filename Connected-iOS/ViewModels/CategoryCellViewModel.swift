//
//  CategoryCellViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/25.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol CategoryCellViewModelInputs {
    func configure(with category: String)
    func deinited()
}

protocol CategoryCellViewModelOutputs {
    func category() -> Driver<String>
}

protocol CategoryCellViewModelType {
    var inputs: CategoryCellViewModelInputs { get }
    var outputs: CategoryCellViewModelOutputs { get }
}

final class CategoryCellViewModel: CategoryCellViewModelType,
CategoryCellViewModelInputs, CategoryCellViewModelOutputs {

    // MARK: - Properties

    var inputs: CategoryCellViewModelInputs { return self }
    var outputs: CategoryCellViewModelOutputs { return self }
    private var disposeBag = DisposeBag()

    // MARK: - Inputs

    private let configureProperty: PublishRelay<String> = PublishRelay()
    func configure(with category: String) {
        configureProperty.accept(category)
    }

    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }

    // MARK: - Outputs

    private let categoryProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func category() -> Driver<String> {
        return categoryProperty.asDriver()
    }

    // MARK: - Lifecycle

    init() {
        configureProperty
            .bind(to: categoryProperty)
            .disposed(by: disposeBag)

        deinitedProperty
                  .bind(onNext: { self.disposeBag = DisposeBag() })
                  .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
