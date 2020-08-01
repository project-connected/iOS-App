//
//  LogInViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/19.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum LogInViewControllerData {
    case signUp
    case signIn
}

protocol LogInViewModelInputs {
    func signUpClicked()
    func signInClicked()
    func deinited()
}

protocol LogInViewModelOutputs {
    func displayViewController() -> Signal<LogInViewControllerData>
}

protocol LogInViewModelType {
    var inputs: LogInViewModelInputs { get }
    var outputs: LogInViewModelOutputs { get }
}

final class LogInViewModel: LogInViewModelType, LogInViewModelInputs, LogInViewModelOutputs {

    var inputs: LogInViewModelInputs { return self }
    var outputs: LogInViewModelOutputs { return self }
    private var disposeBag = DisposeBag()

    // MARK: - Inputs

    private let btnClickedProperty: PublishRelay<LogInViewControllerData>
        = PublishRelay()

    func signInClicked() {
        btnClickedProperty.accept(.signIn)
    }

    func signUpClicked() {
        btnClickedProperty.accept(.signUp)
    }

    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }

    // MARK: - Outputs

    private let displayViewControllerProperty: PublishRelay<LogInViewControllerData> = PublishRelay()
    func displayViewController() -> Signal<LogInViewControllerData> {
        return displayViewControllerProperty.asSignal()
    }

    // MARK: - Lifecycle

    init() {
        btnClickedProperty
            .bind(to: displayViewControllerProperty)
            .disposed(by: disposeBag)

        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
