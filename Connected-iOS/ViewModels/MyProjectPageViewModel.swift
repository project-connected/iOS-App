//
//  MyProjectPageViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyProjectPageViewModelInputs {
    func refresh()
}

protocol MyProjectPageViewModelOutputs {

}

protocol MyProjectPageViewModelType {
    var inputs: MyProjectPageViewModelInputs { get }
    var outputs: MyProjectPageViewModelOutputs { get }
}

final class MyProjectPageViewModel: MyProjectPageViewModelType,
MyProjectPageViewModelInputs, MyProjectPageViewModelOutputs {

    // MARK: - Properties

    var inputs: MyProjectPageViewModelInputs { return self }
    var outputs: MyProjectPageViewModelOutputs { return self }
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceType

    // MARK: - Inputs

    private let refreshProperty: PublishRelay<Void> = PublishRelay()
    func refresh() {
        refreshProperty.accept(Void())
    }

    // MARK: - Outputs

    // MARK: - Lifecycle

    init(networkService: NetworkServiceType) {
        self.networkService = networkService

    }

    // MARK: - Functions
}
