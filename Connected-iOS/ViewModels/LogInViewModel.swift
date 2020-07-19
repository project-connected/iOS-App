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
    case logIn
}

protocol LogInViewModelInputs {
    func signUpClicked()
    func logInClicked()
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
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    private let btnClickedProperty: PublishRelay<LogInViewControllerData>
        = PublishRelay()

    func logInClicked() {
        self.btnClickedProperty.accept(.logIn)
    }

    func signUpClicked() {
        self.btnClickedProperty.accept(.signUp)
    }

    // MARK: - Outputs

    private let displayViewControllerProperty: Signal<LogInViewControllerData>
    func displayViewController() -> Signal<LogInViewControllerData> {
        return self.displayViewControllerProperty
    }

    // MARK: - Lifecycle

    init() {
        self.displayViewControllerProperty = self.btnClickedProperty.asSignal()

    }

    // MARK: - Functions
}
