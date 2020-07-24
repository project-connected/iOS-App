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
    func configure(with projectSubject: HomeProjectSubject)
}

protocol ProjectCollectionCellViewModelOutputs {
    func showProjectDetail() -> Signal<Project>
    func projects() -> Driver<[Project]>
    func showErrorMsg() -> Signal<String>
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
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceType

    // MARK: - Inputs

    private let projectClickedProperty: PublishRelay<Project> = PublishRelay()
    func projectClicked(project: Project) {
        projectClickedProperty.accept(project)
    }

    private let configureProperty: PublishRelay<HomeProjectSubject> = PublishRelay()
    func configure(with projectSubject: HomeProjectSubject) {
        configureProperty.accept(projectSubject)
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

    private let showErrorMsgProperty: PublishRelay<String> = PublishRelay()
    func showErrorMsg() -> Signal<String> {
        return showErrorMsgProperty.asSignal()
    }

    private let collectionTitleProperty: BehaviorRelay<String> = BehaviorRelay(value: "")
    func collectionTitle() -> Driver<String> {
        return collectionTitleProperty.asDriver()
    }

    // MARK: - Lifecycle

    init(networkService: NetworkServiceType) {
        self.networkService = networkService

        configureProperty
            .map { $0.url }
            .flatMap { networkService.projectsWithSubject(subject: $0) }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .bind(onNext: { result in
                switch result {
                case .success(let projects):
                    self.projectsProperty.accept(projects)
                case .failure(let error):
                    self.showErrorMsgProperty.accept(error.localizedDescription)
                }
            })
            .disposed(by: disposeBag)

        configureProperty
            .map { $0.title }
            .bind(to: collectionTitleProperty)
            .disposed(by: disposeBag)

        projectClickedProperty
            .bind(to: showProjectDetailProperty)
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
