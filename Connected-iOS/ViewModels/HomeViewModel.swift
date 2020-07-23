//
//  HomeViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol HomeViewModelInputs {

}

protocol HomeViewModelOutputs {

}

protocol HomeViewModelType {
    var inputs: HomeViewModelInputs { get }
    var outputs: HomeViewModelOutputs { get }
}

final class HomeViewModel: HomeViewModelType, HomeViewModelInputs, HomeViewModelOutputs {

    // MARK: - Properties

    var inputs: HomeViewModelInputs { return self }
    var outputs: HomeViewModelOutputs { return self }
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceType

    // MARK: - Inputs

    // MARK: - Outputs

    // MARK: - Lifecycle

    init(networkService: NetworkServiceType) {
        self.networkService = networkService
    }

    // MARK: - Functions
}
