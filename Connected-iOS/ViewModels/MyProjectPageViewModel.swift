//
//  MyProjectPageViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol MyProjectPageViewModelInputs {
    func viewDidLoad()
    func refresh()
    func deinited()
}

protocol MyProjectPageViewModelOutputs {
    func isRefreshing() -> Driver<Bool>
}

protocol MyProjectPageViewModelType {
    var inputs: MyProjectPageViewModelInputs { get }
    var outputs: MyProjectPageViewModelOutputs { get }
}

final class MyProjectPageViewModel: MyProjectPageViewModelType,
MyProjectPageViewModelInputs, MyProjectPageViewModelOutputs {

    // MARK: - Properties

    var inputs: MyProjectPageViewModelInputs { return self }
    var outputs: MyProjectPageViewModelOutputs { return self }
    private var disposeBag = DisposeBag()
    private let networkService: NetworkServiceType

    // MARK: - Inputs

    private let viewDidLoadProperty: PublishRelay<Void> = PublishRelay()
    func viewDidLoad() {
        viewDidLoadProperty.accept(Void())
    }

    private let refreshProperty: PublishRelay<Void> = PublishRelay()
    func refresh() {
        refreshProperty.accept(Void())
    }

    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }

    // MARK: - Outputs

    private let isRefreshingProperty: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    func isRefreshing() -> Driver<Bool> {
        return isRefreshingProperty.asDriver()
    }

    // MARK: - Lifecycle

    init(networkService: NetworkServiceType) {
        self.networkService = networkService

        let request = Observable
            .of(viewDidLoadProperty, refreshProperty)
            .merge()

        request
            .do(onNext: { self.isRefreshingProperty.accept(true) })
            .map { Result<Int, Error>.success(1) }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .bind(onNext: { result in
                self.isRefreshingProperty.accept(false)
                switch result {
                case .success(let item):
                    print(item)
                case .failure(let error):
                    print(error)
                }
            })
            .disposed(by: disposeBag)

        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
