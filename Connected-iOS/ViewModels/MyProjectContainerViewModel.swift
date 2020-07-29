//
//  MyProjectContainerViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/26.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift

enum ProjectState {
    case recruiting
    case progress
    case complete
}

extension ProjectState {
    var string: String {
        switch self {
        case .recruiting:
            return "모집 중"
        case .progress:
            return "진행 중"
        case .complete:
            return "완료"
        }
    }
}

protocol MyProjectContainerViewModelInputs {
    func viewDidLoad()
    func viewDidAppear()
    func topTabBarItemClicked(index: Int, item: ProjectState)
    func pageTransition(to index: Int)
}

protocol MyProjectContainerViewModelOutputs {
    func projectStates() -> Driver<[ProjectState]>
    func pageToIndex() -> Signal<(Int, Bool)>
    func selectTopTabBarItem() -> Signal<Int>
}

protocol MyProjectContainerViewModelType {
    var inputs: MyProjectContainerViewModelInputs { get }
    var outputs: MyProjectContainerViewModelOutputs { get }
}

final class MyProjectContainerViewModel: MyProjectContainerViewModelType,
MyProjectContainerViewModelInputs, MyProjectContainerViewModelOutputs {

    // MARK: - Properties

    var inputs: MyProjectContainerViewModelInputs { return self }
    var outputs: MyProjectContainerViewModelOutputs { return self }
    private let disposeBag = DisposeBag()

    // MARK: - Inputs

    private let viewDidLoadProperty: PublishRelay<Void> = PublishRelay()
    func viewDidLoad() {
        viewDidLoadProperty.accept(Void())
    }

    private let viewDidAppearProperty: PublishRelay<Void> = PublishRelay()
    func viewDidAppear() {
        viewDidAppearProperty.accept(Void())
    }

    private let topTabBarItemClickedProperty: PublishRelay<(Int, ProjectState)> = PublishRelay()
    func topTabBarItemClicked(index: Int, item: ProjectState) {
        topTabBarItemClickedProperty.accept((index, item))
    }

    private let pageTransitionProperty: PublishRelay<Int> = PublishRelay()
    func pageTransition(to index: Int) {
        pageTransitionProperty.accept(index)
    }

    // MARK: - Outputs

    private let projectStatesProperty: BehaviorRelay<[ProjectState]> = BehaviorRelay(value: [])
    func projectStates() -> Driver<[ProjectState]> {
        return projectStatesProperty.asDriver()
    }

    private let pageToIndexProperty: PublishRelay<(Int, Bool)> = PublishRelay()
    func pageToIndex() -> Signal<(Int, Bool)> {
        return pageToIndexProperty.asSignal()
    }

    private let selectTopTabBarItemProperty: PublishRelay<Int> = PublishRelay()
    func selectTopTabBarItem() -> Signal<Int> {
        return selectTopTabBarItemProperty.asSignal()
    }

    // MARK: - Lifecycle

    init() {

        viewDidLoadProperty
            .map { [ProjectState.recruiting, .progress, .complete] }
            .bind(to: projectStatesProperty)
            .disposed(by: disposeBag)

        let index = Observable.merge(
            viewDidAppearProperty.take(1).map { 0 },
            topTabBarItemClickedProperty.map { $0.0 },
            pageTransitionProperty.asObservable()
        ).distinctUntilChanged()

        index
            .scan((0, true)) { before, index in (index, before.0 < index) }
            .bind(to: pageToIndexProperty)
            .disposed(by: disposeBag)

        index
            .bind(to: selectTopTabBarItemProperty)
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
