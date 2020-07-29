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

enum HomeViewControllerData {
    case projectDatail(project: Project)
}

protocol HomeViewModelInputs {
    func showProjectDetail(project: Project)
    func viewWillAppear()
    func refresh()
}

protocol HomeViewModelOutputs {
    func presentViewController() -> Signal<HomeViewControllerData>
    func themedProjects() -> Driver<[ThemedProjects]>
    func isRefreshing() -> Driver<Bool>
    func showError() -> Signal<Error>
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

    private let viewWillAppearProperty: PublishRelay<Void> = PublishRelay()
    func viewWillAppear() {
        viewWillAppearProperty.accept(Void())
    }

    private let refreshProperty: PublishRelay<Void> = PublishRelay()
    func refresh() {
        refreshProperty.accept(Void())
    }

    private let showProjectDetailProperty: PublishRelay<Project> = PublishRelay()
    func showProjectDetail(project: Project) {
        showProjectDetailProperty.accept(project)
    }

    // MARK: - Outputs

    private let themedProjectsProperty: BehaviorRelay<[ThemedProjects]> = BehaviorRelay(value: [])
    func themedProjects() -> Driver<[ThemedProjects]> {
        return themedProjectsProperty.asDriver()
    }

    private let presentViewControllerProperty: PublishRelay<HomeViewControllerData> = PublishRelay()
    func presentViewController() -> Signal<HomeViewControllerData> {
        return presentViewControllerProperty.asSignal()
    }

    private let isRefreshingProperty: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    func isRefreshing() -> Driver<Bool> {
        return isRefreshingProperty.asDriver()
    }

    private let showErrorProperty: PublishRelay<Error> = PublishRelay()
    func showError() -> Signal<Error> {
        return showErrorProperty.asSignal()
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
            .do(onNext: { self.isRefreshingProperty.accept(true) })
            .flatMap(networkService.themedProjects)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .bind(onNext: { result in
                self.isRefreshingProperty.accept(false)
                switch result {
                case .success(let themedProjects):
                    self.themedProjectsProperty.accept(themedProjects)
                case .failure(let error):
                    self.showErrorProperty.accept(error)
                }
            })
            .disposed(by: disposeBag)

        showProjectDetailProperty
            .map(HomeViewControllerData.projectDatail(project:))
            .bind(to: presentViewControllerProperty)
            .disposed(by: disposeBag)

    }

    // MARK: - Functions
}
