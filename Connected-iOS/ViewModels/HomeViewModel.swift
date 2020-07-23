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
    func projectClicked(project: Project)
}

protocol HomeViewModelOutputs {
    func showProjectDetail() -> Signal<Project>
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

    private let projectClickedProperty: PublishRelay<Project> = PublishRelay()
    func projectClicked(project: Project) {
        projectClickedProperty.accept(project)
    }

    // MARK: - Outputs

    private let showProjectDetailProperty: PublishRelay<Project> = PublishRelay()
    func showProjectDetail() -> Signal<Project> {
        return showProjectDetailProperty.asSignal()
    }

    // MARK: - Lifecycle

    init(networkService: NetworkServiceType) {
        self.networkService = networkService

        projectClickedProperty
            .bind(to: showProjectDetailProperty)
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
