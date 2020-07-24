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
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    // MARK: - Outputs

    // MARK: - Lifecycle

    init() {

    }

    // MARK: - Functions
}
