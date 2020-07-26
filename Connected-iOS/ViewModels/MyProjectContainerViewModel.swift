//
//  MyProjectContainerViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol MyProjectContainerViewModelInputs {

}

protocol MyProjectContainerViewModelOutputs {

}

protocol MyProjectContainerViewModelType {
    var inputs: MyProjectContainerViewModelInputs { get }
    var outputs: MyProjectContainerViewModelOutputs { get }
}

final class MyProjectContainerViewModel: MyProjectContainerViewModelType,
MyProjectContainerViewModelInputs, MyProjectContainerViewModelOutputs {

    // MARK: - Properties

    var inputs: MyProjectContainerViewModelInputs { return self }
    var outputs: MyProjectContainerViewModelOutputs { return self }
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    // MARK: - Outputs

    // MARK: - Lifecycle

    init() {

    }

    // MARK: - Functions
}
