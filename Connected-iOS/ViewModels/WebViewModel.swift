//
//  WebViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/30.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol WebViewModelInputs {
    func deinited()
}

protocol WebViewModelOutputs {

}

protocol WebViewModelType {
    var inputs: WebViewModelInputs { get }
    var outputs: WebViewModelOutputs { get }
}

final class WebViewModel: WebViewModelType,
WebViewModelInputs, WebViewModelOutputs {

    // MARK: - Properties

    var inputs: WebViewModelInputs { return self }
    var outputs: WebViewModelOutputs { return self }
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
