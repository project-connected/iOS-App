//
//  ProjectDetailViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/23.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ProjectDetailViewModelInputs {
    func deinited()
}

protocol ProjectDetailViewModelOutputs {

}

protocol ProjectDetailViewModelType {
    var inputs: ProjectDetailViewModelInputs { get }
    var outputs: ProjectDetailViewModelOutputs { get }
}

final class ProjectDetailViewModel: ProjectDetailViewModelType,
ProjectDetailViewModelInputs, ProjectDetailViewModelOutputs {

    // MARK: - Properties

    var inputs: ProjectDetailViewModelInputs { return self }
    var outputs: ProjectDetailViewModelOutputs { return self }
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
