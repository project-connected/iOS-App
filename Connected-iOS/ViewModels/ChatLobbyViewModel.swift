//
//  ChatLobbyViewModel.swift
//  Connected-iOS
//
//  Created by Jaedoo Ko on 2020/07/28.
//  Copyright © 2020 connected. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ChatLobbyViewModelInputs {
    func viewDidLoad()
    func pullToRefresh()
    func chatRoomClicked(chatRoom: ChatRoom)
    func deinited()
}

protocol ChatLobbyViewModelOutputs {
    func chatRooms() -> Driver<[ChatRoom]>
    func showErrorMsg() -> Signal<Error>
    func isRefreshing() -> Driver<Bool>
    func showChatRoom() -> Signal<ChatRoom>
}

protocol ChatLobbyViewModelType {
    var inputs: ChatLobbyViewModelInputs { get }
    var outputs: ChatLobbyViewModelOutputs { get }
}

final class ChatLobbyViewModel: ChatLobbyViewModelType,
ChatLobbyViewModelInputs, ChatLobbyViewModelOutputs {

    // MARK: - Properties

    var inputs: ChatLobbyViewModelInputs { return self }
    var outputs: ChatLobbyViewModelOutputs { return self }
    private var disposeBag = DisposeBag()
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

    private let chatRoomClickedProperty: PublishRelay<ChatRoom> = PublishRelay()
    func chatRoomClicked(chatRoom: ChatRoom) {
        chatRoomClickedProperty.accept(chatRoom)
    }

    private let deinitedProperty: PublishRelay<Void> = PublishRelay()
    func deinited() {
        deinitedProperty.accept(Void())
    }

    // MARK: - Outputs

    private let chatRoomsProperty: BehaviorRelay<[ChatRoom]> = BehaviorRelay(value: [])
    func chatRooms() -> Driver<[ChatRoom]> {
        return chatRoomsProperty.asDriver()
    }

    private let showErrorMsgProperty: PublishRelay<Error> = PublishRelay()
    func showErrorMsg() -> Signal<Error> {
        return showErrorMsgProperty.asSignal()
    }

    private let isRefreshingProperty: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    func isRefreshing() -> Driver<Bool> {
        return isRefreshingProperty.asDriver()
    }

    private let showChatRoomProperty: PublishRelay<ChatRoom> = PublishRelay()
    func showChatRoom() -> Signal<ChatRoom> {
        return showChatRoomProperty.asSignal()
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
            .flatMap { networkService.chatRooms() }
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .bind(onNext: { result in
                self.isRefreshingProperty.accept(false)
                switch result {
                case .success(let rooms):
                    self.chatRoomsProperty.accept(rooms)
                case .failure(let error):
                    self.showErrorMsgProperty.accept(error)
                }
            })
            .disposed(by: disposeBag)

        chatRoomClickedProperty
            .bind(to: showChatRoomProperty)
            .disposed(by: disposeBag)

        deinitedProperty
            .bind(onNext: { self.disposeBag = DisposeBag() })
            .disposed(by: disposeBag)
    }

    // MARK: - Functions
}
