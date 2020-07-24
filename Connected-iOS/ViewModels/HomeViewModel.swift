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

enum HomeProjectSubject {
    case popular
}

extension HomeProjectSubject {
    var title: String {
        switch self {
        case .popular:
            return "인기 있는"
        }
    }

    var url: String {
        switch self {
        case .popular:
            return "popular"
        }
    }
}

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
    func projectSubjects() -> Driver<[HomeProjectSubject]>
//    func showErrorMsg() -> Signal<String>
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

    private let projectSubjectsProperty: BehaviorRelay<[HomeProjectSubject]> = BehaviorRelay(value: [])
    func projectSubjects() -> Driver<[HomeProjectSubject]> {
        return projectSubjectsProperty.asDriver()
    }

    private let presentViewControllerProperty: PublishRelay<HomeViewControllerData> = PublishRelay()
    func presentViewController() -> Signal<HomeViewControllerData> {
        return presentViewControllerProperty.asSignal()
    }

//    private let showErrorMsgProperty: PublishRelay<String> = PublishRelay()
//    func showErrorMsg() -> Signal<String> {
//        return showErrorMsgProperty.asSignal()
//    }

    // MARK: - Lifecycle

    init(networkService: NetworkServiceType) {
        self.networkService = networkService

        let initialRequest = viewWillAppearProperty.take(1)

        let request = Observable.merge(
            initialRequest,
            refreshProperty.asObservable()
        )

        request
            .map { _ in [HomeProjectSubject.popular, .popular] }
            .bind(to: projectSubjectsProperty)
            .disposed(by: disposeBag)

        showProjectDetailProperty
            .map(HomeViewControllerData.projectDatail(project:))
            .bind(to: presentViewControllerProperty)
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
