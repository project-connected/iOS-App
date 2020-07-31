//
//  ErrorCellViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/25.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ErrorCellViewModelInputs {
    func configure(with error: Error)
    func deinited()
}

protocol ErrorCellViewModelOutputs {
    func errorTitle() -> Driver<String>
    func errorMsg() -> Driver<String>
}

protocol ErrorCellViewModelType {
    var inputs: ErrorCellViewModelInputs { get }
    var outputs: ErrorCellViewModelOutputs { get }
}

final class ErrorCellViewModel: ErrorCellViewModelType,
ErrorCellViewModelInputs, ErrorCellViewModelOutputs {

    // MARK: - Properties

    var inputs: ErrorCellViewModelInputs { return self }
    var outputs: ErrorCellViewModelOutputs { return self }
    private var disposeBag = DisposeBag()

    // MARK: - Inputs

    private let configureProperty: PublishRelay<Error> = PublishRelay()
    func configure(with error: Error) {
        configureProperty.accept(error)
    }

    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }

    // MARK: - Outputs

    private let errorTitleProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func errorTitle() -> Driver<String> {
        return errorTitleProperty.asDriver()
    }

    private let errorMsgProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func errorMsg() -> Driver<String> {
        return errorMsgProperty.asDriver()
    }

    // MARK: - Lifecycle

    init() {

        let error = configureProperty

        error
            .map { _ in "에러 발생!" }
            .bind(to: errorTitleProperty)
            .disposed(by: disposeBag)

        error
            .map { $0.localizedDescription }
            .bind(to: errorMsgProperty)
            .disposed(by: disposeBag)

        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
