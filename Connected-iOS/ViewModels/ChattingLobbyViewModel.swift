//
//  ChattingLobbyViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChattingLobbyViewModelInputs {
    func viewDidLoad()
    func pullToRefresh()
}

protocol ChattingLobbyViewModelOutputs {
    func chattingRooms() -> Driver<[ChattingRoom]>
    func showErrorMsg() -> Signal<Error>
    func isRefreshing() -> Driver<Bool>
}

protocol ChattingLobbyViewModelType {
    var inputs: ChattingLobbyViewModelInputs { get }
    var outputs: ChattingLobbyViewModelOutputs { get }
}

final class ChattingLobbyViewModel: ChattingLobbyViewModelType,
ChattingLobbyViewModelInputs, ChattingLobbyViewModelOutputs {

    // MARK: - Properties

    var inputs: ChattingLobbyViewModelInputs { return self }
    var outputs: ChattingLobbyViewModelOutputs { return self }
    private let disposeBag = DisposeBag()
    private let networkService: NetworkServiceType

    // MARK: - Inputs

    private let viewDidLoadProperty: PublishRelay<Void> = PublishRelay()
    func viewDidLoad() {
        viewDidLoadProperty.accept(Void())
    }

    private let pullToRefreshProperty: PublishRelay<Void> = PublishRelay()
    func pullToRefresh() {
        pullToRefreshProperty.accept(Void())
    }

    // MARK: - Outputs

    private let chattingRoomsProperty: BehaviorRelay<[ChattingRoom]> = BehaviorRelay(value: [])
    func chattingRooms() -> Driver<[ChattingRoom]> {
        return chattingRoomsProperty.asDriver()
    }

    private let showErrorMsgProperty: PublishRelay<Error> = PublishRelay()
    func showErrorMsg() -> Signal<Error> {
        return showErrorMsgProperty.asSignal()
    }

    private let isRefreshingProperty: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    func isRefreshing() -> Driver<Bool> {
        return isRefreshingProperty.asDriver()
    }

    // MARK: - Lifecycle

    init(
        networkService: NetworkServiceType
    ) {
        self.networkService = networkService

        let request = Observable
            .of(viewDidLoadProperty, pullToRefreshProperty)
            .merge()

        request
            .do(onNext: { self.isRefreshingProperty.accept(true) })
            .flatMap { networkService.chattingRooms() }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .bind(onNext: { result in
                self.isRefreshingProperty.accept(false)
                switch result {
                case .success(let rooms):
                    self.chattingRoomsProperty.accept(rooms)
                case .failure(let error):
                    self.showErrorMsgProperty.accept(error)
                }
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
