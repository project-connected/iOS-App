//
//  HomeContainerViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/24.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeContainerViewModelInputs {
    func deinited()
}

protocol HomeContainerViewModelOutputs {

}

protocol HomeContainerViewModelType {
    var inputs: HomeContainerViewModelInputs { get }
    var outputs: HomeContainerViewModelOutputs { get }
}

final class HomeContainerViewModel: HomeContainerViewModelType,
HomeContainerViewModelInputs, HomeContainerViewModelOutputs {

    // MARK: - Properties

    var inputs: HomeContainerViewModelInputs { return self }
    var outputs: HomeContainerViewModelOutputs { return self }
    private var disposeBag = DisposeBag()

    // MARK: - Inputs

    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }

    // MARK: - Outputs

    // MARK: - Lifecycle

    init() {

        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)

    }

    // MARK: - Functions
}
