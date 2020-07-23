//
//  ProjectThumbnailCellViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/22.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProjectThumbnailCellViewModelInputs {
    func configure(with project: Project)
}

protocol ProjectThumbnailCellViewModelOutputs {
    func projectName() -> Driver<String>
    func projectThumbnailImageUrl() -> Driver<String>
    func projectCategories() -> Driver<[String]>
}

protocol ProjectThumbnailCellViewModelType {
    var inputs: ProjectThumbnailCellViewModelInputs { get }
    var outputs: ProjectThumbnailCellViewModelOutputs { get }
}

final class ProjectThumbnailCellViewModel: ProjectThumbnailCellViewModelType,
ProjectThumbnailCellViewModelInputs, ProjectThumbnailCellViewModelOutputs {

    // MARK: - Properties

    var inputs: ProjectThumbnailCellViewModelInputs { return self }
    var outputs: ProjectThumbnailCellViewModelOutputs { return self }
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    private let configureProperty: PublishRelay<Project> = PublishRelay()
    func configure(with project: Project) {
        configureProperty.accept(project)
    }

    // MARK: - Outputs

    private let projectNameProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func projectName() -> Driver<String> {
        return projectNameProperty.asDriver()
    }

    private let projectThumbnailImageUrlProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func projectThumbnailImageUrl() -> Driver<String> {
        return projectThumbnailImageUrlProperty.asDriver()
    }

    private let projectCategoriesProperty: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    func projectCategories() -> Driver<[String]> {
        return projectCategoriesProperty.asDriver()
    }

    // MARK: - Lifecycle

    init() {
        let project = configureProperty

        project
            .map { $0.name }
            .bind(to: projectNameProperty)
            .disposed(by: disposeBag)

        project
            .map { $0.thumbnailImageUrl }
            .bind(to: projectThumbnailImageUrlProperty)
            .disposed(by: disposeBag)

        project
            .map { $0.categories }
            .bind(to: projectCategoriesProperty)
            .disposed(by: disposeBag)

    }

    // MARK: - Functions
}
