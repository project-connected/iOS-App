//
//  ProjectCollectionCellViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/24.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProjectCollectionCellViewModelInputs {
    func projectClicked(project: Project)
    func configure(with themedProjects: ThemedProjects)
    func deinited()
}

protocol ProjectCollectionCellViewModelOutputs {
    func showProjectDetail() -> Signal<Project>
    func projects() -> Driver<[Project]>
    func collectionTitle() -> Driver<String>
}

protocol ProjectCollectionCellViewModelType {
    var inputs: ProjectCollectionCellViewModelInputs { get }
    var outputs: ProjectCollectionCellViewModelOutputs { get }
}

final class ProjectCollectionCellViewModel: ProjectCollectionCellViewModelType,
ProjectCollectionCellViewModelInputs, ProjectCollectionCellViewModelOutputs {

    // MARK: - Properties

    var inputs: ProjectCollectionCellViewModelInputs { return self }
    var outputs: ProjectCollectionCellViewModelOutputs { return self }
    private var disposeBag = DisposeBag()

    // MARK: - Inputs

    private let projectClickedProperty: PublishRelay<Project> = PublishRelay()
    func projectClicked(project: Project) {
        projectClickedProperty.accept(project)
    }

    private let configureProperty: PublishRelay<ThemedProjects> = PublishRelay()
    func configure(with themedProjects: ThemedProjects) {
        configureProperty.accept(themedProjects)
    }

     private let deinitedProperty: PublishRelay<Void> = PublishRelay()
     func deinited() {
         deinitedProperty.accept(Void())
     }

    // MARK: - Outputs

    private let showProjectDetailProperty: PublishRelay<Project> = PublishRelay()
    func showProjectDetail() -> Signal<Project> {
        return showProjectDetailProperty.asSignal()
    }

    private let projectsProperty: BehaviorRelay<[Project]> = BehaviorRelay(value: [])
    func projects() -> Driver<[Project]> {
        return projectsProperty.asDriver()
    }

    private let collectionTitleProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func collectionTitle() -> Driver<String> {
        return collectionTitleProperty.asDriver()
    }

    // MARK: - Lifecycle

    init() {

        let themedProjects = configureProperty

        themedProjects
            .map { $0.projects }
            .bind(to: projectsProperty)
            .disposed(by: disposeBag)

        themedProjects
            .map { $0.theme }
            .bind(to: collectionTitleProperty)
            .disposed(by: disposeBag)

        projectClickedProperty
            .bind(to: showProjectDetailProperty)
            .disposed(by: disposeBag)

        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
