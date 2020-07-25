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
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    // MARK: - Outputs

    // MARK: - Lifecycle

    init() {

    }

    // MARK: - Functions
}
