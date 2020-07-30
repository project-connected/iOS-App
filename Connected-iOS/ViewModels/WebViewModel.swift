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
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    // MARK: - Outputs

    // MARK: - Lifecycle

    init() {

    }

    // MARK: - Functions
}
