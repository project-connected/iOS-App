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
    func viewWillAppear()
    func refresh()
}

protocol HomeViewModelOutputs {
    func showProjectDetail() -> Signal<Project>
    func projects() -> Driver<[Project]>
    func showErrorMsg() -> Signal<String>
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

    private let viewWillAppearProperty: PublishRelay<Void> = PublishRelay()
    func viewWillAppear() {
        viewWillAppearProperty.accept(Void())
    }

    private let refreshProperty: PublishRelay<Void> = PublishRelay()
    func refresh() {
        refreshProperty.accept(Void())
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

    // MARK: - Lifecycle

    init(networkService: NetworkServiceType) {
        self.networkService = networkService

        let initialRequest = viewWillAppearProperty.take(1)

        let request = Observable.merge(
            initialRequest,
            refreshProperty.asObservable()
        )

        request
            .flatMap { networkService.projects() }
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

        projectClickedProperty
            .bind(to: showProjectDetailProperty)
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
